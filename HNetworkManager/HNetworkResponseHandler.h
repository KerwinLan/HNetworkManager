//
//  HNetworkResponseHandler.h
//  HNetwork
//
//  Created by Kerwin on 2018/12/5.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNetworkResponseHandler : NSObject

- (nullable id)parseResponseWithResponseObj:(id _Nullable)responseObj parseClass:(Class)clzz;

- (void)handleErrorResponseWithMessage:(NSString *)message toastEnable:(BOOL)toastEnable;

@end

NS_ASSUME_NONNULL_END
