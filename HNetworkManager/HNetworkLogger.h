//
//  HNetworkLogger.h
//  jjh
//
//  Created by kerwin on 2018/9/21.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLRequest+HNetworkParamter.h"

@interface HNetworkLogger : NSObject

+ (void)printLogWithRequest:(NSURLRequest *)request parameter:(id)parameter responseObject:(id)responseObject responseCode:(NSInteger)responseCode error:(NSError *)error;

@end
