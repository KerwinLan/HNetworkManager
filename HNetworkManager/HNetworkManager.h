//
//  HNetworkBaseManager.h
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLRequest+HExtension.h"
#import "HNetworkSignature.h"

NS_ASSUME_NONNULL_BEGIN

@interface HNetworkManager<__covariant T> : NSObject

@property (nonatomic, strong, nullable) T responseModel;
@property (nonatomic, copy, nullable) void(^callResult)(T _Nullable model, id _Nullable parameter, NSError * _Nullable error);
@property (nonatomic) NSInteger requestId;

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, assign) HNetworkRequestType requestType;
@property (nonatomic, strong, nullable) NSDictionary *headerFields;
@property (nonatomic, assign) Class parseClass;
@property (nonatomic, strong, nullable) id requestBody;
@property (nonatomic, weak, nullable) id<HNetworkSignature> signature;
@property (nonatomic, assign) BOOL allowMultiRequest;

- (BOOL)managerInterceptRequest:(NSURLRequest *)request;
- (BOOL)managerInterceptResponseSuccess:(T)model;
- (BOOL)managerInterceptResponseFailure:(NSError *)error;

- (BOOL)showMessageEnable;

- (void)fetch;


@end

NS_ASSUME_NONNULL_END
