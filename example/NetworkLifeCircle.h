//
//  NetworkLifeCircle.h
//  example
//
//  Created by Kerwin on 2019/5/21.
//  Copyright © 2019 Kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkLifeCircle : NSObject

- (void)setTask:(NSURLSessionDataTask *)task forKey:(NSInteger)key;

- (void)cancelTaskWithId:(NSInteger)taskId;

- (void)cancelAll;

@end

NS_ASSUME_NONNULL_END
