//
//  DJUncaughtExceptionHandler.h
//  DejiPlaza
//
//  Created by mengshun on 2022/6/9.
//  Copyright © 2022 Deji. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;

/// 上一次打开app 是否发生了 crash
+ (BOOL)lastOpenCrashed;

/// 清除crash 记录
+ (void)clearCrashRecord;

@end

NS_ASSUME_NONNULL_END
