//
//  HNetworkInterceptor.h
//  HNetwork
//
//  Created by Kerwin on 2018/12/6.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNetworkInterceptor : NSObject

- (BOOL)request:(NSURLRequest *)request shouldFinishedWithResponseObject:(id)responseObject;
- (BOOL)request:(NSURLRequest *)request shouldFailureWithError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
