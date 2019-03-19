//
//  HNetworkTask.h
//  example
//
//  Created by 兰志 on 2019/3/19.
//  Copyright © 2019 Kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNetwork.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^HNetworkTaskCompleted) (id _Nullable response, NSError * _Nullable error, NSInteger responseCode);

@interface HNetworkTask : NSObject

@property (nonatomic, strong, readonly, nullable) NSURLSessionTask *sessionTask;
@property (nonatomic, copy, nullable) HNetworkTaskCompleted completed;

+ (instancetype)taskWithRequest:(NSURLRequest *)request;
+ (instancetype)taskWithRequest:(NSURLRequest *)request completed:(HNetworkTaskCompleted _Nullable)completed;

- (void)run;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
