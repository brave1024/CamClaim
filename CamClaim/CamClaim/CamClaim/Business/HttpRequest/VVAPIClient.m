//
//  VVAPIClient.m
//  VV
//
//  Created by yin pengfei on 14-9-18.
//  Copyright (c) 2014年 yin pengfei. All rights reserved.
//

#import "VVAPIClient.h"

//aliyun
NSString * const kVVAPIServerHost                   = @"http://115.29.105.23:8080/sales";
//NSString * const kVVAPIServerHost                   = @"http://171.16.1.107:8080/sales";

//内网，测试环境
//NSString * const kVVAPIServerHost                   = @"http://172.16.10.34:9080/kuaimai";

NSString * const kVVAPILogin                        = @"/user/Login";
NSString * const kVVAPILogout                       = @"/user/logout";
NSString * const kVVAPIRegist                       = @"/user/appRegistUser";
NSString * const publishPhoto                       = @"/content/ocrImages";
NSString * const getSummary                         = @"/content/contentByUser";
NSString * const kVVAPIRegisterAward                = @"/redEnvelopeRule/getInviteRegisterAward";
NSString * const kVVAPIMessagePublishText           = @"/circleMessage/publishText";
NSString * const kVVAPIMessagePublishImages         = @"/circleMessage/publishImages";


@implementation VVAPIClient

+ (NSString *)relativePathForUserLoginId
{
    return [NSString stringWithFormat:@"%@%@",kVVAPIServerHost, kVVAPILogin];
}

+ (NSString *)relativePathForUserRegist
{
    return [NSString stringWithFormat:@"%@%@",kVVAPIServerHost, kVVAPIRegist];
}

+ (NSString *)relativePathForOcr
{
    return [NSString stringWithFormat:@"%@%@",kVVAPIServerHost, publishPhoto];
}

+ (NSString *)relativePathForSum
{
    return [NSString stringWithFormat:@"%@%@",kVVAPIServerHost, getSummary];
}

//+ (NSString *)relativePathForUserRemarkFriendWithFriendId:(id)aFriendId
//                                                   remark:(NSString *)aRemark
//{
//   // id userId = [[NSUserDefaults standardUserDefaults] objectForKey:kVVCacheLoginUserId];
//    //return [NSString stringWithFormat:@"%@%@?userId=%@&friendId=%@&remark=%@",
//      //      kVVAPIServerHost, kVVAPIUserRemarkFriend, userId, aFriendId, aRemark];
//}


@end
