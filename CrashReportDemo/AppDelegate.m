//
//  AppDelegate.m
//  CrashReportDemo
//
//  Created by mengshun on 2022/6/13.
//

#import "AppDelegate.h"
#import "DJUncaughtExceptionHandler.h"
#import "CrashReportDemo-Swift.h"
#import <QAPM/QAPM.h>

#if defined(DEBUG)
#define USE_VM_LOGGER
#ifdef USE_VM_LOGGER
/// 私有API请不要在发布APPSotre时使用。
typedef void (malloc_logger_t)(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t num_hot_frames_to_skip);
extern malloc_logger_t* __syscall_logger;
#endif
#endif

void loggerFunc(QAPMLoggerLevel level, const char* log) {
    
#ifdef RELEASE
    if (level <= QAPMLogLevel_Event) { ///外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif
    
#ifdef GRAY
    if (level <= QAPMLogLevel_Info) { ///灰度和外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif
    
#ifdef DEBUG
    if (level <= QAPMLogLevel_Debug) { ///内部版本、灰度和外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif
}

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupQapm];
    //    NSLog(@"[LAUNCH] CRASHED: %d", [DJUncaughtExceptionHandler lastOpenCrashed]);
    //    if ([DJUncaughtExceptionHandler lastOpenCrashed]) {
    //        [DJUncaughtExceptionHandler clearCrashRecord];
    //    }
    //    [DJUncaughtExceptionHandler setDefaultHandler];
    //
    
    
    
    return YES;
}

- (void)setupQapm {
    //启动耗时自定义打点开始,业务自行打点
    [QAPMLaunchProfile setBeginTimestampForScene:@"finish"];
    
    [QAPM registerLogCallback:loggerFunc];
#ifdef DEBUG
    //设置开启QAPM所有监控功能
    [[QAPMModelStableConfig getInstance] setupModelAll:1];
    //开启全量堆内存抽样
    [QAPMConfig getInstance].sigkillConfig.mallocSampleFactor = 1;
#else
    [[QAPMModelStableConfig getInstance] setupModelAll:2];
#endif
    
    //用于查看当前SDK版本号信息
    NSLog(@"qapm sdk version : %@", [QAPM sdkVersion]);
    
    //自动上传符号表步骤，请根据接入文档进行相关信息的配置
    [QAPMConfig getInstance].uuidFromDsym = NO;
    NSString *uuid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"com.tencent.qapm.uuid"];
    if(!uuid){
        uuid = @"jvbjlsakdbvjklavfhkjsadvhvcahvuyd";
    }
    
    NSLog(@"uuid::::%@",uuid);
    [QAPMConfig getInstance].dysmUuid = uuid;
    
    
    //手动上传符号表设置，请二选一操作
    // [QAPMConfig getInstance].uuidFromDsym = YES;
    
#ifdef USE_VM_LOGGER
    /// ！！！Sigkill功能私有API请不要在发布APPSotre时使用。开启这个功能可以监控到VM内存的分配的堆栈。
    [[QAPMConfig getInstance].sigkillConfig setVMLogger:(void**)&__syscall_logger];
#endif
    
    // 设置用户标记，默认值为10000,userID会作为计算各功能的用户指标率，请进行传值
    [QAPMConfig getInstance].userId = @"8888888800";
    
    // 设置设备唯一标识，默认值为10000,deviceID会作为计算各功能的设备指标率，请进行传值
    [QAPMConfig getInstance].deviceID = @"fasdfasdfcawefew";
    // 设置App版本号
    [QAPMConfig getInstance].customerAppVersion = @"6.5.9";
    [QAPM startWithAppKey:@"23f1a5a1-6648"];
    
    //启动耗时自定义打点结束，业务自行打点
    [QAPMLaunchProfile setEndTimestampForScene:@"finish"];
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
