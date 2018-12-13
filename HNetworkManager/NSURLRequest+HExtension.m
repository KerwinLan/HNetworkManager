//
//  NSURLRequest+HExtension.m
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "NSURLRequest+HExtension.h"
#import "NSObject+HNetworkParameter.h"
#import "NSURLRequest+HNetworkParamter.m"
#import "HNetwork.h"

@implementation NSURLRequest (HExtension)

+ (NSURLRequest *)requestWithURL:(NSString *)url requestType:(HNetworkRequestType)requestType parameter:(NSObject *)parameter headerFields:(NSDictionary *)headerFields signature:(id<HNetworkSignature>)signature
{
    NSMutableURLRequest *request;
    if (requestType == HNetworkRequestTypeGET && [parameter isKindOfClass:[NSDictionary class]]) {
        BOOL shouldSignature = signature && [signature respondsToSelector:@selector(signatureWithData:)];
        if (shouldSignature) {
            parameter = [signature signatureWithData:parameter];
        }
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@", [parameter stringWithShouldSignature:shouldSignature]]];
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    } else {
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setHTTPBody:[parameter data]];
    }
    NSMutableDictionary *fields = @{@"Content-type" : @"application/json"}.mutableCopy;
    if (headerFields && headerFields.count > 0) {
        [fields addEntriesFromDictionary:headerFields];
    }
    request.parameter = parameter;
    [request setAllHTTPHeaderFields:fields];
    request.timeoutInterval = [HNetwork sharedInstance].options.timeoutInterval;
    [request setRequestMethodWithType:requestType];
    return request;
}

- (void)setRequestMethodWithType:(HNetworkRequestType)type
{
    NSString *method;
    switch (type) {
            case HNetworkRequestTypeGET:
            method = @"GET";
            break;
            case HNetworkRequestTypePOST:
            method = @"POST";
            break;
            case HNetworkRequestTypePUT:
            method = @"PUT";
            break;
            case HNetworkRequestTypeDELETE:
            method = @"DELETE";
            break;
        default:
            break;
    }
    if ([self isKindOfClass:[NSMutableURLRequest class]]) {
        [((NSMutableURLRequest *) self) setHTTPMethod:method];
    }
}

@end
