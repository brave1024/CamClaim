//
//  PGToast.h
//  
//
//  Created by Xia Zhiyong on 12-12-21.
//  Copyright (c) 2012年 archermind. All rights reserved.
//  Toast

#import <Foundation/Foundation.h>

@interface PGToast : NSObject 

/**
 *	@brief	弹出PGtoast方法。
 */
- (void)show;

/**
 *	@brief	构造一个PGToast对象
 *
 *	@param 	text 	需要显示的字符串
 *
 *	@return	返回的PGToast对象
 */
+ (PGToast *)makeToast:(NSString *)text;

@end
