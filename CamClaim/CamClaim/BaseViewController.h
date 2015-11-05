//
//  BaseViewController.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2013年 ags. All rights reserved.
//  VC基类

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "PGToast.h"
#import "NavView.h"

#define DEFAULT_DIS_EYE 60.0f
#define DEFAULT_DIS_LEFT 135.75f
#define DEFAULT_DIS_TOP 182.5f

@interface BaseViewController : UIViewController <NavViewDelegate>

// 用于容纳自定义导航栏的容器视图 <登录界面与锁屏界面不显示导航栏>
@property (nonatomic, weak) IBOutlet UIView *viewTop;
@property (nonatomic, weak) IBOutlet UIView *viewContent;
@property (nonatomic, strong) NavView *navView;

/**
 *	@brief	提示
 *
 *	@param 	msg 	提示信息
 */
- (void)alertMsg:(NSString*)msg;

/**
 *	@brief	显示加载框
 *
 *	@param 	labelText 	加载框显示内容
 */
- (void)startLoading:(NSString *)labelText;

/**
 *	@brief	隐藏加载框
 */
- (void)stopLoading;

/**
 *	@brief	弹出底部的提示文字
 *
 *	@param 	str 需要弹出的字符串
 */
- (void)toast:(NSString *)str;

/**
 *	@brief	创建自定义的导航栏
 */
- (void)addCustomNavBar;

/**
 *	@brief	自动布局以便适配屏幕
 */
- (void)initViewWithAutoLayout;

/**
 *	@brief	当前界面国际化
 */
- (void)settingLanguage;

/**
 *	@brief	隐藏键盘
 */
- (void)hideKeyboard;


@end
