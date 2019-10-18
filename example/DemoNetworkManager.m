//
//  DemoNetworkManager.m
//  example
//
//  Created by 兰志 on 2019/3/19.
//  Copyright © 2019 Kerwin. All rights reserved.
//

#import "DemoNetworkManager.h"
#import "HNetworkQueueManager.h"

@implementation DemoNetworkManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSMutableSet *set = self.propsInURLMethod.mutableCopy;
        [set addObject:@"POST"];
        self.propsInURLMethod = set;
    }
    return self;
}

- (NSString *)path {
    return @"/dynamicController/dynamicQuery.do";
}

- (Class)parseClass {
    return [NSDictionary class];
}

- (id)requestBody {
    return @{@"pageRow" : @1,
             @"accounts_pk" : @"c51d65a1c93d4233810670efe6cb4f3e",
             @"student_pk" : @"404666958ee04831a2978f614eb82068",
             @"class_pk" : @"3d08954201b24e61a67f27a7e9ffe332",
             @"pageSize" : @30,
             @"school_pk" : @"72cfe439a1ed11e8834f40f2e92db75a",
             @"type" : @"1",
             @"school_id" : @"5630000002"
             };
}

- (HNetworkRequestType)requestType {
    return HNetworkRequestTypePATCH;
}

- (void)dealloc {
    if (self.requestId != -1) {
        [[HNetworkQueueManager sharedInstance] cancelRequestWithId:self.requestId];
    }
}

@end
