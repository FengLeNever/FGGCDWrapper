//
//  FGGCDQueue.h
//  GCDWrapper
//
//  Created by FG_NeverMore on 2018/6/23.
//  Copyright © 2018年 FG_NeverMore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGGCDQueue : NSObject

@property (strong, readonly, nonatomic) dispatch_queue_t dispatchQueue;

+ (FGGCDQueue *)mainQueue;
+ (FGGCDQueue *)globalQueue;
+ (FGGCDQueue *)highPriorityGlobalQueue;
+ (FGGCDQueue *)lowPriorityGlobalQueue;
+ (FGGCDQueue *)backgroundPriorityGlobalQueue;

#pragma mark - 便利的构造方法
+ (void)executeInMainQueue:(dispatch_block_t)block;
+ (void)executeInMainQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)executeInGlobalQueue:(dispatch_block_t)block;
+ (void)executeInGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInHighPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInLowPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;

+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block;
+ (void)executeInBackgroundPriorityGlobalQueue:(dispatch_block_t)block afterDelaySecs:(NSTimeInterval)sec;


#pragma 初始化

/**
 不推荐
 */
- (instancetype)initSerial;
/**
 推荐使用,最好对自己创建的队列做一个标记,DEBUG时也好排查
 */
- (instancetype)initSerialWithLabel:(NSString *)label;
/**
 不推荐
 */
- (instancetype)initConcurrent;
/**
 推荐使用,最好对自己创建的队列做一个标记,DEBUG时也好排查
 */
- (instancetype)initConcurrentWithLabel:(NSString *)label;


#pragma mark - 用法
- (void)executeAction:(dispatch_block_t)block;
- (void)executeAction:(dispatch_block_t)block afterDelaySecs:(float)delta;
- (void)suspend;
- (void)resume;

@end
