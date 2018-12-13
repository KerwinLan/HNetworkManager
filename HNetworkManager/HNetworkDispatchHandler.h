//
//  HNetworkDispatchHandler.h
//  HNetwork
//
//  Created by Kerwin on 2018/12/5.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HNetworkResponseCompletionHandler)(NSURLResponse * _Nullable response, id _Nullable responseObj, NSError * _Nullable error);

@interface HNetworkDispatchHandler : NSObject

- (NSURLSessionTask *)dispatchSessionTaskWithRequest:(NSURLRequest *)request completionHandler:(HNetworkResponseCompletionHandler _Nullable)completionHandler;

@end

NS_ASSUME_NONNULL_END
