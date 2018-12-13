//
//  HNetworkOptions.h
//  HNetwork
//
//  Created by Kerwin on 2018/12/5.
//  Copyright © 2018 Kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HNetworkLogLevel) {
    HNetworkLogLevelVerbose = 0,
    HNetworkLogLevelError,
    HNetworkLogLevelNone
};

@interface HNetworkOptions : NSObject

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;
@property (nonatomic, assign) HNetworkLogLevel logLevel;

@end

NS_ASSUME_NONNULL_END
