//
//  NSObject+PropertyListing.m
//  KufaLottery
//
//  Created by kufa on 14-12-3.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "NSObject+PropertyListing.h"
#import <objc/runtime.h>

@implementation NSObject (PropertyListing)

/* 获取对象的所有属性 */
- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i< outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

@end
