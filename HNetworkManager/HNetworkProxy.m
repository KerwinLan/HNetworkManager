//
//  HNetworkProxy.m
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "HNetworkProxy.h"

@interface HNetworkProxy ()

@property (nonatomic, assign) NSInteger requestId;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSURLSessionTask *> *dispatchTable;

@end

@implementation HNetworkProxy

+ (instancetype)sharedInstance
{
    static HNetworkProxy *proxy;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [[HNetworkProxy alloc] init];
    });
    return proxy;
}

- (NSInteger)enqueue:(NSURLRequest *)request callBack:(HNetworkProxyCallBack)callback
{
    NSInteger key = [self fetchRequestId];
    callback = [callback copy];
    __weak typeof(self) weakSelf = self;
    HNetworkResponseCompletionHandler handler = ^(NSURLResponse * _Nullable response, id _Nullable responseObj, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSURLSessionTask *currentTask = strongSelf.dispatchTable[@(key)];
        if (!currentTask) return ;
        [strongSelf.dispatchTable removeObjectForKey:@(key)];
        NSInteger responseCode = 0;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            responseCode = ((NSHTTPURLResponse *) response).statusCode;
        }
        callback ? callback(responseObj, error, responseCode) : nil;
    };
    NSURLSessionTask *task = [[HNetwork sharedInstance].dispatchHandler dispatchSessionTaskWithRequest:request completionHandler:handler];
    [task resume];
    [self.dispatchTable setObject:task forKey:@(key)];
    return key;
}

- (void)cancelRequestWithId:(NSInteger)requestId
{
    NSNumber *key = @(requestId);
    if ([self.dispatchTable.allKeys containsObject:key]) {
        [self.dispatchTable[key] cancel];
        [self.dispatchTable removeObjectForKey:key];
    }
}

- (void)cancelAllRequest
{
    [self.dispatchTable enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSURLSessionTask * _Nonnull obj, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [self.dispatchTable removeAllObjects];
}

- (NSInteger)fetchRequestId
{
    if (self.requestId >= NSIntegerMax) {
        self.requestId = 0;
    }
    self.requestId++;
    return self.requestId;
}

- (NSMutableDictionary<NSNumber *,NSURLSessionTask *> *)dispatchTable
{
    if (!_dispatchTable) {
        _dispatchTable = @{}.mutableCopy;
    }
    return _dispatchTable;
}

@end
