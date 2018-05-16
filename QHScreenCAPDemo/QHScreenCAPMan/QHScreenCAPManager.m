//
//  QHScreenCAPManager.m
//  QHScreenCAPDemo
//
//  Created by chen on 2017/4/23.
//  Copyright © 2017年 chen. All rights reserved.
//

#import "QHScreenCAPManager.h"

#import "ASScreenRecorder.h"

#import "QHScreenCAPViewController.h"

@interface QHScreenCAPManager () <QHScreenCAPViewControllerDelegate, ASScreenRecorderDelegate>

@property (nonatomic, strong) UIWindow *screenCAPWindow;

@property (nonatomic, strong) QHScreenCAPViewController *screenCAPVC;

@end

@implementation QHScreenCAPManager

- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
    
    self.screenCAPWindow = nil;
    self.screenCAPVC = nil;
}

+ (QHScreenCAPManager *)createScreenCAPManager {
    QHScreenCAPManager *manager = [[QHScreenCAPManager alloc] init];
    
    manager.screenCAPWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    manager.screenCAPVC = [[QHScreenCAPViewController alloc] init];
    manager.screenCAPVC.delegate = manager;
    manager.screenCAPWindow.rootViewController = manager.screenCAPVC;
    
    manager.screenCAPWindow.windowLevel = UIWindowLevelNormal;
    
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    recorder.delegate = manager;
    
    [manager.screenCAPWindow makeKeyAndVisible];
    
    return manager;
}

#pragma mark - util

- (NSURL*)videoTempFileURL {
    NSString *outputPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/screenCAP.mov"];
    [self removeTempFilePath:outputPath];
    return [NSURL fileURLWithPath:outputPath];
}

- (void)removeTempFilePath:(NSString*)filePath {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError* error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            NSLog(@"Could not delete old recording:%@", [error localizedDescription]);
        }
    }
}

#pragma mark - ASScreenRecorderDelegate

- (UIWindow *)screenRecordWindow {
    return [[UIApplication sharedApplication].delegate window];
}

#pragma mark - QHScreenCAPViewControllerDelegate

- (void)restartScreenCAP:(QHScreenCAPViewController *)vc {
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    [recorder closeRecordingWithCompletion:^{
        [recorder startRecording];
    }];
}

- (BOOL)startScreenCAP:(QHScreenCAPViewController *)vc {
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    if (recorder.isRecording) {
        __weak typeof(self) weakSelf = self;
        [recorder stopRecordingWithCompletion:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (recorder.videoURL != nil) {
                [strongSelf.screenCAPVC playResultAction:recorder.videoURL];
            }
        }];
    } else {
        
        //!!!这句注释后就不会出预览的录屏结果，而是将录屏结果保存到相册里面
        
        recorder.videoURL = [self videoTempFileURL];
        [recorder startRecording];
    }
    return recorder.isRecording;
}

- (void)closeScreenCAP:(QHScreenCAPViewController *)vc {
    __weak typeof(self) weakSelf = self;
    
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    [recorder closeRecordingWithCompletion:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.screenCAPWindow.rootViewController = nil;
        [strongSelf.screenCAPWindow resignKeyWindow];
        strongSelf.screenCAPWindow = nil;
        [[[UIApplication sharedApplication].delegate window] makeKeyAndVisible];
        
        [strongSelf.delegate closeScreenCAPManager:strongSelf];
    }];
}

@end
