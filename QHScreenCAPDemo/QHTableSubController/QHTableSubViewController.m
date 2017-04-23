//
//  QHTableSubViewController.m
//  QHTableViewDemo
//
//  Created by chen on 17/3/21.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "QHTableSubViewController.h"

#import "NSTimer+EOCBlocksSupport.h"
#import "ASScreenRecorder.h"

#import "QHScreenCAPManager.h"

@interface QHTableSubViewController () <QHScreenCAPManagerDelegate>

@property (nonatomic, strong) NSTimer *showTimer;
@property (weak, nonatomic) IBOutlet UILabel *showL;
@property (nonatomic) NSUInteger timeCount;

@property (nonatomic, strong) QHScreenCAPManager *screenCAPManager;

@end

@implementation QHTableSubViewController

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    
    [self.showTimer invalidate];
    self.showTimer = nil;
    
    self.screenCAPManager = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.timeCount = 0;
    
    __weak typeof(self) weakSelf = self;
    self.showTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:1 block:^{
        weakSelf.timeCount++;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.showL.text = [NSString stringWithFormat:@"%lu", (unsigned long)weakSelf.timeCount];
        });
    } repeats:YES];
    
    [self.showTimer fire];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QHScreenCAPManagerDelegate

- (void)closeScreenCAPManager:(QHScreenCAPManager *)manager {
    self.screenCAPManager = nil;
}

#pragma mark - Action

- (IBAction)screenCAPAction:(id)sender {
    self.screenCAPManager = [QHScreenCAPManager createScreenCAPManager];
    self.screenCAPManager.delegate = self;
}

@end
