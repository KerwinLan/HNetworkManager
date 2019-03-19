//
//  HNetworkProxy.m
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "HNetworkQueueManager.h"

@interface HNetworkQueueManager ()

@property (nonatomic, assign) NSInteger requestId;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, HNetworkTask *> *dispatchQueue;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, HNetworkTask *> *waitQueue;

@end

@implementation HNetworkQueueManager

+ (instancetype)sharedInstance
{
    static HNetworkQueueManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HNetworkQueueManager alloc] init];
    });
    return manager;
}

- (NSInteger)enqueue:(NSURLRequest *)request responseHandler:(HNetworkTaskResponseHandler)responseHandler {
    NSInteger key = [self fetchRequestId];
    responseHandler = [responseHandler copy];
    __weak typeof(self) weakSelf = self;
    HNetworkTask *task = [HNetworkTask taskWithRequest:request completed:^(id _Nullable response, NSError * _Nullable error, NSInteger responseCode) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        HNetworkTask *currentTask = strongSelf.dispatchQueue[@(key)];
        if (!currentTask) return ;
        responseHandler ? responseHandler(response, error, responseCode) : nil;
        [strongSelf.dispatchQueue removeObjectForKey:@(key)];
    }];
    if (self.networkState == HNetworkStateActive) {
        [task run];
        [self.dispatchQueue setObject:task forKey:@(key)];
    } else {
        [self.waitQueue setObject:task forKey:@(key)];
        responseHandler ? responseHandler(nil, [[NSError alloc] initWithDomain:
                                                [NSBundle bundleForClass:[self class]].bundleIdentifier
                                                                          code:-10000
                                                                      userInfo:@{NSLocalizedDescriptionKey : @"网络不可用"}], -10000) : nil;
    }
    return key;
}

- (void)cancelRequestWithId:(NSInteger)requestId {
    NSNumber *key = @(requestId);
    if ([self.dispatchQueue.allKeys containsObject:key]) {
        [self.dispatchQueue[key] cancel];
        [self.dispatchQueue removeObjectForKey:key];
    }
    if ([self.waitQueue.allKeys containsObject:key]) {
        [self.waitQueue removeObjectForKey:key];
    }
}

- (void)cancelAllRequest {
    [self.dispatchQueue enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, HNetworkTask * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [self.dispatchQueue removeAllObjects];
    [self.waitQueue removeAllObjects];
}

- (NSInteger)fetchRequestId {
    if (self.requestId >= NSIntegerMax) {
        self.requestId = 0;
    }
    self.requestId++;
    return self.requestId;
}

- (void)setNetworkState:(HNetworkState)networkState {
    _networkState = networkState;
    if (networkState == HNetworkStateActive) {
        [self.waitQueue enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, HNetworkTask * _Nonnull obj, BOOL * _Nonnull stop) {
            [obj run];
        }];
        [self.dispatchQueue addEntriesFromDictionary:self.waitQueue];
        [self.waitQueue removeAllObjects];
    }
}

- (NSMutableDictionary<NSNumber *,HNetworkTask *> *)dispatchQueue {
    if (!_dispatchQueue) {
        _dispatchQueue = @{}.mutableCopy;
    }
    return _dispatchQueue;
}

- (NSMutableDictionary<NSNumber *,HNetworkTask *> *)waitQueue {
    if (!_waitQueue) {
        _waitQueue = @{}.mutableCopy;
    }
    return _waitQueue;
}

@end
