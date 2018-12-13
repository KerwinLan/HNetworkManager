//
//  HNetworkProxy.h
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNetwork.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^HNetworkProxyCallBack) (id _Nullable response, NSError * _Nullable error, NSInteger responseCode);

@interface HNetworkProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)enqueue:(NSURLRequest * _Nonnull)request callBack:(HNetworkProxyCallBack _Nullable)callback;

- (void)cancelRequestWithId:(NSInteger)requestId;
- (void)cancelAllRequest;

@end

NS_ASSUME_NONNULL_END
