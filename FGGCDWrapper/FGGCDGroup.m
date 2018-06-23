//
//  FGGCDGroup.m
//  GCDWrapper
//
//  Created by FG_NeverMore on 2018/6/23.
//  Copyright © 2018年 FG_NeverMore. All rights reserved.
//

#import "FGGCDGroup.h"
#import "FGGCDQueue.h"

@interface FGGCDGroup ()

@property (strong, nonatomic, readwrite) dispatch_group_t dispatchGroup;

@end

@implementation FGGCDGroup

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dispatchGroup = dispatch_group_create();
    }
    return self;
}

- (void)enter {
    
    dispatch_group_enter(self.dispatchGroup);
}

- (void)leave {
    
    dispatch_group_leave(self.dispatchGroup);
}

- (void)wait {
    
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}

- (BOOL)wait:(int64_t)delta {
    
    return dispatch_group_wait(self.dispatchGroup, dispatch_time(DISPATCH_TIME_NOW, delta)) == 0;
}

- (void)executeAction:(dispatch_block_t)block inQueue:(FGGCDQueue *)queue {
    NSParameterAssert(block);
    dispatch_group_async(self.dispatchGroup, queue.dispatchQueue, block);
}

- (void)notifyAction:(dispatch_block_t)block inQueue:(FGGCDQueue *)queue {
    NSParameterAssert(block);
    dispatch_group_notify(self.dispatchGroup, queue.dispatchQueue, block);
}

@end
