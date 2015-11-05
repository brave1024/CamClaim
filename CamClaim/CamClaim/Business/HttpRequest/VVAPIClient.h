//
//  VVAPIClient.h
//  VV
//
//  Created by yin pengfei on 14-9-18.
//  Copyright (c) 2014年 yin pengfei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kVVAPIServerHost;

@interface VVAPIClient : NSObject

+ (NSString *)relativePathForUserLoginId;
+ (NSString *)relativePathForUserRegist;
+ (NSString *)relativePathForOcr;
+ (NSString *)relativePathForSum;

//+ (NSString *)relativePathForUserRemarkFriendWithFriendId:(id)aFriendId remark:(NSString *)aRemark;

@end
