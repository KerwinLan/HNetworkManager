//
//  NSError+HNetwork.m
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "NSError+HNetwork.h"
#import <objc/runtime.h>

static void *HNetworkErrMsg;

@implementation NSError (HNetwork)

- (void)setErrMsg:(NSString *)errMsg
{
    objc_setAssociatedObject(self, &HNetworkErrMsg, errMsg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)errMsg
{
    NSString *msg = objc_getAssociatedObject(self, &HNetworkErrMsg);
    if (!msg) {
        msg = [self reformDescription];
    }
    return msg;
}

- (NSString *)reformDescription {
    if (self.code == NSURLErrorTimedOut) {
        return @"请求超时";
    }
    if (self.code == NSURLErrorCannotConnectToHost) {
        return @"无法连接服务器";
    }
    if (self.code == NSURLErrorNotConnectedToInternet) {
        return @"当前无网络连接，请检查网络设置";
    }
    return [NSString stringWithFormat:@"未知错误:%@", @(self.code)];
}

@end
