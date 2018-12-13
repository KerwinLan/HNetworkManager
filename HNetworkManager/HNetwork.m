//
//  HNetwork.m
//  HNetwork
//
//  Created by Kerwin on 2018/12/5.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import "HNetwork.h"

@implementation HNetwork

+ (instancetype)sharedInstance {
    static HNetwork *network;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[HNetwork alloc] init];
    });
    return network;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dispatchHandler = [HNetworkDispatchHandler new];
        self.responseHandler = [HNetworkResponseHandler new];
        
        HNetworkOptions *options = [[HNetworkOptions alloc] init];
        options.timeoutInterval = 60.0;
        options.logLevel = HNetworkLogLevelVerbose;
        self.options = options;
    }
    return self;
}

@end
