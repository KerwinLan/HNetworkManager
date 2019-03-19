//
//  HNetworkProxy.h
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNetworkTask.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^HNetworkTaskResponseHandler) (id _Nullable response, NSError * _Nullable error, NSInteger responseCode);

typedef NS_ENUM(NSInteger, HNetworkState) {
    HNetworkStateActive = 0,
    HNetworkStateQuite
};

@interface HNetworkQueueManager : NSObject

@property (nonatomic, assign) HNetworkState networkState;

+ (instancetype)sharedInstance;

- (NSInteger)enqueue:(NSURLRequest * _Nonnull)request responseHandler:(HNetworkTaskResponseHandler _Nullable)responseHandler;

- (void)cancelRequestWithId:(NSInteger)requestId;
- (void)cancelAllRequest;

@end

NS_ASSUME_NONNULL_END
