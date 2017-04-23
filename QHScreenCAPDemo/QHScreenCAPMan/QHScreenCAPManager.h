//
//  QHScreenCAPManager.h
//  QHScreenCAPDemo
//
//  Created by chen on 2017/4/23.
//  Copyright © 2017年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QHScreenCAPManager;

@protocol QHScreenCAPManagerDelegate <NSObject>

- (void)closeScreenCAPManager:(QHScreenCAPManager *)manager;

@end

@interface QHScreenCAPManager : NSObject

@property (nonatomic, weak) id<QHScreenCAPManagerDelegate> delegate;

+ (QHScreenCAPManager *)createScreenCAPManager;

@end
