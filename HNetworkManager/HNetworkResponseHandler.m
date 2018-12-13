//
//  HNetworkResponseHandler.m
//  HNetwork
//
//  Created by Kerwin on 2018/12/5.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import "HNetworkResponseHandler.h"

@implementation HNetworkResponseHandler

- (id)parseResponseWithResponseObj:(id)responseObj parseClass:(Class)clzz {
    return responseObj;
}

- (void)handleErrorResponseWithMessage:(NSString *)message toastEnable:(BOOL)toastEnable {
    
}

@end
