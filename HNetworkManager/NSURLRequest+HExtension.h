//
//  NSURLRequest+HExtension.h
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNetworkSignature.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HNetworkRequestType) {
    HNetworkRequestTypeGET = 0,
    HNetworkRequestTypePOST,
    HNetworkRequestTypeDELETE,
    HNetworkRequestTypePUT,
    HNetworkRequestTypePATCH
};

@interface NSURLRequest (HExtension)

+ (NSURLRequest *)requestWithURL:(NSString *)url
                     requestType:(HNetworkRequestType)requestType
                       parameter:(NSObject * _Nullable)parameter
                    headerFields:(NSDictionary * _Nullable)headerFields
                       signature:(id<HNetworkSignature> _Nullable)signature
                propsInURLMethod:(NSSet<NSString *> *)propsInURLMethod;

@end

NS_ASSUME_NONNULL_END
