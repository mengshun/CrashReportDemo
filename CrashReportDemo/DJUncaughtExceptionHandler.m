//
//  DJUncaughtExceptionHandler.m
//  DejiPlaza
//
//  Created by mengshun on 2022/6/9.
//  Copyright © 2022 Deji. All rights reserved.
//

#import "DJUncaughtExceptionHandler.h"

static NSString *_lastOpenCrashedKey = @"_lastOpenCrashedKey";

@implementation DJUncaughtExceptionHandler

static NSUncaughtExceptionHandler *_otherHandler;

// 崩溃时的回调函数
void UncaughtExceptionHandler(NSException * exception) {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_lastOpenCrashedKey];
    NSArray * arr = [exception callStackSymbols];
    NSString * reason = [exception reason]; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * name = [exception name];
    NSString * crashInfo = [NSString stringWithFormat:@"crash1 info:\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    [[NSUserDefaults standardUserDefaults] setObject:crashInfo forKey:@"crash_info"];
        NSLog(@"crash 1: %@", crashInfo);
    if (_otherHandler) {
        NSSetUncaughtExceptionHandler(_otherHandler);
        _otherHandler(exception);
    }
    killAction();
}

void catchSignalException(int code) {
    //    NSLog(@"crash 2: %d", code);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:_lastOpenCrashedKey];
    [[NSUserDefaults standardUserDefaults] setObject:@(code) forKey:@"crash_info"];
    
    NSArray * arr = [NSThread callStackSymbols];
    NSString * reason = @"Swift crash reason"; // // 崩溃的原因  可以有崩溃的原因(数组越界,字典nil,调用未知方法...) 崩溃的控制器以及方法
    NSString * name = @"Swift crash name";
    NSString * crashInfo = [NSString stringWithFormat:@"crash2 info:\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@",name,reason,[arr componentsJoinedByString:@"\n"]];
    [[NSUserDefaults standardUserDefaults] setObject:crashInfo forKey:@"crash_info"];
    killAction();
}

void killAction(void) {
    signal(SIGABRT, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGTRAP, SIG_DFL);
    kill(getpid(), SIGKILL);
}

+ (void)setDefaultHandler {    
    signal(SIGABRT, catchSignalException);
    signal(SIGBUS, catchSignalException);
    signal(SIGFPE, catchSignalException);
    signal(SIGILL, catchSignalException);
    signal(SIGSEGV, catchSignalException);
    signal(SIGTRAP, catchSignalException);
    _otherHandler = NSGetUncaughtExceptionHandler();
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

/// 上一次打开app 是否发生了 crash
+ (BOOL)lastOpenCrashed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:_lastOpenCrashedKey];
}

/// 清除crash 记录
+ (void)clearCrashRecord {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_lastOpenCrashedKey];
}

@end
