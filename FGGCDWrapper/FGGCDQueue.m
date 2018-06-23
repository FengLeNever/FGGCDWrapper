//
//  FGGCDQueue.m
//  GCDWrapper
//
//  Created by FG_NeverMore on 2018/6/23.
//  Copyright © 2018年 FG_NeverMore. All rights reserved.
//

#import "FGGCDQueue.h"

static FGGCDQueue *mainQueue_;
static FGGCDQueue *globalQueue_;
static FGGCDQueue *highPriorityGlobalQueue_;
static FGGCDQueue *lowPriorityGlobalQueue_;
static FGGCDQueue *backgroundPriorityGlobalQueue_;

@interface FGGCDQueue ()

@property (strong, readwrite, nonatomic) dispatch_queue_t dispatchQueue;

@end

@implementation FGGCDQueue

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainQueue_                     = [[FGGCDQueue alloc] init];
        globalQueue_                   = [[FGGCDQueue alloc] init];
        highPriorityGlobalQueue_       = [[FGGCDQueue alloc] init];
        lowPriorityGlobalQueue_        = [[FGGCDQueue alloc] init];
        backgroundPriorityGlobalQueue_ = [[FGGCDQueue alloc] init];
        
        mainQueue_.dispatchQueue                     = dispatch_get_main_queue();
        globalQueue_.dispatchQueue                   = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        highPriorityGlobalQueue_.dispatchQueue       = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        lowPriorityGlobalQueue_.dispatchQueue        = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
        backgroundPriorityGlobalQueue_.dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    });
}

+ (FGGCDQueue *)mainQueue {
    return mainQueue_;
}

+ (FGGCDQueue *)globalQueue {
    
    return globalQueue_;
}

+ (FGGCDQueue *)highPriorityGlobalQueue {
    
    return highPriorityGlobalQueue_;
}

+ (FGGCDQueue *)lowPriorityGlobalQueue {
    
    return lowPriorityGlobalQueue_;
}

+ (FGGCDQueue *)backgroundPriorityGlobalQueue {
    
    return backgroundPriorityGlobalQueue_;
}

#pragma mark - 便利的构造方法

+ (void)executeInMainQueue:(dispatch_block_t)block {
    NSParameterAssert(block);
    dispatch_async(mainQueue_.dispatchQueue, block);
}

+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), mainQueue_.dispatchQueue, block);
}

+ (void)executeInGlobalQueue:(dispatch_block_t)block {
    NSParameterAssert(block);
    dispatch_async(globalQueue_.dispatchQueue, block);
}

+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), globalQueue_.dispatchQueue, block);
}

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block {
    NSParameterAssert(block);
    dispatch_async(highPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), highPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block {
    NSParameterAssert(block);
    dispatch_async(lowPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), lowPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block {
    NSParameterAssert(block);
    dispatch_async(backgroundPriorityGlobalQueue_.dispatchQueue, block);
}

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec {
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * sec), backgroundPriorityGlobalQueue_.dispatchQueue, block);
}

#pragma 初始化

- (instancetype)initSerial {
    self = [super init];
    if (self) {
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (instancetype)initSerialWithLabel:(NSString *)label {
    
    self = [super init];
    if (self){
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

- (instancetype)initConcurrent {
    self = [super init];
    if (self) {
        self.dispatchQueue = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)initConcurrentWithLabel:(NSString *)label {
    self = [super init];
    if (self){
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark - 用法
- (void)executeAction:(dispatch_block_t)block {
    NSParameterAssert(block);
    dispatch_async(self.dispatchQueue, block);
}

- (void)executeAction:(dispatch_block_t)block afterDelaySecs:(float)delta {
    NSParameterAssert(block);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta * NSEC_PER_SEC), self.dispatchQueue, block);
}

- (void)suspend {
    dispatch_suspend(self.dispatchQueue);
}

- (void)resume {
    dispatch_resume(self.dispatchQueue);
}


@end
