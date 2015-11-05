//
//  NSUserDefaults+Utils.h
//  OpenOOIM
//
//  Created by Jiuwu on 14-9-25.
//  Copyright (c) 2014年 武汉九午科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Utils)

//read/wrtie bool values
+ (void)setBool:(BOOL)value forKey:(NSString*)key;
+ (BOOL)boolForKey:(NSString*)key;

//read/write string values
+ (void)setString:(NSString*)value forKey:(NSString*)key;
+ (NSString*)stringForKey:(NSString*)key;

//read/write int values
+ (void)setInt:(int)value forKey:(NSString*)key;
+ (int)intForKey:(NSString*)key;

+ (void)setObject:(id)value forKey:(NSString*)key;
+ (id)objectForKey:(NSString *)key;

// register
+ (void)registerDefaultValueWithTestKey:(NSString *)key;

+ (void)setUserObject:(id)object forKey:(id)key;

+ (id)objectUserForKey:(id)key;

+ (void)removeObjectForKey:(id)key;

@end
