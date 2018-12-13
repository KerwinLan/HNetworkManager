//
//  HNetworkInterceptor.m
//  HNetwork
//
//  Created by Kerwin on 2018/12/6.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import "HNetworkInterceptor.h"

@implementation HNetworkInterceptor

- (BOOL)request:(NSURLRequest *)request shouldFinishedWithResponseObject:(id)responseObject{
    return YES;
}

- (BOOL)request:(NSURLRequest *)request shouldFailureWithResponseObject:(id)responseObject {
    return YES;
}

@end
