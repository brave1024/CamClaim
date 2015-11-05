//
//  UIViewController+Utils.m
//  OpenOOIM
//
//  Created by Ian on 14-8-19.
//  Copyright (c) 2014年 武汉九午科技有限公司. All rights reserved.
//

#import "UIViewController+Utils.h"


@implementation UIViewController (Utils)

- (void)setupForDismissKeyboard
{
    __weak UIViewController *weakSelf = self;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene = [NSOperationQueue mainQueue];
    
    [notificationCenter addObserverForName:UIKeyboardWillShowNotification
                                    object:nil
                                     queue:mainQuene
                                usingBlock:^(NSNotification *note){
                                    [weakSelf.view addGestureRecognizer:singleTapGR];
                                }];
    [notificationCenter addObserverForName:UIKeyboardWillHideNotification
                                    object:nil
                                     queue:mainQuene
                                usingBlock:^(NSNotification *note){
                                    [weakSelf.view removeGestureRecognizer:singleTapGR];
                                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    // 此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
}

@end



#import "MBProgressHUD.h"
#import <objc/runtime.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD
{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD
{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}

- (void)showHint:(NSString *)hint
{
    if ([hint isEqualToString:@""] == YES
        || hint == nil)
    {
        hint = @"";
        LogDebug(@"dd");
    }
    
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [self setHUD:hud];
    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?150.f:100.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset
{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [self setHUD:hud];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset = IS_IPHONE_5?200.f:150.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}

- (void)hideHud
{
    [[self HUD] hide:YES];
}

/**
 *	@brief	提示
 *
 *	@param 	msg 	提示信息
 */
- (void)alertMsg:(NSString*)msg
{
    if (__CUR_IOS_VERSION >= __IPHONE_8_0)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

/**
 * @DO 弹出的错误提示文字
 */
- (void)toast:(NSString *)msg
{
    if ([NSString checkContent:msg] == NO)
    {
        msg = @"错误";
    }
    [self toast:msg animated:YES];
}

- (void)toast:(NSString *)msg animated:(BOOL)animated
{
    [self toast:msg isSucceed:NO animated:YES];
}

- (void)toast:(NSString *)msg isSucceed:(BOOL)isSucceed  animated:(BOOL)animated
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    
    MBProgressHUD *mb = [self HUD];
    if (mb == nil || mb.superview == nil)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
        [self setHUD:hud];
        hud.userInteractionEnabled = NO;
        
        UIImageView *imgView = nil;
        if (isSucceed == YES)
        {
            imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithPathForResource:@"icon_temind_success"ofType:@"png"]];
            if ([NSString checkContent:msg] == NO)
            {
                msg = @"成功";
            }
        }
        else
        {
            imgView = [[UIImageView alloc] initWithImage:[UIImage imageWithPathForResource:@"icon_temind_error"ofType:@"png"]];
            if ([NSString checkContent:msg] == NO)
            {
                msg = @"错误";
            }
        }
        
        [hud setCustomView:imgView];
        [hud setMode:MBProgressHUDModeCustomView];
        hud.labelText = msg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.2f];
    }
}


@end
