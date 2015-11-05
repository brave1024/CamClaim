//
//  BaseViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2013年 ags. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <UIGestureRecognizerDelegate>

@end


@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    LogTrace(@"   >>>>>>{ %@ } did load", NSStringFromClass([self class]));
    
    // 设置View背景
    //self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)18/255 green:(CGFloat)82/255 blue:(CGFloat)168/255 alpha:1];
    //self.viewTop.backgroundColor = [UIColor colorWithRed:(CGFloat)17/255 green:(CGFloat)76/255 blue:(CGFloat)155/255 alpha:1];
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    self.viewTop.backgroundColor = [UIColor colorWithRed:(CGFloat)248/255 green:(CGFloat)127/255 blue:(CGFloat)31/255 alpha:1];
    self.viewContent.backgroundColor = [UIColor clearColor];
    
    self.viewContent.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
    
    //
    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
    {
        // This code will only compile on versions >= iOS 7.0
        self.edgesForExtendedLayout= UIRectEdgeNone;
    }
    
    // 增加导航栏
    [self addCustomNavBar];
    
    // 键盘显示与隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知<ios5.0新增>
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
    
    // 界面自动布局设置
    [self initViewWithAutoLayout];
    
    // 界面语言国际化设置
    [self settingLanguage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 用于在界面左侧做右滑手抛时pop当前视图...
//    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
//    {
//        // 用于在界面左侧做右滑手抛时pop当前视图...
//        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }
    
    // 键盘坐标改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 所有界面隐藏默认导航栏
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    LogTrace(@"   >>>>>>{ %@ } will appear", NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 用于在界面左侧做右滑手抛时pop当前视图...
//    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
//    {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
    
    // 移除键盘坐标改变的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    LogTrace(@"   >>>>>>{ %@ } will disappear", NSStringFromClass([self class]));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    LogError(@"   >>>>>>{ %@ } receive memory warning!!!", NSStringFromClass([self class]));
}


#pragma mark -
#pragma mark - 状态栏样式

- (UIStatusBarStyle)preferredStatusBarStyle NS_AVAILABLE_IOS(7_0) // Defaults to UIStatusBarStyleDefault
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Alert & Toast

- (void)alertMsg:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)startLoading:(NSString *)labelText
{
    if (labelText == nil || [labelText isEqualToString:@""])
    {
        labelText = @"加载中...";
    }
    
    [[MBProgressHUD showHUDAddedTo:kAppWindow animated:YES] setLabelText:labelText];
}

- (void)stopLoading
{
    [MBProgressHUD hideAllHUDsForView:kAppWindow animated:YES];
}

- (void)toast:(NSString *)str
{
    if (str == nil || [str isEqualToString:@""])
    {
        return;
    }
    
    PGToast *toast = [PGToast makeToast:str];
    [toast show];
}


#pragma mark - Custom NavBar

- (void)addCustomNavBar
{
    if (self.viewTop != nil)
    {
        self.navView = [NavView viewFromNib];
        self.navView.frame = CGRectMake(0, 0, kScreenWidth, 64);
        self.navView.delegate = self;
        self.navView.lblTitle.hidden = NO;
        self.navView.imgLogo.hidden = YES;
        [self.viewTop addSubview:self.navView];
    }
}


#pragma mark - Keyboard

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    if ([duration doubleValue] > 0)
    {
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        if (keyboardRect.origin.y >= kScreenHeight - 5)
        {
            // 键盘隐藏
            LogTrace(@" %@ keyboard will hide", NSStringFromClass([self class]));
            [self keyboardWillHide:notification];
        }
        else
        {
            // 键盘显示
            LogTrace(@" %@ keyboard will show", NSStringFromClass([self class]));
            [self keyboardWillShow:notification];
        }
    }
    else
    {
        // 键盘高度变化，以后可修改为另一个方法
        LogTrace(@" %@ keyboard change size", NSStringFromClass([self class]));
        [self keyboardWillShow:notification];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    //
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    //
}

// 显示键盘
- (void)hideKeyboard
{
    [self.view endEditing:YES];
}


#pragma mark - screen adapt

// Adapt Screen for iPhone4/4s、iPhone5/5c/5s、iPhone6、iPhone6 plus
- (void)initViewWithAutoLayout
{
    //
}


#pragma mark - LanguageLocation

- (void)settingLanguage
{
    //
}


@end
