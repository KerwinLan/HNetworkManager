//
//  NSObject+HNetworkParameter.h
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HNetworkParameter)

- (nullable NSString *)string;
- (nullable NSString *)stringWithShouldSignature:(BOOL)shouldSignature;

- (nullable NSData *)data;

@end
