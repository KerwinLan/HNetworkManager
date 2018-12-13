//
//  HNetworkDispatchHandler.m
//  HNetwork
//
//  Created by Kerwin on 2018/12/5.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import "HNetworkDispatchHandler.h"

@implementation HNetworkDispatchHandler

- (NSURLSessionTask *)dispatchSessionTaskWithRequest:(NSURLRequest *)request completionHandler:(HNetworkResponseCompletionHandler)completionHandler {
    completionHandler = [completionHandler copy];
    return [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completionHandler(response, data, error);
    }];
}

@end
