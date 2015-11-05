//
//  AppDelegate.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "AppDelegate.h"

// VC
//#import "MainPageViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "CloudContentViewController.h"

// ViewDeck
#import "IIViewDeckController.h"
#import "MenuViewController.h"

// 键盘
#import "IQKeyboardManager.h"

// 锁屏
#import "ABPadLockScreenView.h"
#import "ABPadButton.h"
#import "ABPinSelectionView.h"

// 第三方联合登录
#import <ShareSDK/ShareSDK.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
//#import "WeiboSDK.h"
#import "WXApi.h"

// 友盟统计
#import "MobClick.h"

// 腾讯信鹆push
#import "XGPush.h"

// Dropbox
#import <DropboxSDK/DropboxSDK.h>
// Onedrive
#import <OneDriveSDK/OneDriveSDK.h>


@interface AppDelegate () <DBSessionDelegate, DBNetworkRequestDelegate>

@property (nonatomic, copy) NSString *deviceToken;              //
@property (nonatomic, strong) NSDictionary *payload;            //
@property (nonatomic, copy) NSString *urlPush;                  // push消息附带的url地址

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 设置状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // 构建侧滑交互界面
    IIViewDeckController *deckVC = [self generateViewControllerStack];
    [self.window setRootViewController:deckVC];
    [self.window makeKeyAndVisible];
    
    // 设置键盘
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setShouldToolbarUsesTextFieldTintColor:YES];
    
    self.inPinCode = NO;
    self.shareFlag = NO;    // 包含facebook/twitter/linkedin分享
    
    // 增加友盟统计
    [self umengTrack];
    
    // 设置shareSDK
    [self settingShareSDK];
    
    // 设置密码界面色值
    [self setPinCodeViewColor];
    
    // 判断用户登录状态
    [self checkLoginStatus];
    
    // 信鹆push注册
    [self registerDeviceForXGPush];
    
    // push消息启动app
    [self handlePushMessage:launchOptions];
    
    // Setting Cloud For Dropbox/Onedrive/Googledrive
    [self settingForCloud];

    return YES;
}


#pragma mark - 侧滑架构搭建

- (IIViewDeckController *)generateViewControllerStack
{
    // 左侧菜单界面
    MenuViewController *menuVC = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil];
    
    // 中间首页界面
    //MainPageViewController *mainVC = [[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.navVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    // 生成deckVC
    IIViewDeckController *deckVC =  [[IIViewDeckController alloc] initWithCenterViewController:self.navVC
                                                                            leftViewController:menuVC
                                                                           rightViewController:nil];
    deckVC.rightSize = 80;
    deckVC.leftSize = 80;
    deckVC.openSlideAnimationDuration = 0.3;
    deckVC.closeSlideAnimationDuration = 0.3;
    deckVC.bounceDurationFactor = 0.5;
    deckVC.bounceOpenSideDurationFactor = 0.3;
    deckVC.shadowEnabled = YES;
    //deckVC.panningMode = IIViewDeckDelegatePanning;
    deckVC.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToCloseBouncing;
    //[deckVC disablePanOverViewsOfClass:NSClassFromString(@"LoginViewController")];
    
    if (kScreenWidth == kWidthFor5)
    {
        deckVC.rightSize = 80;
        deckVC.leftSize = 80;
    }
    else if (kScreenWidth == kWidthFor6)
    {
        deckVC.rightSize = 120;
        deckVC.leftSize = 120;
    }
    else if (kScreenWidth == kWidthFor6plus)
    {
        deckVC.rightSize = 120;
        deckVC.leftSize = 120;
    }
    
    return deckVC;
}


#pragma mark - ThirdPart Login

// 只需要三个平台: Facebook & Wechat & LinkedIn
- (void)settingShareSDK
{
    [ShareSDK registerApp:kMobAppKey];
    
//    // 添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"];
//    // 当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
//                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls:[WeiboSDK class]];
//    
//    // 添加QQ应用  注册网址   http://mobile.qq.com/api/
//    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
    
    // 1. 微信登陆的时候需要初始化
//    [ShareSDK connectWeChatWithAppId:@"wx2684b8d56b71a333"
//                           appSecret:@"443b464a1f7b74e452357a7ddf4903c3"
//                           wechatCls:[WXApi class]];
    // CamClaim
    [ShareSDK connectWeChatWithAppId:kWechatAppID
                           appSecret:kWechatAppSecret
                           wechatCls:[WXApi class]];
    
    // 2. 添加Facebook应用  注册网址 https://developers.facebook.com
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    // 当前自已注册的facebook应该未提交审核，暂不使用...~!@
//    [ShareSDK connectFacebookWithAppKey:kFacebookAppKey
//                              appSecret:kFacebookAppSecret];
    
    // 3. 添加LinkedIn应用  注册网址 https://www.linkedin.com/secure/developer
    // 注：LinkedIn只能网页授权~!@
//    [ShareSDK connectLinkedInWithApiKey:@"ejo5ibkye3vo"
//                              secretKey:@"cC7B2jpxITqPLZ5M"
//                            redirectUri:@"http://sharesdk.cn"];
    [ShareSDK connectLinkedInWithApiKey:kLinkedInApiKey
                              secretKey:kLinkedInSecretKey
                            redirectUri:@"http://sharesdk.cn"];
    
    // 4. 添加Twitter应用  注册网址  https://dev.twitter.com
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    // 连接邮件
    [ShareSDK connectMail];
//    // 连接短信分享
//    [ShareSDK connectSMS];
//    // 连接打印
//    [ShareSDK connectAirPrint];
//    // 连接拷贝
//    [ShareSDK connectCopy];
}

- (void)testForShare
{

}


#pragma mark - ThirdPart Cloud

- (void)settingForCloud
{
    [self settingDropboxForCloud];
    [self settingOnedriveForCloud];
    [self settingGoogledriveForCloud];
}

- (void)settingDropboxForCloud
{
    // Set these variables before launching the app
    NSString *appKey = kDropboxAppKey;
    NSString *appSecret = kDropboxAppSecret;
    NSString *root = kDBRootAppFolder; // Should be set to either kDBRootAppFolder or kDBRootDropbox
    // You can determine if you have App folder access or Full Dropbox along with your consumer key/secret
    // from https://dropbox.com/developers/apps
    
    // 1. Cam Claim <访问所有dropbox文件>
//    appKey = @"xmnq64p2xuzqc1c";
//    appSecret = @"fmibic238hbibu6";
//    root = kDBRootDropbox;
    
    // 2. Cam_Claim <访问app父文件夹中的以当前app命名的子文件夹"Cam_Claim">
    // Cam_Claim文件夹名称在Dropbox官网上新建app里便已自动创建，包括其父文件夹app
//    appKey = @"okmkovgzfh30fxg";
//    appSecret = @"ynd7yq67326q4ch";
//    root = kDBRootAppFolder;
    
    /*
    // 验证
    NSString *errorMsg = nil;
    if ([appKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound)
    {
        errorMsg = @"Make sure you set the app key correctly in AppDelegate.m";
    }
    else if ([appSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound)
    {
        errorMsg = @"Make sure you set the app secret correctly in AppDelegate.m";
    }
    else if ([root length] == 0)
    {
        errorMsg = @"Set your root to use either App Folder of full Dropbox";
    }
    else
    {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSData *plistData = [NSData dataWithContentsOfFile:plistPath];
        NSDictionary *loadedPlist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:0 format:NULL errorDescription:NULL];
        NSString *scheme = [[[[loadedPlist objectForKey:@"CFBundleURLTypes"] objectAtIndex:2] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
        NSLog(@"urlScheme: %@", scheme);
        
        // plistPath: /private/var/mobile/Containers/Bundle/Application/70E6C194-CDB5-41A5-AC76-74C73A308D85/CamClaim.app/Info.plist
        // urlScheme: db-okmkovgzfh30fxg
        
        if ([scheme isEqual:@"db-APP_KEY"])
        {
            errorMsg = @"Set your URL scheme correctly in Info.plist";
        }
        if ([scheme isEqualToString:[NSString stringWithFormat:@"db-%@", appKey]] == NO)
        {
            errorMsg = @"Set your URL scheme correctly in Info.plist";
        }
    }
    
    if (errorMsg != nil)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error Configuring Session" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    */
    
    // Look below where the DBSession is created to understand how to use DBSession in your app
    DBSession *session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
    session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
    [DBSession setSharedSession:session];
    
    [DBRequest setNetworkRequestDelegate:self];
    
    if ([[DBSession sharedSession] isLinked] == YES)
    {
        //
        NSLog(@"Dropbox Linked...~!@");
    }
    else
    {
        //
        NSLog(@"Dropbox Not Linked");
    }
}

- (void)settingOnedriveForCloud
{
    
}

- (void)settingGoogledriveForCloud
{
    [ODClient setMicrosoftAccountAppId:kOnedriveAppID scopes:@[@"wl.signin", @"wl.offline_access", @"onedrive.readwrite"]];
    
}


#pragma mark - LoginCheck

// 判断登录状态
- (void)checkLoginStatus
{
    self.isLogin = NO;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    // 判断有无登录成功过...<准备来说，是判断有无保存的用户名和密码>
    NSString *userName = [userDef valueForKey:kUserName];
    NSString *password = [userDef valueForKey:kPassword];
    if (userName != nil && userName.length > 0
        && password != nil && password.length > 0)
    {
        // 用户已登录过
        // 自动登录...<弹出pin code界面>
        NSLog(@"用户已登录过...~!@");
        
        // 自动登录
        [self startLogin];
        
        // 输入pin code
        [self inputPinCode];
    }
    else
    {
        // 用户未登录过
        // 弹出登录界面...<登录成功后,让用户设置pin code>
        NSLog(@"用户未登录过...");
        
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navVC presentViewController:navVC animated:YES completion:^{
            //
        }];
    }
}

// 自动登录
- (void)startLogin
{
    self.isLogin = YES;
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSString *userName = [userDef valueForKey:kUserName];
    NSString *password = [userDef valueForKey:kPassword];
    BOOL normalLogin = [userDef boolForKey:kLoginType];
    
    if (normalLogin == YES)
    {
        // 手动登录...<密码为明文>
        LogTrace(@"手动登录...<密码为明文>");
        
        [InterfaceManager userLogin:userName password:password completion:^(BOOL isSucceed, NSString *message, id data) {
            
            if (isSucceed == YES)
            {
                if (data != nil)
                {
                    NSLog(@"response:%@", data);
                    
                    ResponseModel *response = (ResponseModel *)data;
                    if (response.status == 1)
                    {
                        NSLog(@"登录成功");
                        
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.hasLogin = YES;
                        userManager.userInfo = response.data;
                        NSLog(@"data:%@", userManager.userInfo);
                        
                        // 判断用户信息是否完整；如果不完整，则需要弹出完善资料界面
                        NSNumber *numberFlag = nil;
                        if ((userManager.userInfo.realname != nil && userManager.userInfo.realname.length > 0)
                            && (userManager.userInfo.email != nil && userManager.userInfo.email.length > 0)
                            && (userManager.userInfo.phone != nil && userManager.userInfo.phone.length > 0)
                            && (userManager.userInfo.department != nil && userManager.userInfo.department.length > 0))
                        {
                            // 个人资料完整
                            numberFlag = @(NO); // 不是新用户
                        }
                        else
                        {
                            // 个人资料不完整:姓名、邮箱、手机号、部门...<无公司>
                            numberFlag = @(YES);    // 是新用户
                        }
                        
                        // 自动登录成功通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:numberFlag];
                    }
                    else
                    {
                        NSLog(@"登录失败");
                        
                    }
                }
                else
                {
                    NSLog(@"登录失败");
                    
                }
            }
            else
            {
                NSLog(@"登录失败");
                
            }
            
            // 自动登录操作完成
            self.isLogin = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginOver object:nil];
            
        }];
    }
    else
    {
        // 授权登录...<密码为密文>
        LogTrace(@"授权登录...<密码为密文>");
        
        [InterfaceManager userAutoAuthLogin:userName password:password completion:^(BOOL isSucceed, NSString *message, id data) {
            
            if (isSucceed == YES)
            {
                if (data != nil)
                {
                    NSLog(@"response:%@", data);
                    
                    ResponseModel *response = (ResponseModel *)data;
                    if (response.status == 1)
                    {
                        NSLog(@"登录成功");
                        
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.hasLogin = YES;
                        userManager.userInfo = response.data;
                        NSLog(@"data:%@", userManager.userInfo);
                        
                        // 判断用户信息是否完整；如果不完整，则需要弹出完善资料界面
                        NSNumber *numberFlag = nil;
                        if ((userManager.userInfo.realname != nil && userManager.userInfo.realname.length > 0)
                            && (userManager.userInfo.email != nil && userManager.userInfo.email.length > 0)
                            && (userManager.userInfo.phone != nil && userManager.userInfo.phone.length > 0)
                            && (userManager.userInfo.department != nil && userManager.userInfo.department.length > 0))
                        {
                            // 个人资料完整
                            numberFlag = @(NO); // 不是新用户
                        }
                        else
                        {
                            // 个人资料不完整:姓名、邮箱、手机号、部门...<无公司>
                            numberFlag = @(YES);    // 是新用户
                        }
                        
                        // 自动登录成功通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccess object:numberFlag];
                    }
                    else
                    {
                        NSLog(@"登录失败");
                        
                    }
                }
                else
                {
                    NSLog(@"登录失败");
                    
                }
            }
            else
            {
                NSLog(@"登录失败");
                
            }
            
            // 自动登录操作完成
            self.isLogin = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginOver object:nil];
            
        }];
    }
}

// 输入pin code解锁
- (void)inputPinCode
{
    NSString *pinCode = [[NSUserDefaults standardUserDefaults] valueForKey:kPinCode];
    if (pinCode != nil && pinCode.length > 0 && pinCode.length == 4)
    {
        // 已设置pincode
        NSLog(@"已设置pincode");
        
        self.thePin = pinCode;
        [self showLockScreen];
    }
    else
    {
        // 未设置pincode
        NSLog(@"未设置pincode");
        
        self.thePin = nil;
        [self setPinCode];
    }
}


#pragma mark - Umeng

- (void)umengTrack
{
    // 捕捉异常
    [MobClick setCrashReportEnabled:YES];
    
    // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗(or设置为NO)
    [MobClick setLogEnabled:NO];
    
    //参数为NSString * 类型，自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setAppVersion:XcodeAppVersion];
    
    // reportPolicy为枚举类型,可以为 REALTIME, BATCH, SENDDAILY, SENDWIFIONLY 几种
    // channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    [MobClick startWithAppkey:kUMengKey reportPolicy:BATCH channelId:kChannel];
    
    // 自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
//    [MobClick checkUpdate];
//    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
    // 在线参数配置
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
}

// 友盟在线参数获取成功后的通知
- (void)onlineConfigCallBack:(NSNotification *)note
{
    LogDebug(@"已更新到友盟在线参数...~!@");
    LogDebug(@"online config has fininshed and note = %@", note.userInfo);
    
    // 从友盟在线参数中获取字段内容,不再通过后台接口
    NSString *strLanguageType = [MobClick getConfigParams:@"languageType"];
    NSString *strCanLogout = [MobClick getConfigParams:@"canLogout"];
    
    int languageType = [strLanguageType intValue];
    int canLogout = [strCanLogout intValue];
    
    if (languageType == 0)
    {
        LogDebug(@"简体中文");
    }
    else if (languageType == 1)
    {
        LogDebug(@"繁体中文");
    }
    else
    {
        LogDebug(@"英文");
    }
    
    if (canLogout == 0)
    {
        LogDebug(@"禁止登出");
    }
    else
    {
        LogDebug(@"允许登出");
    }
    
    /***********************************************************************/
    
    NSString *strShare = [MobClick getConfigParams:@"shareFlag"];
    if (strShare != nil && strShare.length > 0)
    {
        int flag = [strShare intValue];
        if (flag == 0)
        {
            self.shareFlag = NO;
            LogDebug(@"不包含facebook/twitter/linkedin分享");
        }
        else
        {
            self.shareFlag = YES;
            LogDebug(@"包含facebook/twitter/linkedin分享");
        }
    }
    else
    {
        self.shareFlag = NO;
        LogDebug(@"友盟在线参数不包含shareFlag字段");
    }
}


#pragma mark - 信鸽推送+Push

// 通过信鹆push注销设备
// 注销设备后需马上重新注册
- (void)unregisterDeviceForXGPush
{
    LogDebug(@"信鹆注销设备...");
    [XGPush unRegisterDevice];
}

// 通过信鹆push注册设备
- (void)registerDeviceForXGPush
{
    NSLog(@"信鹆注册设备...~!@");
    
    // 初始化信鸽 (配置腾讯信鹆push)
    [XGPush startApp:XGAccessId appKey:XGAccessKey];
    // 不同版本,设置不同的tag（开发者可以针对不同的用户设置标签）
    [XGPush setTag:kChannel];
    
    // 设置帐号（别名）: 上报用户的帐号（别名），以便支持按帐号（别名）推送。
    // 在初始化信鸽后，注册设备之前调用。
    //[XGPush setAccount:@""];
    
    // 注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        // 如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            // iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8)
            {
                [self registerPush];
            }
            else
            {
                [self registerPushForIOS8];
            }
#else
            // iOS8之前注册push方法
            // 注册Push服务，注册后才能收到推送
            [self registerPush];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    // 角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

// push注册...<New>
- (void)registerPushForIOS8
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

// push注册 <iOS8
- (void)registerPush
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

// 用户点击push消息后启动app时所作的处理
- (void)handlePushMessage:(NSDictionary *)launchDic
{
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[xgpush]handleLaunching's successBlock");
    };
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[xgpush]handleLaunching's errorBlock");
    };
    
    // 角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [XGPush handleLaunching:launchDic successCallback:successBlock errorCallback:errorBlock];
    
//    NSDictionary *payload = [launchDic objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (payload != nil)
//    {
//        NSLog(@"app被kill后收到push消息时的相关处理");
//        
//        // app被kill后收到push消息时,相关处理在这里完成...
//        self.payload = payload;
//        NSLog(@"payload:%@", self.payload);
//        NSLog(@"<didFinishLaunchingWithOptions>remote notification: %@", [payload JSONString]);
//        
//        // 3个自定义字段
//        // 1. kufaUrl
//        // 2. MeChat
//        // 3. inApp
//        
//        // 1. url
//        id url = [payload objectForKey:KFPushUrl];
//        if ([url isKindOfClass:[NSString class]] && url != nil && ((NSString *)url).length > 0)
//        {
//            NSLog(@"有自定义参数key:%@", KFPushUrl);
//            
//            [self.navController popToRootViewControllerAnimated:NO];
//            [self.tabtabrController setSelectedIndex:0];
//            
//            self.urlPush = url;
//            
//            // 打开push消息中的活动url
//            PushDetailViewController *pushVC = [[PushDetailViewController alloc] init];
//            pushVC.strUrl = self.urlPush;
//            pushVC.dicPayload = self.payload;
//            [self.navController pushViewController:pushVC animated:YES];
//            
//            NSLog(@"显示推送消息详情...<h5页面>");
//            return;
//        }
//        
//        // 2. mechat
//        id meChat = [payload objectForKey:KFMeChat];
//        if ([meChat isKindOfClass:[NSString class]] &&  meChat != nil && ((NSString *)meChat).length > 0)
//        {
//            NSLog(@"有自定义参数key:%@", KFMeChat);
//            
//            UserManager *user = [UserManager sharedInstance];
//            if (user.hasLogin == YES)
//            {
//                // 先返回到大厅
//                [self.navController popToRootViewControllerAnimated:NO];
//                [self.tabtabrController setSelectedIndex:3];
//                
//                UIViewController *selectedVC = self.tabtabrController.selectedViewController;
//                if ([selectedVC isKindOfClass:[UserCenterViewController class]] == YES)
//                {
//                    UserCenterViewController *userVC = (UserCenterViewController *)selectedVC;
//                    [userVC openMeChat];
//                    NSLog(@"显示推送消息详情...<进入美洽客服界面>");
//                }
//            }
//            else
//            {
//                NSLog(@"用户未登录...<不进入美洽客服界面>");
//            }
//            
//            return;
//        }
//        
//        // 3. 跳转到指定界面
//        id jumpKey = [payload objectForKey:KFJumpVC];
//        if ([jumpKey isKindOfClass:[NSString class]] &&  jumpKey != nil && ((NSString *)jumpKey).length > 0)
//        {
//            NSLog(@"有自定义参数key:%@", KFJumpVC);
//            
//            // 先返回到大厅
//            [self.navController popToRootViewControllerAnimated:NO];
//            [self.tabtabrController setSelectedIndex:0];
//            
//            // 跳转...
//            [self jumpToVC:jumpKey];
//            
//            return;
//        }
//        
//        NSLog(@"无自定义参数key:<%@, %@, %@>", KFPushUrl, KFMeChat, KFJumpVC);
//    }
}


#pragma mark -
#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    self.dropboxUserId = userId;
    NSLog(@"Get Dropbox userId:%@", userId);
    
    [[[UIAlertView alloc] initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil] show];
}


#pragma mark -
#pragma mark UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
    if (index != alertView.cancelButtonIndex)
    {
        [[DBSession sharedSession] linkUserId:self.dropboxUserId fromController:self.navVC];
    }
}


#pragma mark -
#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted
{
    outstandingRequests++;
    if (outstandingRequests == 1)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)networkRequestStopped
{
    outstandingRequests--;
    if (outstandingRequests == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}


#pragma mark - Application Circle

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // 进入后台
    self.inBackground = YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 若用户已登录,则显示pincode解锁界面
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.hasLogin == YES)
    {
        // 已登录
        if (self.inPinCode == NO)
        {
            // 不在pincode界面
            if (self.inBackground == YES)
            {
                [self inputPinCode];
                self.inBackground = NO;
            }
            
        }
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // 在线参数获取
    [MobClick startWithAppkey:kUMengKey reportPolicy:BATCH channelId:kChannel];
    [MobClick updateOnlineConfig];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.kufa88.CamClaim" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CamClaim" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CamClaim.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



#pragma mark -
#pragma mark   ============== Remote Push Notification ==============

// 从APNs服务器获取deviceToken后激活该方法
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 保存获取到的devicetoken
    //NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    //token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    //self.deviceToken = token;
    //NSLog(@"deviceToken:%@", self.deviceToken);
    
    // 注册设备...<不需要回调>
    //NSString *deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    NSString *deviceTokenStr = [XGPush getDeviceToken:deviceToken];
    
    // 保存deviceToken
    self.deviceToken = deviceTokenStr;
    NSLog(@"deviceToken:%@", self.deviceToken);
    
    // 腾讯信鹆push回调
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[xgpush]register succussBlock ,deviceToken: %@", deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[xgpush]register errorBlock");
    };
    
    // 注册设备
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    // 打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@", deviceTokenStr);
}

// 注册push功能失败后返回错误信息，执行相应的处理
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"pushError:%@",err.description);
}

// app 运行中 or 后台挂起时, 收到push消息调用的方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // <腾讯信鹆push>...app在前台运行时
    //[XGPush handleReceiveNotification:userInfo];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[xgpush]handleReceiveNotification successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[xgpush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //失败之后的处理...???
        NSLog(@"[xg push completion]userInfo is %@", userInfo);
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
    
    /**********************************************************************/
    
    /*
    {
        "aps": {
            "alert": "酷发新活动，开抢啦。。。",
            "sound": "default"
        },
        "kufaUrl": "http://api.kufa88.com/Activity/Bonus40",
        "xg": {
            "bid": 2524426,
            "ts": 1406874589
        }
    }
    */
    
    self.payload = userInfo;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //NSArray *tPayload = (NSArray *)application.scheduledLocalNotifications;
    //NSLog(@"payload:%@",tPayload);
    NSLog(@"<didReceiveRemoteNotification>remote notification: %@", [userInfo JSONString]);
    
    if ([application applicationState] == UIApplicationStateActive)
    {
        // app在前台运行中...
        // The app is running in the foreground and currently receiving events.
        NSLog(@"UIApplicationStateActive");
        
        // 需判断是否有kufaUrl字段,若有才弹框提示,然后进入webview活动界面
        // 若没有此字段,则push消息的作用仅仅是打开app,而此时app已处于运行状态,故不作任何处理
        
        [self checkPushMessage:userInfo];
    }
//    else if ([application applicationState] == UIApplicationStateInactive)
//    {
//        // app在前台运行中,但不接收事件
//        // The app is running in the foreground but is not receiving events. This might happen as a result of an interruption or because the app is transitioning to or from the background.
//        NSLog(@"UIApplicationStateInactive");
//
//        // 需判断是否有kufaUrl字段,若有则直接进入webview活动界面
//        // 若没有此字段,则不作任何操作,因为用户点击push消息后会自动打开app
//
//        [self checkPushMessage:userInfo];
//    }
//    else if ([application applicationState] == UIApplicationStateBackground)
    else if ([application applicationState] == UIApplicationStateBackground
            || [application applicationState] == UIApplicationStateInactive)
    {
        // app在后台运行中...
        // The app is running in the background.
        NSLog(@"UIApplicationStateBackground");
        
        // 需判断是否有kufaUrl字段,若有则直接进入webview活动界面
        // 若没有此字段,则不作任何操作,因为用户点击push消息后会自动打开app
        
        // 3个自定义字段
        // 1. kufaUrl
        // 2. MeChat
        // 3. inApp
        
        // 1. url
        id url = [userInfo objectForKey:KFPushUrl];
        if ([url isKindOfClass:[NSString class]] && url != nil && ((NSString *)url).length > 0)
        {
            NSLog(@"有自定义参数key:%@", KFPushUrl);
            
            self.urlPush = url;
            
            // 先返回到大厅
            [self.navVC popToRootViewControllerAnimated:NO];
            
            // 再打开push消息中的活动url
//            PushDetailViewController *pushVC = [[PushDetailViewController alloc] init];
//            pushVC.strUrl = self.urlPush;
//            pushVC.dicPayload = self.payload;
//            [self.navController pushViewController:pushVC animated:YES];
            
            NSLog(@"显示推送消息详情");
            return;
        }
    }
}

// 查看push消息详情...
- (void)checkPushMessage:(NSDictionary *)payload
{
    /*
    {
        aps =  {
            alert =  {
                body = "酷发新活动，开抢啦。。";
            };
            sound = default;
        };
        inApp = G001;
        MeChat = "<null>";
        kufaUrl = "http://api.kufa88.com/Activity/Bonus40";
        pushId = 71;
        
        xg = {
            bid = 0;
            ts = 1435287914;
        };
    }
    */
    
    // 3个自定义字段
    // 1. kufaUrl
    // 2. MeChat
    // 3. inApp
    
    NSString *msg = @"";
    NSDictionary *dic = [payload objectForKey:@"aps"];
    if (dic != nil)
    {
        id  alert = [dic objectForKey:@"alert"];
        
        if (alert == nil)
        {
            msg = @"";
        }
        else if  ([alert isKindOfClass:[NSDictionary class]])
        {
            if (((NSDictionary *)alert).count > 0)
            {
                msg = [NSString stringWithString:[((NSDictionary *)alert) objectForKey:@"body"]];
            }
        }
        else if([alert isKindOfClass:[NSString class]])
        {
            msg = [NSString stringWithString:((NSString *)alert)];
        }
    }
    
    self.urlPush = [payload objectForKey:KFPushUrl];
}


#pragma mark - OpenURL

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    NSLog(@"handleOpenURL:%@", url);
    
    // 1. Dropbox
    if ([[DBSession sharedSession] handleOpenURL:url] == YES)
    {
        if ([[DBSession sharedSession] isLinked] == YES)
        {
            // 授权成功后，跳转到指定界面
            CloudContentViewController *contentVC = [[CloudContentViewController alloc] initWithNibName:@"CloudContentViewController" bundle:nil];
            contentVC.cloudType = 2;
            [self.navVC pushViewController:contentVC animated:YES];
            
            return YES;
        }
    }
    
    // 2. ShardSDK
    if ([ShareSDK handleOpenURL:url wxDelegate:nil] == YES)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"openURL:%@", url);
    
    // openURL:db-okmkovgzfh30fxg://1/cancel?
    // openURL:db-okmkovgzfh30fxg://1/connect?oauth_token_secret=fnlk3r6zu32qikl&state=ADB0B2A8-BB0F-4774-8C10-0743912B2A3F&uid=455597950&oauth_token=5p59imxuaz2e62a4
    // openURL:db-okmkovgzfh30fxg://1/connect?oauth_token_secret=iybeay6h02pcx7m&state=EE8451F2-4397-44CA-909C-779F48ABCE91&uid=455597950&oauth_token=brc5z259e2tyjsno
    // sourceApplication:com.getdropbox.Dropbox
    
    // uid不变...~!@
    
    // 1. Dropbox
    if ([[DBSession sharedSession] handleOpenURL:url] == YES)
    {
        if ([[DBSession sharedSession] isLinked] == YES)
        {
            // 授权成功后，跳转到指定界面
            CloudContentViewController *contentVC = [[CloudContentViewController alloc] initWithNibName:@"CloudContentViewController" bundle:nil];
            contentVC.cloudType = 2;
            [self.navVC pushViewController:contentVC animated:YES];
            
            return YES;
        }
    }
    
    // 2. ShardSDK
    if ([ShareSDK handleOpenURL:url
              sourceApplication:sourceApplication
                     annotation:annotation
                     wxDelegate:nil] == YES)
    {
        return YES;
    }
    
    return NO;
}


#pragma mark - PinCode

- (void)setPinCodeViewColor
{
    // 界面背景色
    //[[ABPadLockScreenView appearance] setBackgroundColor:[UIColor colorWithRed:(CGFloat)9/255 green:(CGFloat)82/255 blue:(CGFloat)168/255 alpha:1]];
    [[ABPadLockScreenView appearance] setBackgroundColor:[UIColor colorWithRed:(CGFloat)248/255 green:(CGFloat)127/255 blue:(CGFloat)31/255 alpha:1]];
    // 界面文字色
    [[ABPadLockScreenView appearance] setLabelColor:[UIColor whiteColor]];
    
    UIColor *color = [UIColor colorWithRed:229.0f/255.0f green:180.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
    
    [[ABPadButton appearance] setBackgroundColor:[UIColor clearColor]]; // 数字btn的背景色
    [[ABPadButton appearance] setBorderColor:color];                    // 数字btn的边界色
    [[ABPadButton appearance] setSelectedColor:color];                  // 数字btn选中后的填充色
    
    [[ABPinSelectionView appearance] setSelectedColor:color];           // 密码填充色
}

// 设置APP启动密码
- (void)setPinCode
{
    ABPadLockScreenSetupViewController *lockScreen = [[ABPadLockScreenSetupViewController alloc] initWithDelegate:self complexPin:NO subtitleLabelText:@"You need a PIN to continue"];
    lockScreen.tapSoundEnabled = YES;
    lockScreen.errorVibrateEnabled = YES;
    
    lockScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    lockScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //	Example using an image
//    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper"]];
//    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
//    backgroundView.clipsToBounds = YES;
//    [lockScreen setBackgroundView:backgroundView];
    
    [self.navVC presentViewController:lockScreen animated:YES completion:^{
        // 进入pincode界面
        self.inPinCode = YES;
    }];
}

// 解锁APP
- (void)showLockScreen
{
    ABPadLockScreenViewController *lockScreen = [[ABPadLockScreenViewController alloc] initWithDelegate:self complexPin:NO];
    [lockScreen setAllowedAttempts:3];
    
    lockScreen.modalPresentationStyle = UIModalPresentationFullScreen;
    lockScreen.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //Example using an image
//    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallpaper"]];
//    backgroundView.contentMode = UIViewContentModeScaleAspectFill;
//    backgroundView.clipsToBounds = YES;
//    [lockScreen setBackgroundView:backgroundView];
    
    [self.navVC presentViewController:lockScreen animated:YES completion:^{
        // 进入pincode界面
        self.inPinCode = YES;
    }];
}


#pragma mark -
#pragma mark - ABLockScreenDelegate Methods

- (BOOL)padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController validatePin:(NSString *)pin;
{
    NSLog(@"Validating pin %@", pin);
    
    return [self.thePin isEqualToString:pin];
}

// pin code 验证完成
// 只在app启动时才需要验证pin code
- (void)unlockWasSuccessfulForPadLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController
{
    [self.navVC dismissViewControllerAnimated:YES completion:^{
        // 输入成功
        NSLog(@"Pin entry successfull");
        
        // 离开pincode界面
        self.inPinCode = NO;
        
        // pin code输入完成后,显示主界面
        UIViewController *mainVC = [self.navVC topViewController];
        if ([mainVC isKindOfClass:[MainViewController class]] == YES)
        {
            MainViewController *vc = (MainViewController *)mainVC;
            [vc checkUserCurrentStats];
        }
        else
        {
            //
        }
    }];
}

- (void)unlockWasUnsuccessful:(NSString *)falsePin afterAttemptNumber:(NSInteger)attemptNumber padLockScreenViewController:(ABPadLockScreenViewController *)padLockScreenViewController
{
    NSLog(@"Failed attempt number %ld with pin: %@", (long)attemptNumber, falsePin);
}

// 不再回调...<已取消cancel入口>
- (void)unlockWasCancelledForPadLockScreenViewController:(ABPadLockScreenAbstractViewController *)padLockScreenViewController
{
    [self.navVC dismissViewControllerAnimated:YES completion:^{
        //
        NSLog(@"Pin entry cancelled");
    }];
}


#pragma mark -
#pragma mark - ABPadLockScreenSetupViewControllerDelegate Methods

// pin code 设置完成
// 只在登录成功后才需要设置pin code
- (void)pinSet:(NSString *)pin padLockScreenSetupViewController:(ABPadLockScreenSetupViewController *)padLockScreenViewController
{
    [self.navVC dismissViewControllerAnimated:YES completion:^{
        //
        self.thePin = pin;
        NSLog(@"Pin set to pin %@", self.thePin);
        
        // 离开pincode界面
        self.inPinCode = NO;
        
        // save
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setValue:pin forKey:kPinCode];
        [userDef synchronize];
    }];
}



@end
