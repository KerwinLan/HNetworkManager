//
//  HNetworkTask.m
//  example
//
//  Created by 兰志 on 2019/3/19.
//  Copyright © 2019 Kerwin. All rights reserved.
//

#import "HNetworkTask.h"

@interface HNetworkTask ()

@property (nonatomic, strong) NSURLRequest *request;

@end

@implementation HNetworkTask

+ (instancetype)taskWithRequest:(NSURLRequest *)request {
    return [self taskWithRequest:request
                       completed:nil];
}

+ (instancetype)taskWithRequest:(NSURLRequest *)request completed:(HNetworkTaskCompleted)completed {
    HNetworkTask *task = [[HNetworkTask alloc] init];
    task.completed = [completed copy];
    task.request = request;
    return task;
}

- (void)run {
    __weak typeof(self) weakSelf = self;
    _sessionTask = [[HNetwork sharedInstance].dispatchHandler dispatchSessionTaskWithRequest:self.request completionHandler:^(NSURLResponse * _Nullable response, id  _Nullable responseObj, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSInteger responseCode = 0;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            responseCode = ((NSHTTPURLResponse *) response).statusCode;
        }
        strongSelf.completed ? strongSelf.completed(responseObj, error, responseCode) : nil;
    }];
    [_sessionTask resume];
}

- (void)cancel {
    if (self.sessionTask) [self.sessionTask cancel];
}

@end
