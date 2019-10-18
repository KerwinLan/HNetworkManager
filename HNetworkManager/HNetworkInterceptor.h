//
//  HNetworkInterceptor.h
//  HNetwork
//
//  Created by Kerwin on 2018/12/6.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HNetworkManager;

@interface HNetworkInterceptor : NSObject

- (BOOL)request:(NSURLRequest *)request shouldFinishedWithResponseObject:(id)responseObject __deprecated_msg("Use -manager:performResponseSuccessWithObject:");
- (BOOL)request:(NSURLRequest *)request shouldFailureWithError:(NSError *)error __deprecated_msg("Use -manager:performResponseFailureWithError:");

- (BOOL)manager:(HNetworkManager *)manager performResponseSuccessWithObject:(id)object;
- (BOOL)manager:(HNetworkManager *)manager performResponseFailureWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
