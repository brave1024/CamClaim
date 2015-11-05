//
//  NSDictionary+Utils.m
//  KKMYForM
//
//  Created by 黄磊 on 13-11-7.
//  Copyright (c) 2013年 Xia Zhiyong. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

- (NSString *)convertToJsonString
{
    NSData *jsonData = nil;
    NSError *jsonError = nil;
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                   options:kNilOptions
                                                     error:&jsonError];
    }
    @catch (NSException *exception) {
        //this should not happen in properly design JSONModel
        //usually means there was no reverse transformer for a custom property
        NSLog(@"EXCEPTION: %@", exception.description);
        return nil;
    }
    
    NSString *theStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return theStr;
}

@end
