//
//  Constant.h
//  LotteryKufa
//
//  Created by Xia Zhiyong on 14-6-16.
//  Copyright (c) 2014年 Kufa. All rights reserved.
//

#ifndef LotteryKufa_Constant
#define LotteryKufa_Constant


#pragma mark -
#pragma mark ==============账号==============

// 测试账号
// username: joye
// password: 123456

// terry
// 123456



#pragma mark -
#pragma mark ==============后台地址==============

//#define kBaseUrl @"http://115.29.105.23:8080"         // 测试服务器
#define kBaseUrl @"http://camclaim.cloudapp.net"        // 正式服务器
#define KFServerStatus 1                                // 正式环境




#pragma mark -
#pragma mark ==============App相关信息==============

// app store
#define kAppID @"1029293366"    // 发布到app store中的appid
#define kAppUrl  @"http://itunes.apple.com/lookup?id=1029293366"        // 全球
//#define kAppUrl  @"http://itunes.apple.com/cn/lookup?id=1029293366"     // 中国区要加cn
#define kAppDownload @"http://itunes.apple.com/app/id1029293366"
//#define kAppDownload @"http://itunes.apple.com/cn/app/id1029293366"
#define kAppComment @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1029293366"

// 当前版本
#define kCurrentVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// AppDelegate
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
// 系统版本
#define __CUR_IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue] * 10000)
// 屏幕高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// window
#define kAppWindow (UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0]
// 字体
#define KFFontName @"JXiHei"

#define __WEAKSELF typeof(self) __weak wself = self;



#pragma mark -
#pragma mark ==============Groups Sharing==============

// For App Groups
#ifdef TEST
    // App Groups Identifier For Sharing Data...<Test Version>
    #define KFAppGroupsIdentifier (@"group.com.kufa88.test")
#else
    // App Groups Identifier For Sharing Data...<App Store Version>
    #define KFAppGroupsIdentifier (@"group.com.kufa88.appstore")
#endif


// For Keychain Sharing
#ifdef INHOUSE

    // 企业版

    // 酷发巴巴彩票pro<官网产品>
    #define KFKeychainSharing @"F3T8B798U2.com.kufa88.lottery"              // $(AppIdentifierPrefix) F3T8B798U2

#else

    // App Store版

    #ifdef KUFA2

        // 酷发彩票<已下线>
        #define KFKeychainSharing @"P66FLL7BA2.com.kf882.LotteryKufa"       // $(AppIdentifierPrefix) P66FLL7BA2

    #else

        #ifdef TEST
            // 酷发彩票测试版<内部测试,不上线>
            #define KFKeychainSharing @"P66FLL7BA2.com.CTMedia.kufaTest"    // $(AppIdentifierPrefix) P66FLL7BA2
        #else
            // 酷发巴巴彩票appstore<线上产品>
            #define KFKeychainSharing @"P66FLL7BA2.com.kf.LotteryKufa"      // $(AppIdentifierPrefix) P66FLL7BA2
        #endif

    #endif

#endif


// 初始化KeychainItemWrapper时传的id
#define KFKeychainIdForAccount @"Kufa Account"




#pragma mark -
#pragma mark ==============文件夹名称==============

// 缓存在doc中的数据文件名

// 本地文档缓存路径
#define kDOC_FOLDER_NAME @"doc"
// 本地图片缓存路径
#define kIMAGE_FOLDER_NAME @"image"
// 本地音频文件缓存路径
#define kAUDIO_FOLDER_NAME @"audio"
// 本地音频文件缓存路径
#define kVIDEO_FOLDER_NAME @"video"
// 本地头像缓存路径
#define kAVATAR_FOLDER_NAME @"avatar"
// 本地临时文件缓存路径
#define kTEMP_FOLDER_NAME @"tmp"

// 保存在doc下的数据库文件名
#define kDataBase          @"CamClaim"




#pragma mark -
#pragma mark ==============Key==============

// 用户反馈时填写的联系方式
#define KFUserContact                       @"userContact"

// 是否自动登录
#define KFNotAutoLogin                      @"notAutoLogin"

// 大礼包弹屏日期
#define KFPackageDate                       @"packageDate"

// 当前程序启动次数
#define KFAppLaunchTime                     @"appLaunchTime"

// 用户信息
#define KFUserInfo                          @"UserInfo"
#define KFUserName                          @"UserName"
#define KFPassword                          @"PassWord"

// 用于TouchID登录操作而保存的用户名和密码
// 永远只保存当前app中最后一次登录的用户名和密码...<如果用户切换了账号,则更新保存的本地数据>
#define UserName4TouchID                    @"UserName4TouchID"
#define Password4TouchID                    @"Password4TouchID"

// 保存TouchID是否开启的状态
#define TouchIDIsOpen                       @"TouchIDIsOpen"

// Push消息中的附加url字段
#define KFPushUrl                           @"kufaUrl"      // 收到通知后打开h5页面
#define KFMeChat                            @"MeChat"       // 收到通知后打开客服界面
#define KFJumpVC                            @"inApp"        // 跳指定界面

#define KFLotteryType                       @"lotteryType"
#define KFLotteryBonus                      @"lotteryBonus"

// 用户选中的支付方式
// 0-未选中or未充值成功过 1-支付宝 2-微信 3-银联
#define KFPayType                             @"PayType"

//YES 为应用内购买，NO为网页购买，默认为NO
#define USER_DEFAULT_KEY_APP_PAYMENT_METHODS  @"kufa88_app_payment_methods"
//YES 为开启充值，NO为关闭充值，默认为NO
#define USER_DEFAULT_KEY_APP_RECHARGE_METHODS @"kufa88_app_recharge_methods"

// 是否显示大乐透与双色球的遗漏值
#define KFShowSuperLottoeryNumber             @"ShowSuperLottoeryNumber"
#define KFShowDoubleColorBallNumber           @"ShowDoubleColorBallNumber"

// 友盟在线参数Key
#define KFAppRegBonusPromotion                @"AppRegBonusPromotion"
#define KFAppMainPromotion                    @"AppMainPromotion"
#define KFScoreliveTag                        @"scoreliveTag"
#define KFMaxItemsToFetch                     @"maxItemsToFetch"
#define KFMinCashWithdrawal                   @"MinCashWithdrawal"
#define KFMaxCashWithdrawal                   @"MaxCashWithdrawal"
#define KFPayFlag                             @"payFlag"

//  记录首页单关投注倍数
#define KFHallSingMultiple                    @"HallSingMultiple"

// 记录首页数字彩
#define KFHallNumMultiple                     @"HallNumMultiple"

// 最终的支付开启状态
#define KFPayStatus                           @"payStatus"




#pragma mark -
#pragma mark ==============NSUserDefaults==============

// pin code
#define kPinCode            @"PinCode"
// 记住密码
#define kRememberPsw        @"RememberPassword"
// 用户名与密码
#define kUserName           @"UserName"
#define kPassword           @"Password"
// 登录类型
#define kLoginType          @"LoginType"    // YES-手动登录 NO-授权登录
//#define kLoginNormal        @"LoginNormal"  // (账号密码)手动登录
//#define kLoginJoint         @"LoginJoint"   // (第三方联合)授权登录




#pragma mark -
#pragma mark ==============全局设置==============

// 不同版本的iPhone设备的屏幕宽度
#define kWidthFor5      320
#define kWidthFor6      375
#define kWidthFor6plus  414

// 不同版本的iPhone设备的屏幕高度
#define kHeightFor4     480
#define kHeightFor5     568
#define kHeightFor6     667
#define kHeightFor6plus 736

// 分页条数
#define kNumberInPage   20

// 数字
#define NUMBERS         @"0123456789n"




#pragma mark -
#pragma mark ==============提示语==============

// 无网络
#define kNetworkErrorMsg    @"网络连不上"
// 加载提示
#define kLoading            @"加载中..."
#define kLoadingOver        @"数据加载完毕"
#define kLoadingNoData      @"暂无数据"
#define kUploading          @"上传中..."
#define kDownloading        @"下载中..."
#define kORCScaning         @"识别中..."
#define kSumbiting          @"提交中..."
// 分享标题
#define kShareTitle         @"酷发巴巴彩票"
// 微信朋友圈分享标题...<因为朋友圈不显示内容,只显示标题>
#define kTimeLineShareTitle @"快来领取酷发巴巴新人大礼包“充30得88”，手机投注双色球、大乐透、竞彩足球"
// 分享内容
#define kShareContent       @"快来领新人大礼包“充30得88”，手机投注双色球、大乐透、竞彩足球"
// 分享链接
#define kShareUrl           @"http://www.kufa88.com"




#pragma mark -
#pragma mark ==============通知==============

// 登录成功后的通知
#define kLoginSuccess               @"LoginSuccess"

// 自动登录操作结束后的通知
#define kAutoLoginOver              @"autoLoginOver"

// 注销
#define kLogout                     @"Logout"

// （新用户）注册完成
#define kRegisterOver               @"RegisterOver"

// 新增发票成功
#define kAddNewClaimSuccess         @"AddNewClaim"

// 更新用户头像
#define kUpdateAvatar               @"UpdateAvatar"

// 更新用户个人信息
#define kUpdateUserInfo             @"UpdateUserInfo"




#pragma mark -
#pragma mark ==============第三方平台相关==============

// 友盟key
#define kUMengKey @"55cadbb7e0f55ad438001bb7"    // kufa88 51c1369556240b164a036dbd

// 渠道号
#define kChannel @"App Store"


// 支付宝相关
// Kufa88
#define KFPartner @"2088101090073395"
#define KFSeller @"winbets@126.com"
#define KFPrivateKey @""
#define KFAppID @"2015012300027377"


// 美洽appkey (用于客户服务)
#define KFMCAppKey  @"552391144eae35c960000004"


// 腾讯信鹆push key
#define XGAccessId 2200147317
#define XGAccessKey @"IS9QV97Q9W2P"
//#define XGSecretKey @"89df45e73946243c0ee06d6dfca6dec8"

// 未登录用户使用信鹆push注册设备时默认设置的别名
#define kPushAccountForNotLogin @"CamClaim_iOS_Push"


// 微信支付/分享相关...<酷发>
#define KFWechatAppID @"wx2684b8d56b71a333"
#define KFWechatAppSecret @"443b464a1f7b74e452357a7ddf4903c3"
#define KFWechatPartnerID @"1218688401"


// QQ及QQ空间
#define KFQQAppID @"1101017798"
#define KFQQAppIDKey @"LzzWbu4VzaPDjKAt"


// 新浪微博
#define KFSinaAppKey @"962651886"
#define KFSinaAppSecret @"f3f32efc27a8e89b9fadc19b8c2d2220"


/*****************************************************************/


// shareSDK
// 自申请...~!@
// 第三方联合（授权）登录sdk...<包括Wechat, Facebook, LinkedIn>
#define kMobAppKey              @"97a35e34c2ba"
#define kMobAppSecret           @"a60732bca0a9764938ff3732714ed597"

// Wechat
// 自申请...~!@
// 审核已通过，直接使用
#define kWechatAppID            @"wx3535b4d97f989b35"
#define kWechatAppSecret        @"a0fb9d55542dc8e8e52b84b6b3062898"
#define kWechatPartnerID        @""

// LinkedIn
// 自申请...~!@
// 无需审核，直接使用
#define kLinkedInApiKey         @"75zdmowsi5xnjr"                       // 客户端编号
#define kLinkedInSecretKey      @"anyA6H8pqaCbmyus"                     // 客户端密码
#define kLinkedInAppId          @"4575401"                              // 应用编号

// Facebook <API Version: v2.4>
// 自申请...~!@
// 未提交审核，暂不使用
#define kFacebookAppKey         @"867696363312216"                      // App ID
#define kFacebookAppSecret      @"2a0d83cb295eb232608adbd98aa9c471"     // App Secret


// 注：Dropbox 与 Onedrive 平台均使用 Cam_Claim

// 1. Dropbox <Cam Claim> <访问所有dropbox文件>
// 自申请...~!@
// 无需审核，直接使用
//#define kDropboxAppKey         @"xmnq64p2xuzqc1c"                      // AppKey
//#define kDropboxAppSecret      @"fmibic238hbibu6"                      // AppSecret
// 2. Dropbox <Cam_Claim> <访问app父文件夹中的以当前app命名的子文件夹"Cam_Claim">
#define kDropboxAppKey         @"okmkovgzfh30fxg"                      // AppKey
#define kDropboxAppSecret      @"ynd7yq67326q4ch"                      // AppSecret

// 1. Onedrive <Cam Claim>
// 自申请...~!@
// 无需审核，直接使用
// https://account.live.com/developers/applications/index
//#define kOnedriveAppID         @"0000000048163667"                      // 客户端 ID
//#define kOnedriveAppSecret     @"RyltUhrbeyS4CFHAqFV92ejiGjRY-74b"      // 客户端密钥(v1)
// 2. Onedrive <Cam_Claim>
#define kOnedriveAppID         @"0000000048163668"                      // 客户端 ID
#define kOnedriveAppSecret     @"w-h9CUOOs-rkbKEXspwWQLgy2J8a6o31"      // 客户端密钥(v1)




#pragma mark -
#pragma mark ==============跳转回App时的URL Schemes==============

// 用于从safari跳转回app时,以区分具体打开哪一个app
#ifdef INHOUSE

// 企业版
#define KFClientSchemaString @"kufa883"
#define KFAlixPaySchema @"kufa88.AlixPay.3"

#else

// App Store版
#ifdef KUFA2
#define KFClientSchemaString @"kufa882"
#define KFAlixPaySchema @"kufa88.AlixPay.2"
#else
#define KFClientSchemaString @"kufa88"
#define KFAlixPaySchema @"kufa88.AlixPay.1"
#endif

#endif




#pragma mark -
#pragma mark ==============银联支付==============

#define MODEL_UNIONPAY 0 // mode 接入模式设定,两个值: @"00":代表接入生产环境(正式版 本需要); 0代表00
//                        @"01":代表接入开发测试环境(测 试版本需要); 1代表01




#pragma mark -
#pragma mark ==============枚举==============

// 缓存数据类型
typedef enum {
    KFCacheDefault,             // 无
    KFCacheHomepageType,        // 首页彩种类型数据
    KFCacheHomeLotterySort,     // 首页热门彩种排序
    KFCacheHomepageAds,         // 首页广告
    KFCacheHomepageAdsSmall,    // 首页小图广告
    KFCacheNewsGameInfo,        // 资讯之赛事信息
    KFCacheNewsForcast,         // 资讯之预测推荐
    KFCacheStartUpImgs,         // 启动页信息
    KFCacheActivityVariables    // 大礼包信息
}cacheType;

// 选择类型
typedef NS_ENUM(NSInteger, pickerContentType) {
    pickerContentTypeDate = 0,      // 日期
    pickerContentTypeClaimType,     // 发票类型
    pickerContentTypeCompany,       // 公司
    pickerContentTypeNone = -1      // 未选择类型
};

// 只取前4种状态
typedef NS_ENUM(NSInteger, typeTraffic) {
    typeTrafficCar = 0,         // 汽车
    typeTrafficTrain,           // 火车
    typeTrafficFlight,          // 飞机
    typeTrafficShip,            // 轮船
    typeTrafficMetro,           // 地铁
    typeTrafficOther = -1       // 其它
};

// 只取前3种状态
typedef NS_ENUM(NSInteger, typeFood) {
    typeFoodBreakfast = 0,      // 早餐
    typeFoodLunch,              // 中餐
    typeFoodSupper,             // 晚餐
    typeFoodOther = -1          // 其它
};



#pragma mark -
#pragma mark ==============语言国际化==============

#define locatizedString(_key)  NSLocalizedString(_key, nil);




#pragma mark -
#pragma mark ==============color==============

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




#pragma mark -
#pragma mark ==============Select==============

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)




#pragma mark -
#pragma mark ==============宏通知方法==============

#define addObserver(_selector,_name)\
([[NSNotificationCenter defaultCenter] addObserver:self selector:_selector name:_name object:nil])

#define removeObserverWithName(_name)\
([[NSNotificationCenter defaultCenter] removeObserver:self name:_name object:nil])

#define removeObserver() ([[NSNotificationCenter defaultCenter] removeObserver:self])

#define postNotification(_name)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:nil userInfo:nil])

#define postNotificationWithObject(_name, _obj)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:nil])

#define postNotificationWithInfo(_name, _obj, _infos)\
([[NSNotificationCenter defaultCenter] postNotificationName:_name object:_obj userInfo:_infos])




#pragma mark -
#pragma mark ==============设置==============

#pragma mark - For Compatibility (兼容)
// 对齐方式
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
#define TextAlignmentLeft   NSTextAlignmentLeft
#define TextAlignmentCenter NSTextAlignmentCenter
#define TextAlignmentRight  NSTextAlignmentRight
#else
#define TextAlignmentLeft   UITextAlignmentLeft
#define TextAlignmentCenter UITextAlignmentCenter
#define TextAlignmentRight  UITextAlignmentRight
#endif
// 文本属性
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define TextAttributeTextColor  NSForegroundColorAttributeName
#define TextAttributeFont       NSFontAttributeName
#else
#define TextAttributeTextColor  UITextAttributeTextColor
#define TextAttributeFont       UITextAttributeFont
#endif
// 获取文本高度
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define textSizeWithFont(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define textSizeWithFont(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif
// 多行文本获取高度
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
#define multilineTextSize(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define multilineTextSize(text, font, maxSize) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize] : CGSizeZero;
#endif


#endif
