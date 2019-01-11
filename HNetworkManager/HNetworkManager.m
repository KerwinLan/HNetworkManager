//
//  HNetworkBaseManager.m
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "HNetworkManager.h"
#import "HNetworkProxy.h"
#import "NSError+HNetwork.h"
#import "HNetworkLogger.h"

@implementation HNetworkManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestId = -1;
        self.requestType = HNetworkRequestTypeGET;
    }
    return self;
}

- (void)fetch {
    if (self.requestId != -1 && !self.allowMultiRequest) {
        [[HNetworkProxy sharedInstance] cancelRequestWithId:self.requestId];
    }
    NSAssert(self.methodName.length != 0, @"%@ -- methodName property is empty", NSStringFromClass([self class]));
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSString stringWithFormat:@"%@%@", self.baseURL, self.methodName]
                                             requestType:self.requestType
                                               parameter:self.requestBody
                                            headerFields:self.headerFields
                                               signature:self.signature];
    __weak typeof(self) weakSelf = self;
    self.requestId = [[HNetworkProxy sharedInstance] enqueue:request
                                                    callBack:^(id  _Nullable response, NSError * _Nullable error, NSInteger responseCode) {
                                                        __strong typeof(weakSelf) strongSelf = weakSelf;
                                                        strongSelf.requestId = -1;
                                                        [HNetworkLogger printLogWithRequest:request
                                                                                  parameter:request.parameter
                                                                             responseObject:response
                                                                               responseCode:responseCode
                                                                                      error:error];
                                                        if (responseCode == 200) {
                                                            [strongSelf requestSuccess:request forResponseObject:response];
                                                        } else {
                                                            [strongSelf requestFailure:request forError:error];
                                                        }
                                                    }];
}

- (void)requestSuccess:(NSURLRequest *)request forResponseObject:(id)responseObject {
    if ([responseObject isKindOfClass:[NSData class]]) {
        id obj = [NSJSONSerialization JSONObjectWithData:responseObject
                                                 options:NSJSONReadingMutableContainers
                                                   error:nil];
        HNetwork *network = [HNetwork sharedInstance];
        self.responseModel = [network.responseHandler parseResponseWithResponseObj:obj
                                                                        parseClass:self.parseClass];
        if ([self managerInterceptResponseSuccess:self.responseModel] && [network.interceptor request:request
                                                                      shouldFailureWithResponseObject:responseObject]) {
            _callResult ? _callResult(self.responseModel, request.parameter, nil) : nil;
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
    if ([self managerInterceptResponseFailure:error]) {
        _callResult ? _callResult(nil, request.parameter, error) : nil;
    }
}


#pragma mark - display error message enable

- (BOOL)showMessageEnable {
    return YES;
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

- (HNetworkRequestType)requestType {
    return HNetworkRequestTypePOST;
}

- (NSDictionary *)headerFileds {
    return nil;
}

- (id)requestBody {
    return nil;
}

@end
