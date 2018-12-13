//
//  HNetworkLogger.m
//  jjh
//
//  Created by kerwin on 2018/9/21.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "HNetworkLogger.h"
#import "HNetwork.h"

#define HNetworkLog(format, ...) NSLog((@"%s-"  format), __FUNCTION__, ##__VA_ARGS__);

@implementation HNetworkLogger

+ (void)printLogWithRequest:(NSURLRequest *)request parameter:(id)parameter responseObject:(id)responseObject responseCode:(NSInteger)responseCode error:(NSError *)error
{
    if ([HNetwork sharedInstance].options.logLevel == HNetworkLogLevelNone) {
        return;
    }
    if ([HNetwork sharedInstance].options.logLevel == HNetworkLogLevelError && responseCode == 200 && !error) {
        return;
    }
    id object;
    if ([responseObject isKindOfClass:[NSData class]]) {
        object = [NSJSONSerialization JSONObjectWithData:responseObject
                                                 options:NSJSONReadingMutableContainers
                                                   error:nil];
    }
    if (responseCode == 200 && !error) {
        HNetworkLog(@"\n -----------------request succees-----------------\nurl:%@\nmethod:%@\nresponseCode:%@\nheaderFields:%@\nrequestBody:%@\nresponse:%@", request.URL.absoluteString, request.HTTPMethod, @(responseCode), request.allHTTPHeaderFields, parameter, object);
    } else {
        HNetworkLog(@"\n -----------------request failure-----------------\nurl:%@\nmethod:%@\nresponseCode:%@\nheaderFields:%@\nrequestBody:%@\nerrorDescription:%@\nerrorCode:%@", request.URL.absoluteString, request.HTTPMethod, @(responseCode), request.allHTTPHeaderFields, parameter, error.localizedDescription, @(error.code));
    }
}

@end
