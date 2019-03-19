//
//  DemoNetworkManager.m
//  example
//
//  Created by 兰志 on 2019/3/19.
//  Copyright © 2019 Kerwin. All rights reserved.
//

#import "DemoNetworkManager.h"

@implementation DemoNetworkManager

- (NSString *)methodName {
    return @"baff-api/api/member/learning/v2/type";
}

- (Class)parseClass {
    return [NSDictionary class];
}

- (id)requestBody {
    return @{@"memberId" : @10051, @"version" : @"1.93"};
}

@end
