//
//  HNetworkBaseManager.m
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "HNetworkManager.h"
#import "HNetworkQueueManager.h"
#import "NSError+HNetwork.h"
#import "HNetworkLogger.h"

@implementation HNetworkManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestId = -1;
        self.requestType = HNetworkRequestTypeGET;
        self.showMessageEnable = YES;
        self.cachePolicy = HNetworkCachePolicyRemote;
        self.propsInURLMethod = [[NSSet alloc] initWithObjects:@"GET", nil];
    }
    return self;
}

- (void)fetch {
    if (self.requestId != -1 && !self.allowMultiRequest) {
        [[HNetworkQueueManager sharedInstance] cancelRequestWithId:self.requestId];
    }
    NSAssert(self.path.length != 0, @"%@ -- methodName property is empty", NSStringFromClass([self class]));
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSString stringWithFormat:@"%@%@", self.baseURL, self.path]
                                             requestType:self.requestType
                                               parameter:self.requestBody
                                            headerFields:self.headerFields
                                               signature:self.signature
                                        propsInURLMethod:self.propsInURLMethod];
    if (self.allowFetchCacheData) {
        NSData *data = [self.cacheManager cacheManagerFetchDataForIdentifier:request.URL.absoluteString];
        if (data && data.length > 0) {
            [self requestCompleted:request
                    responseObject:data
                      responseCode:200
                             error:nil];
        }
        if (self.cachePolicy == HNetworkCachePolicyLocal && data && data.length > 0) return ;
    }
    __weak typeof(self) weakSelf = self;
    self.requestId = [[HNetworkQueueManager sharedInstance] enqueue:request
                                                    responseHandler:^(id  _Nullable response, NSError * _Nullable error, NSInteger responseCode) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf requestCompleted:request
                      responseObject:response
                        responseCode:responseCode
                               error:error];
    }];
}

- (void)requestCompleted:(NSURLRequest *)request responseObject:(id)responseObject responseCode:(NSInteger)responseCode error:(NSError *)error {
    self.requestId = -1;
    [HNetworkLogger printLogWithRequest:request
                              parameter:request.parameter
                         responseObject:responseObject
                           responseCode:responseCode
                                  error:error];
    if (responseCode == 200) {
        [self requestSuccess:request forResponseObject:responseObject];
    } else {
        [self requestFailure:request forError:error];
    }
}

- (void)requestSuccess:(NSURLRequest *)request forResponseObject:(id)responseObject {
    if ([responseObject isKindOfClass:[NSData class]]) {
        if (self.allowSaveCahcheData) {
            [self.cacheManager cacheManagerSaveData:responseObject
                                      forIdentifier:request.URL.absoluteString];
        }
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject
                                                 options:NSJSONReadingMutableContainers
                                                   error:nil];
        self.responseModel = [[HNetwork sharedInstance].responseHandler parseResponseWithResponseObj:obj
                                                                                          parseClass:self.parseClass];
        
        if ([self allowPerformSuccessCallback:self.responseModel]) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.completionHandler ? weakSelf.completionHandler(weakSelf.responseModel, request.parameter, nil) : nil;
            });
        }
    } else {
        NSError *error = [[NSError alloc] initWithDomain:
                          [NSBundle bundleForClass:[self class]].bundleIdentifier
                                                    code:-100
                                                userInfo:@{NSLocalizedDescriptionKey : @"数据异常"}];
        [self requestFailure:request forError:error];
    }
}

- (void)requestFailure:(NSURLRequest *)request forError:(NSError *)error {
    if (!error) {
        error = [[NSError alloc] initWithDomain:[NSBundle bundleForClass:[self class]].bundleIdentifier
                                           code:NSURLErrorUnknown
                                       userInfo:@{NSLocalizedDescriptionKey : @"未知错误"}];
    }
    
    [[HNetwork sharedInstance].responseHandler handleErrorResponseWithMessage:error.errMsg
                                                                  toastEnable:self.showMessageEnable];
    
    if ([self allowPerformFailureCallback:error]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.completionHandler ? weakSelf.completionHandler(nil, request.parameter, error) : nil;
        });
    }
}

#pragma mark - Interceptor

- (BOOL)managerInterceptRequest:(NSURLRequest *)request {
    return YES;
}

- (BOOL)managerInterceptResponseFailure:(NSError *)error {
    return YES;
}

- (BOOL)managerInterceptResponseSuccess:(id)model {
    return YES;
}

#pragma mark - getter

- (NSString *)baseURL {
    return [HNetwork sharedInstance].options.baseURL;
}

- (NSString *)methodName {
    return @"";
}

- (NSDictionary *)headerFileds {
    return nil;
}

- (id)requestBody {
    return nil;
}

- (BOOL)allowSaveCahcheData {
    return self.cachePolicy != HNetworkCachePolicyRemote
    && self.cacheManager
    && [self.cacheManager respondsToSelector:@selector(cacheManagerSaveData:forIdentifier:)]
    && self.requestType == HNetworkRequestTypeGET;
}

- (BOOL)allowFetchCacheData {
    return self.cachePolicy != HNetworkCachePolicyRemote
    && self.cacheManager
    && [self.cacheManager respondsToSelector:@selector(cacheManagerFetchDataForIdentifier:)]
    && self.requestType == HNetworkRequestTypeGET;
}

- (BOOL)allowPerformSuccessCallback:(id)object {
    return [self managerInterceptResponseSuccess:object]
    && [[HNetwork sharedInstance].interceptor manager:self
                     performResponseSuccessWithObject:object];
}

- (BOOL)allowPerformFailureCallback:(NSError *)error {
    return [self managerInterceptResponseFailure:error]
    && [[HNetwork sharedInstance].interceptor manager:self
                      performResponseFailureWithError:error];;
}

@end
