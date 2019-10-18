//
//  NetworkLifeCircle.m
//  example
//
//  Created by Kerwin on 2019/5/21.
//  Copyright © 2019 Kerwin. All rights reserved.
//

#import "NetworkLifeCircle.h"

@interface NetworkLifeCircle ()

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSURLSessionDataTask *> *taskTable;

@end

@implementation NetworkLifeCircle



- (NSMutableDictionary<NSNumber *,NSURLSessionDataTask *> *)taskTable {
    if (!_taskTable) {
        _taskTable = @{}.mutableCopy;
    }
    return _taskTable;
}

@end
