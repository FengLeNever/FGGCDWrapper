//
//  FGGCDTimer.m
//  GCDWrapper
//
//  Created by FG_NeverMore on 2018/6/23.
//  Copyright © 2018年 FG_NeverMore. All rights reserved.
//

#import "FGGCDTimer.h"

//保存timer的容器,因为GCD的timer需要强引用,才能存在
static NSMutableDictionary * timerContainer;
//调用环境有可能是多线程环境,所以需要线程同步策略
dispatch_semaphore_t semaphore_;

@interface FGGCDTimer ()

@property (strong, readwrite, nonatomic) dispatch_source_t dispatchSource;

@end

@implementation FGGCDTimer

/**
 添加dispatch_once,防止多次调用(比如:手动调用load方法)
 */
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerContainer = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)executeAction:(dispatch_block_t)action
                      start:(NSTimeInterval)start
               timeInterval:(double)interval
                    repeats:(BOOL)repeats
                      async:(BOOL)async
{
    if (!action || start < 0 || (interval <= 0 && repeats)) {
        return nil;
    }
    
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    //创建
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, startTime, interval * NSEC_PER_SEC, 0);
    
    //加锁操作容器
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    NSString *timeKey = [NSString stringWithFormat:@"%zd",timerContainer.count];
    [timerContainer setObject:timer forKey:timeKey];
    dispatch_semaphore_signal(semaphore_);
    
    dispatch_source_set_event_handler(timer, ^{
        action();
        if (!repeats) {
            [self cancelTimerWithName:timeKey];
        }
    });
    dispatch_resume(timer);
    
    return timeKey;
}

+ (void)cancelTimerWithName:(NSString *)timerName
{
    if (nil == timerName) {
        return;
    }
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = [timerContainer objectForKey:timerName];
    if (timer) {
        [timerContainer removeObjectForKey:timerName];
        dispatch_source_cancel(timer);
    }
    dispatch_semaphore_signal(semaphore_);
}

+ (void)cancelAllTimer
{
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    [timerContainer enumerateKeysAndObjectsUsingBlock:^(NSString * timerName, dispatch_source_t timer, BOOL * _Nonnull stop) {
        [timerContainer removeObjectForKey:timerName];
        dispatch_source_cancel(timer);
    }];
    dispatch_semaphore_signal(semaphore_);
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    }
    
    return self;
}

- (void)executeAction:(dispatch_block_t)block timeInterval:(uint64_t)interval {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)executeAction:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeInterval:(uint64_t)interval {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
    dispatch_source_set_cancel_handler(self.dispatchSource, cancelEvent);
}

- (void)executeAction:(dispatch_block_t)block timeInterval:(uint64_t)interval delay:(uint64_t)delay {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delay), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)executeAction:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeInterval:(uint64_t)interval delay:(uint64_t)delay {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delay), interval, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
    dispatch_source_set_cancel_handler(self.dispatchSource, cancelEvent);
}

- (void)executeAction:(dispatch_block_t)block timeIntervalWithSecs:(float)secs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)executeAction:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeIntervalWithSecs:(float)secs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, 0), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
    dispatch_source_set_cancel_handler(self.dispatchSource, cancelEvent);
}

- (void)executeAction:(dispatch_block_t)block timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delaySecs * NSEC_PER_SEC), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
}

- (void)executeAction:(dispatch_block_t)block cancelEvent:(dispatch_block_t)cancelEvent timeIntervalWithSecs:(float)secs delaySecs:(float)delaySecs {
    
    NSParameterAssert(block);
    dispatch_source_set_timer(self.dispatchSource, dispatch_time(DISPATCH_TIME_NOW, delaySecs * NSEC_PER_SEC), secs * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.dispatchSource, block);
    dispatch_source_set_cancel_handler(self.dispatchSource, cancelEvent);
}

- (void)start {
    dispatch_resume(self.dispatchSource);
}

- (void)destroy {
    dispatch_source_cancel(self.dispatchSource);
}

@end
