//
//  AppDelegate.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "AppDelegate.h"

// VC
#import "MainPageViewController.h"
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

// Dropbox
#import <DropboxSDK/DropboxSDK.h>
// Onedrive
#import <OneDriveSDK/OneDriveSDK.h>


@interface AppDelegate () <DBSessionDelegate, DBNetworkRequestDelegate>

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
    
    // 设置shareSDK
    [self settingShareSDK];
    
    // 设置密码界面色值
    [self setPinCodeViewColor];
    
#warning TODO: 暂时取消自动登录
    // 判断用户登录状态
    [self checkLoginStatus];
    
    // 增加友盟统计
    [self umengTrack];
    
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
    MainPageViewController *mainVC = [[MainPageViewController alloc] initWithNibName:@"MainPageViewController" bundle:nil];
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
    [ShareSDK connectWeChatWithAppId:@"wx2684b8d56b71a333"
                           appSecret:@"443b464a1f7b74e452357a7ddf4903c3"
                           wechatCls:[WXApi class]];
    // 当前自已注册的facebook应该未提交审核，暂不使用...~!@
//    [ShareSDK connectWeChatWithAppId:kWechatAppID
//                           appSecret:kWechatAppSecret
//                           wechatCls:[WXApi class]];
    
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
    
    // 连接短信分享
    [ShareSDK connectSMS];
    // 连接邮件
    [ShareSDK connectMail];
//    // 连接打印
//    [ShareSDK connectAirPrint];
//    // 连接拷贝
//    [ShareSDK connectCopy];
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
    
    // 判断有无登录成功过
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
            
            self.isLogin = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:kAutoLoginOver object:nil];
            
        }];
    }
}

// 输入pin code已解锁
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
        //
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
        //
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
    // pin code输入完成后,显示主界面
    UIViewController *mainVC = [self.navVC topViewController];
    if ([mainVC isKindOfClass:[MainPageViewController class]] == YES)
    {
        MainPageViewController *vc = (MainPageViewController *)mainVC;
        [vc checkUserCurrentStats];
    }
    else
    {
        //
    }

    [self.navVC dismissViewControllerAnimated:YES completion:^{
        //
        NSLog(@"Pin entry successfull");
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
        
        // save
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setValue:pin forKey:kPinCode];
        [userDef synchronize];
    }];
}



@end
