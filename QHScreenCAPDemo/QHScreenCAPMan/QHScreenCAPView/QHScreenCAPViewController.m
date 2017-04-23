//
//  QHScreenCAPViewController.m
//  QHScreenCAPDemo
//
//  Created by chen on 2017/4/23.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "QHScreenCAPViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface QHScreenCAPViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startScreenCAPButton;

@property (weak, nonatomic) IBOutlet UIView *screenCAPResultV;
@property (weak, nonatomic) IBOutlet UIView *playerV;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end

@implementation QHScreenCAPViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    self.player = nil;
    self.playerLayer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Action

- (IBAction)restartScreenCAPAction:(id)sender {
    [self.delegate restartScreenCAP:self];
    self.startScreenCAPButton.selected = YES;
    [self.startScreenCAPButton setBackgroundColor:[UIColor greenColor]];
}

- (IBAction)startScreenCAPAction:(id)sender {
    BOOL bRecording = [self.delegate startScreenCAP:self];
    self.startScreenCAPButton.selected = bRecording;
    if (bRecording == YES) {
        [self.startScreenCAPButton setBackgroundColor:[UIColor greenColor]];
    }
    else {
        [self.startScreenCAPButton setBackgroundColor:[UIColor redColor]];
    }
}

- (IBAction)closeScreenCAPAction:(id)sender {
    [self.startScreenCAPButton setBackgroundColor:[UIColor redColor]];
    [self.delegate closeScreenCAP:self];
}

- (IBAction)closeScreenCAPResultAction:(id)sender {
    [self.player pause];
    self.screenCAPResultV.hidden = YES;
}

- (void)playResultAction:(NSURL *)playUrl {
    self.screenCAPResultV.hidden = NO;
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:playUrl];
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.playerV.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.playerV.bounds;
    [self.player play];
}

@end
