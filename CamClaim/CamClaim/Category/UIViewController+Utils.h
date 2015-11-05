//
//  UIViewController+Utils.h
//  OpenOOIM
//
//  Created by Ian on 14-8-19.
//  Copyright (c) 2014年 武汉九午科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

/**
 * @DO 让键盘消失
 */
- (void)setupForDismissKeyboard;

@end


@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

/**
 *	@DO	提示信息(UIAlertView || UIAlertController)
 */
- (void)alertMsg:(NSString*)msg;

/**
 * @DO 弹出的错误提示文字
 */
- (void)toast:(NSString *)msg;
- (void)toast:(NSString *)msg animated:(BOOL)animated;
- (void)toast:(NSString *)msg isSucceed:(BOOL)isSucceed  animated:(BOOL)animated;

@end
