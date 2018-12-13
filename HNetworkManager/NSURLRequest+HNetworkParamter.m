//
//  NSURLRequest+HNetworkParamter.m
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "NSURLRequest+HNetworkParamter.h"
#import <objc/runtime.h>

static void *HNetworkRequestParameter;

@implementation NSURLRequest (HNetworkParamter)

- (void)setParameter:(id)parameter
{
    objc_setAssociatedObject(self, &HNetworkRequestParameter, parameter, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id)parameter
{
    return objc_getAssociatedObject(self, &HNetworkRequestParameter);
}

@end
