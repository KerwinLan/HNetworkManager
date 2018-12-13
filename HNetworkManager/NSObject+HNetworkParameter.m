//
//  NSObject+HNetworkParameter.m
//  jjh
//
//  Created by kerwin on 2018/9/14.
//  Copyright © 2018年 kerwin. All rights reserved.
//

#import "NSObject+HNetworkParameter.h"

@implementation NSObject (HNetworkParameter)

- (NSString *)string
{
    return [self stringWithShouldSignature:NO];
}

- (NSString *)stringWithShouldSignature:(BOOL)shouldSignature
{
    NSMutableString *parameterString = [@"" mutableCopy];
    for (id key in ((NSDictionary *)self).allKeys) {
        id value = [self valueForKey:key];
        if (!shouldSignature) {
            NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
            NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
            value = [[NSString stringWithFormat:@"%@", [self valueForKey:key]] stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        }
        [parameterString appendString:[NSString stringWithFormat:@"%@=%@&", key, value]];
    }
    if (parameterString.length > 0) {
        [parameterString deleteCharactersInRange:NSMakeRange(parameterString.length - 1, 1)];
    }
    return parameterString;
}

- (NSData *)data
{
    if ([NSJSONSerialization isValidJSONObject:self]) {
        return [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    }
    return nil;
}

@end
