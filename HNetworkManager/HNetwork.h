//
//  HNetwork.h
//  HNetwork
//
//  Created by Kerwin on 2018/12/5.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNetworkOptions.h"
#import "HNetworkResponseHandler.h"
#import "HNetworkDispatchHandler.h"
#import "HNetworkInterceptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface HNetwork : NSObject

@property (nonatomic, strong) __kindof HNetworkDispatchHandler *dispatchHandler;
@property (nonatomic, strong) __kindof HNetworkOptions *options;
@property (nonatomic, strong) __kindof HNetworkResponseHandler *responseHandler;
@property (nonatomic, strong) __kindof HNetworkInterceptor *interceptor;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
