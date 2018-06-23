//
//  FGGCDTimer.h
//  GCDWrapper
//
//  Created by FG_NeverMore on 2018/6/23.
//  Copyright © 2018年 FG_NeverMore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGGCDTimer : NSObject

/**
 创建GCDTimer
 
 @param start 开始时间
 @param interval 时间间隔
 @param repeats 是否重复
 @param async 是否异步,如果YES,那么是在全局队列中;如果NO,是在主线程中
 @param action 执行的方法
 @return GCDTimerKey,可于取消timer使用
 */

+ (NSString *)executeAction:(dispatch_block_t)action
                      start:(NSTimeInterval)start
               timeInterval:(double)interval
                    repeats:(BOOL)repeats
                      async:(BOOL)async;

/**
 取消dispatch定时器
 
 @param timerName 定时器名称
 */
+ (void)cancelTimerWithName:(NSString *)timerName;

/**
 取消所有创建的dispatch定时器
 */
+ (void)cancelAllTimer;


@property (strong, readonly, nonatomic) dispatch_source_t dispatchSource;

#pragma 初始化

/**
 初始化方法,默认创建主队列,在主队列中做事情
 */
- (instancetype)init;

#pragma mark - 用法
- (void)executeAction:(dispatch_block_t)block timeInterval:(uint64_t)interval;
- (void)executeAction:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeInterval:(uint64_t)interval;

- (void)executeAction:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay;
- (void)executeAction:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeInterval:(uint64_t)interval delay:(uint64_t)delay;

- (void)executeAction:(dispatch_block_t)block timeIntervalWithSecs:(float)secs;
- (void)executeAction:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeIntervalWithSecs:(float)secs;

- (void)executeAction:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;
- (void)executeAction:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs;

- (void)start;
- (void)destroy;

@end
