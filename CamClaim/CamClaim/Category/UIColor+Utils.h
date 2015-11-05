//
//  UIColor+Utils.h
//  KufaLottery
//
//  Created by Xia Zhiyong on 14-12-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIColor (Utils)

/**
 *	@brief	RGB值转换为UIColor对象
 *
 *	@param 	inColorString RGB值，如“＃808080”这里只需要传入“808080”
 *
 *	@return	UIColor对象
 */
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;

@end
