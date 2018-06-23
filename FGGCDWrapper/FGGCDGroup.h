//
//  FGGCDGroup.h
//  GCDWrapper
//
//  Created by FG_NeverMore on 2018/6/23.
//  Copyright © 2018年 FG_NeverMore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FGGCDQueue;
@interface FGGCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

#pragma 初始化
- (instancetype)init;

#pragma mark - 用法
- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

#pragma mark - 与GCDGroup相关
- (void)executeAction:(dispatch_block_t)block inQueue:(FGGCDQueue *)queue;
- (void)notifyAction:(dispatch_block_t)block inQueue:(FGGCDQueue *)queue;

@end
