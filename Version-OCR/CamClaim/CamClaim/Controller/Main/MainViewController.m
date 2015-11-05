//
//  MainViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/10/11.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "MainViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "CameraViewController.h"
#import "RecordTypeViewController.h"
#import "UserModifyViewController.h"
#import "NoticeViewController.h"
#import "CaptureResutlViewController.h"
#import "MainCell.h"
#import "AllClaimStatus.h"
#import "ClaimList.h"
#import "UIImageView+WebCache.h"

// 第三方分享
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

// 拍照
#import "SimpleCam.h"

// OCR
#import <TesseractOCR/TesseractOCR.h>


#define kTag 100

@interface MainViewController () <NavViewDelegate, UITableViewDataSource, UITableViewDelegate, IIViewDeckControllerDelegate, SimpleCamDelegate, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) IBOutlet UIView *viewTableHead;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewAvatar;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblCompany;
@property (nonatomic, strong) IBOutlet UILabel *lblDate;

@property (nonatomic, strong) IBOutlet UIView *viewSectionHead;
@property (nonatomic, strong) IBOutlet UIView *viewRejected;
@property (nonatomic, strong) IBOutlet UIView *viewApproved;
@property (nonatomic, strong) IBOutlet UIView *viewApproving;
@property (nonatomic, strong) IBOutlet UIView *viewPending;
@property (nonatomic, strong) IBOutlet UIButton *btnRejected;
@property (nonatomic, strong) IBOutlet UIButton *btnApproved;
@property (nonatomic, strong) IBOutlet UIButton *btnApproving;
@property (nonatomic, strong) IBOutlet UIButton *btnPending;

@property (nonatomic, weak) IBOutlet UIView *viewBottom;
@property (nonatomic, weak) IBOutlet UIButton *btnCapture;

@property BOOL hasRequested;    // 是否已经请求过数据
@property (nonatomic, strong) NSMutableArray *arrayClaim;
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

- (IBAction)takePictureAction;

- (IBAction)showRecordForTypeRejected;
- (IBAction)showRecordForTypeApproved;
- (IBAction)showRecordForTypeApproving;
- (IBAction)showRecordForTypePending;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    LogTrace(@"...>>>MainPage viewDidLoad");
    
    //self.title = @"首页";
    
    self.viewDeckController.delegate = self;
    
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    
    // 当前导航栏左侧图标替换
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    // 消息
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:[UIImage imageNamed:@"icon_ring"] forState:UIControlStateNormal];
    
    self.navView.viewDot.hidden = NO;
    self.navView.viewDot.backgroundColor = [UIColor redColor];
    self.navView.viewDot.layer.masksToBounds = YES;
    self.navView.viewDot.layer.cornerRadius = 4;
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self initData];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    //self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableHeaderView = self.viewTableHead;
    
    // 增加下拉刷新
    [self.tableview addHeaderWithTarget:self action:@selector(refeshingForMainPage) dateKey:@"tableMain"];
    // 自动刷新(一进入程序就下拉刷新)
    //[self.tableview headerBeginRefreshing];
    
    self.viewTableHead.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)97/255 blue:(CGFloat)30/255 alpha:1];
    self.viewSectionHead.backgroundColor = [UIColor clearColor];
    self.viewBottom.backgroundColor = [UIColor clearColor];
    
    self.imgviewAvatar.layer.masksToBounds = YES;
    self.imgviewAvatar.layer.cornerRadius = 25;
    self.imgviewAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imgviewAvatar.layer.borderWidth = 1;
    
    UIImage *imgBtn = [UIImage imageNamed:@"new_btn_capture"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
    [self.btnCapture setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [self.btnCapture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCapture setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.hasRequested = NO;
    
    self.lblName.text = @"--";
    self.lblCompany.text = @"--";
    
    [self.btnRejected setTitle:@"--" forState:UIControlStateNormal];
    [self.btnApproved setTitle:@"--" forState:UIControlStateNormal];
    [self.btnApproving setTitle:@"--" forState:UIControlStateNormal];
    [self.btnPending setTitle:@"--" forState:UIControlStateNormal];
    
    [self.btnRejected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnRejected setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [self.btnApproved setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnApproved setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [self.btnApproving setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnApproving setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    [self.btnPending setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPending setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    self.viewRejected.backgroundColor = [UIColor colorWithRed:(CGFloat)240/255 green:(CGFloat)25/255 blue:(CGFloat)27/255 alpha:1];
    self.viewRejected.layer.cornerRadius = 30;
    self.viewRejected.layer.masksToBounds = YES;
    
    self.btnApproved.backgroundColor = [UIColor colorWithRed:(CGFloat)91/255 green:(CGFloat)168/255 blue:(CGFloat)23/255 alpha:1];
    self.btnApproved.layer.cornerRadius = 30;
    self.btnApproved.layer.masksToBounds = YES;
    
    self.btnApproving.backgroundColor = [UIColor colorWithRed:(CGFloat)242/255 green:(CGFloat)97/255 blue:(CGFloat)30/255 alpha:1];
    self.btnApproving.layer.cornerRadius = 30;
    self.btnApproving.layer.masksToBounds = YES;
    
    self.btnPending.backgroundColor = [UIColor colorWithRed:(CGFloat)71/255 green:(CGFloat)190/255 blue:(CGFloat)252/255 alpha:1];
    self.btnPending.layer.cornerRadius = 30;
    self.btnPending.layer.masksToBounds = YES;
}

- (void)initData
{
    // 获取当前日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    //[formatter setDateFormat:@"YYYY.MM.dd hh.mm.ss"];
    //[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString *strDate = [formatter stringFromDate:[NSDate date]];
    self.lblDate.text = strDate;
    
    // Create a queue to perform recognition operations
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    // (包括手动or自动)登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:kLoginSuccess object:nil];
    
    // 自动登录完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOver:) name:kAutoLoginOver object:nil];
    
    // 注销通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutStatus) name:kLogout object:nil];
    
    // 新增发票成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewClaimSuccess) name:kAddNewClaimSuccess object:nil];
    
    // 更新用户头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAvatar) name:kUpdateAvatar object:nil];
    
    // 更新用户个人信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:kUpdateUserInfo object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - NavViewDelegate

// 查看or隐藏菜单栏
- (void)backAction
{
    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        // 点击按钮隐藏菜单栏后的动画
        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
            
        }];
    }];
}

// 查看消息
- (void)moreAction
{
    // 查看消息
    NoticeViewController *noticeVC = [[NoticeViewController alloc] initWithNibName:@"NoticeViewController" bundle:nil];
    noticeVC.fromMainPage = YES;
    [self.navigationController pushViewController:noticeVC animated:YES];
}


#pragma mark - AutoLayout

- (void)initViewWithAutoLayout
{
    if (kScreenWidth == kWidthFor5)
    {
        
    }
    else if (kScreenWidth == kWidthFor6)
    {
        
    }
    else if (kScreenWidth == kWidthFor6plus)
    {
        
    }
}


#pragma mark - Language

- (void)settingLanguage
{
    
    
}


#pragma mark - BtnAction

- (IBAction)takePictureAction
{
    [self showCamera];
}

- (IBAction)showRecordForTypeRejected
{
    NSLog(@"Rejected");
    
    RecordTypeViewController *typeVC = [[RecordTypeViewController alloc] initWithNibName:@"RecordTypeViewController" bundle:nil];
    typeVC.claimType = typeClaimRecordRejected;
    [self.navigationController pushViewController:typeVC animated:YES];
}

- (IBAction)showRecordForTypeApproved
{
    NSLog(@"Approved");
    
    RecordTypeViewController *typeVC = [[RecordTypeViewController alloc] initWithNibName:@"RecordTypeViewController" bundle:nil];
    typeVC.claimType = typeClaimRecordApproved;
    [self.navigationController pushViewController:typeVC animated:YES];
}

- (IBAction)showRecordForTypeApproving
{
    NSLog(@"Approving");
    
    RecordTypeViewController *typeVC = [[RecordTypeViewController alloc] initWithNibName:@"RecordTypeViewController" bundle:nil];
    typeVC.claimType = typeClaimRecordApproving;
    [self.navigationController pushViewController:typeVC animated:YES];
}

- (IBAction)showRecordForTypePending
{
    NSLog(@"Pending");
    
    RecordTypeViewController *typeVC = [[RecordTypeViewController alloc] initWithNibName:@"RecordTypeViewController" bundle:nil];
    typeVC.claimType = typeClaimRecordPending;
    [self.navigationController pushViewController:typeVC animated:YES];
}


#pragma mark - ShowShare

- (void)showShareView
{
    // 分享
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    // 创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //[container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    [container setIPhoneContainerWithViewController:self];
    
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeFacebook,
                          ShareTypeTwitter,
                          ShareTypeLinkedIn,nil];
    
    // 弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}


#pragma mark - User

// 用户在app启动时输入pin code完成后的操作
- (void)checkUserCurrentStats
{
    if (kAppDelegate.isLogin == YES)
    {
        // 自动登录中...
        [MRProgressOverlayView showOverlayAddedTo:self.view.window title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    else
    {
        // 自动登录已完成...
        
        UserManager *userManager = [UserManager sharedInstance];
        if (userManager.hasLogin == YES)
        {
            // 自动登录成功
            
            if (self.hasRequested == YES)
            {
                return;
            }
            
            [self showUserInfo];
            
            // 请求首页数据
            [self beginRequestForHomePage];
        }
        else
        {
            // 自动登录失败, 需手动登录
            
            // 登录失败
            [self toast:@"登录失败,请重试"];
            
            // 弹出登录界面
            LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
            
            [self presentViewController:navVC animated:YES completion:^{
                //
            }];
        }
    }
}


#pragma mark - Refresh

// 刷新已获取数据
- (void)refeshingForMainPage
{
    // 请求首页数据
    //[self beginRequestForHomePage];
    
    [self requestUserRecentFiveClaim:YES];
    
    [self requestUserAllClaimStatus:NO];
    
    [self.tableview headerEndRefreshing];
}


#pragma mark - Notification

// app启动时的自动登录...<不一定登录成功>
- (void)loginOver:(NSNotification *)notification
{
    // 登录操作完成
    [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
    
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.hasLogin == YES)
    {
        // 登录成功
    }
    else
    {
        // 登录失败
        //[self toast:@"登录失败,请重试"];
        
        // 弹出登录界面
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self presentViewController:navVC animated:YES completion:^{
            //
        }];
    }
}

// (手动or自动)登录成功
- (void)loginSucess:(NSNotification *)notification
{
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.hasLogin == YES)
    {
        // 登录成功
        
        // 显示用户信息
        [self showUserInfo];
        
        // 显示用户发票列表
        self.arrayClaim = nil;
        self.allClaimStatus = nil;
        
        // 请求首页数据
        [self beginRequestForHomePage];
        
        // 判断是否需要弹出完善资料界面
        NSNumber *numberFlag = [notification object];
        if (numberFlag != nil && [numberFlag boolValue] == YES)
        {
            // 需跳转到完善个人资料界面
            UserModifyViewController *userInfoVC = [[UserModifyViewController alloc] initWithNibName:@"UserModifyViewController" bundle:nil];
            userInfoVC.registerFlag = YES;  // 登录后完善资料
            [self.navigationController pushViewController:userInfoVC animated:NO];
        }
    }
}

- (void)showUserInfo
{
    UserManager *user = [UserManager sharedInstance];
    
    // 1. 显示姓名
    // 1.1 昵称 or 用户名
    if (user.userInfo.name != nil && user.userInfo.name.length > 0)
    {
        self.lblName.text = user.userInfo.name;
    }
    // 1.2 真实姓名 <优先显示>
    if (user.userInfo.realname != nil && user.userInfo.realname.length > 0)
    {
        self.lblName.text = user.userInfo.realname;
    }
    
    // 2. 部门与职位
    NSString *department = nil;
    NSString *position = nil;
    if (user.userInfo.department != nil && user.userInfo.department.length > 0)
    {
        department = user.userInfo.department;
    }
    if (user.userInfo.zhiwei != nil && user.userInfo.zhiwei.length > 0)
    {
        position = user.userInfo.zhiwei;
    }
    if (department != nil && position != nil)
    {
        self.lblCompany.text = [NSString stringWithFormat:@"%@ %@", department, position];
    }
    else if (department != nil && position == nil)
    {
        self.lblCompany.text = department;
    }
    else if (department == nil && position != nil)
    {
        self.lblCompany.text = position;
    }
    
    // 3. 显示用户图像...
    if (user.userInfo.img != nil && user.userInfo.img.length > 0)
    {
        [self.imgviewAvatar sd_setImageWithURL:[NSURL URLWithString:user.userInfo.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil)
            {
                NSLog(@"图片下载成功...<%@>", [NSURL URLWithString:user.userInfo.img]);
            }
            else
            {
                NSLog(@"图片下载失败...<%@>", [NSURL URLWithString:user.userInfo.img]);
            }
        }];
    }
    else
    {
        self.imgviewAvatar.image = [UIImage imageNamed:@"img_avatar"];
    }
}

- (void)logoutStatus
{
    //
}

// 刷新数据
- (void)addNewClaimSuccess
{
    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:NO];
    [self beginRequestForHomePage];
}

- (void)updateUserAvatar
{
    UserManager *user = [UserManager sharedInstance];
    if (user.userInfo.img != nil && user.userInfo.img.length > 0)
    {
        [self.imgviewAvatar sd_setImageWithURL:[NSURL URLWithString:user.userInfo.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil)
            {
                NSLog(@"图片下载成功...<%@>", [NSURL URLWithString:user.userInfo.img]);
            }
            else
            {
                NSLog(@"图片下载失败...<%@>", [NSURL URLWithString:user.userInfo.img]);
            }
        }];
    }
    
    [self.tableview reloadData];
}

- (void)updateUserInfo
{
    UserManager *user = [UserManager sharedInstance];
    
    // 1. 显示姓名
    // 1.1 昵称 or 用户名
    if (user.userInfo.name != nil && user.userInfo.name.length > 0)
    {
        self.lblName.text = user.userInfo.name;
    }
    // 1.2 真实姓名 <优先显示>
    if (user.userInfo.realname != nil && user.userInfo.realname.length > 0)
    {
        self.lblName.text = user.userInfo.realname;
    }
    
    // 2. 部门与职位
    NSString *department = nil;
    NSString *position = nil;
    if (user.userInfo.department != nil && user.userInfo.department.length > 0)
    {
        department = user.userInfo.department;
    }
    if (user.userInfo.zhiwei != nil && user.userInfo.zhiwei.length > 0)
    {
        position = user.userInfo.zhiwei;
    }
    if (department != nil && position != nil)
    {
        self.lblCompany.text = [NSString stringWithFormat:@"%@ %@", department, position];
    }
    else if (department != nil && position == nil)
    {
        self.lblCompany.text = department;
    }
    else if (department == nil && position != nil)
    {
        self.lblCompany.text = position;
    }
}


#pragma mark - HTTP Request

// 不显示加载指示器
- (void)beginRequestForHomePage
{
    self.hasRequested = YES;
    
    [self requestUserRecentFiveClaim:NO];
    
    [self requestUserAllClaimStatus:NO];
}

- (void)requestUserRecentFiveClaim:(BOOL)showloading
{
    LogTrace(@"requestUserRecentFiveClaim");
    
    if (showloading == YES)
    {
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    [InterfaceManager getUserNewFiveClaimList:^(BOOL isSucceed, NSString *message, id data) {
        
        if (showloading == YES)
        {
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        }
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":0,"message":"获取失败","data":null,"total":0}
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取最近五项报销记录成功");
                    
                    if (self.arrayClaim == nil)
                    {
                        self.arrayClaim = [[NSMutableArray alloc] init];
                    }
                    else
                    {
                        [self.arrayClaim removeAllObjects];
                    }
                    
                    NSArray *arrayData = response.data;
                    for (NSDictionary *dic in arrayData)
                    {
                        NSError *error = nil;
                        ClaimItem *item = [[ClaimItem alloc] initWithDictionary:dic error:&error];
                        if (item != nil && error == nil)
                        {
                            [self.arrayClaim addObject:item];
                        }
                    }
                    
                    // Test
                    //[self.arrayClaim removeAllObjects];
                    
                    if (self.arrayClaim.count > 0)
                    {
                        // 显示
                        [self.tableview reloadData];
                    }
                    else
                    {
                        NSLog(@"暂无报销数据");
                        //[self toast:@"暂无报销数据"];
                        
                        if (showloading == YES)
                        {
                            [self toast:@"暂无报销数据"];
                        }
                    }
                }
                else
                {
                    NSLog(@"暂无报销数据");
                    //[self toast:@"暂无报销数据"];
                    
                    if (showloading == YES)
                    {
                        [self toast:@"暂无报销数据"];
                    }
                }
            }
        }
        else
        {
            if (message != nil && message.length > 0)
            {
                //[self toast:message];
                
                if (showloading == YES)
                {
                    [self toast:message];
                }
            }
            else
            {
                //[self toast:@"获取最近五项报销记录失败"];
                
                if (showloading == YES)
                {
                    [self toast:@"获取最近五项报销记录失败"];
                }
            }
        }
        
    }];
}

- (void)requestUserAllClaimStatus:(BOOL)showloading
{
    LogTrace(@"requestUserAllClaimStatus");
    
    if (showloading == YES)
    {
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    [InterfaceManager getUserAllClaimStatus:^(BOOL isSucceed, NSString *message, id data) {
        
        if (showloading == YES)
        {
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        }
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取所有报销状态成功");
                    
                    self.allClaimStatus = response.data;
                    NSLog(@"data:%@", self.allClaimStatus);
                    
                    //
                    UserManager *userManager = [UserManager sharedInstance];
                    userManager.allClaimStatus = self.allClaimStatus;
                    
                    // 显示
                    if (self.allClaimStatus.claim != nil && self.allClaimStatus.claim.length > 0)
                    {
                        //self.lblClaim.text = self.allClaimStatus.claim;
                        [self.btnApproving setTitle:self.allClaimStatus.claim forState:UIControlStateNormal];
                    }
                    else
                    {
                        //self.lblClaim.text = @"--";
                        [self.btnApproving setTitle:@"--" forState:UIControlStateNormal];
                    }
                    
                    if (self.allClaimStatus.approved != nil && self.allClaimStatus.approved.length > 0)
                    {
                        //self.lblApproved.text = self.allClaimStatus.approved;
                        [self.btnApproved setTitle:self.allClaimStatus.approved forState:UIControlStateNormal];
                    }
                    else
                    {
                        //self.lblApproved.text = @"--";
                        [self.btnApproved setTitle:@"--" forState:UIControlStateNormal];
                    }
                    
                    if (self.allClaimStatus.pending != nil && self.allClaimStatus.pending.length > 0)
                    {
                        //self.lblPending.text = self.allClaimStatus.pending;
                        [self.btnPending setTitle:self.allClaimStatus.pending forState:UIControlStateNormal];
                    }
                    else
                    {
                        //self.lblPending.text = @"--";
                        [self.btnPending setTitle:@"--" forState:UIControlStateNormal];
                    }
                    
                    [self.tableview reloadData];
                }
                else
                {
                    NSLog(@"获取所有报销状态失败");
                    //[self toast:@"获取所有报销状态失败"];
                    
                    if (showloading == YES)
                    {
                        [self toast:@"获取所有报销状态失败"];
                    }
                }
            }
        }
        else
        {
            if (message != nil && message.length > 0)
            {
                //[self toast:message];
                
                if (showloading == YES)
                {
                    [self toast:message];
                }
            }
            else
            {
                //[self toast:@"获取所有报销状态失败"];
                
                if (showloading == YES)
                {
                    [self toast:@"获取所有报销状态失败"];
                }
            }
        }
        
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.viewSectionHead.frame = CGRectMake(0, 0, kScreenWidth, 110);
    return self.viewSectionHead;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayClaim.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellMain";
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [MainCell cellFromNib];
    }
    
    ClaimItem *item = self.arrayClaim[indexPath.row];
    [cell configWithData:item];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
}


#pragma mark - IIViewDeckControllerDelegate

// applies a small, red shadow
- (void)viewDeckController:(IIViewDeckController *)viewDeckController applyShadow:(CALayer *)shadowLayer withBounds:(CGRect)rect
{
    LogTrace(@"applyShadow");
    
//    shadowLayer.masksToBounds = NO;
//    shadowLayer.shadowRadius = 10;
//    shadowLayer.shadowOpacity = 0.5;
//    shadowLayer.shadowColor = [[UIColor redColor] CGColor];
//    shadowLayer.shadowOffset = CGSizeZero;
//    shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    LogTrace(@"didOpenViewSide");
    self.tableview.userInteractionEnabled = NO;
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    LogTrace(@"didCloseViewSide");
    self.tableview.userInteractionEnabled = YES;
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController didShowCenterViewFromSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    LogTrace(@"didShowCenterViewFromSide");
    self.tableview.userInteractionEnabled = YES;
}


#pragma mark - Camera

- (void)showCamera
{
    //    [self recognizeImageWithTesseract:nil];
    //    return;
    
    // 拍照or相册
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    //    actionSheet.tag = kTag;
    //    [actionSheet showInView:self.view.window];
    //    return;
    
    SimpleCam *simpleCam = [SimpleCam new];
    simpleCam.delegate = self;
    [self presentViewController:simpleCam animated:YES completion:nil];
    
    // 直接拍照
    //[self.simpleCam capturePhoto];
}


#pragma mark - SimpleCamDelegate

- (void)simpleCam:(SimpleCam *)simpleCam didFinishWithImage:(UIImage *)image
{
    if (image)
    {
        // simple cam finished with image
        LogTrace(@"已获取到拍照图片");
    }
    else
    {
        // simple cam finished w/o image
        LogTrace(@"未获取到拍照图片");
    }
    
    // Close simpleCam - use this as opposed to 'dismissViewController' otherwise, the captureSession may not close properly and may result in memory leaks.
    [simpleCam closeWithCompletion:^{
        NSLog(@"SimpleCam is done closing ... ");
        
        if (image)
        {
//            CameraViewController *cameraVC = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
//            cameraVC.imgCapture = image;
            
            CaptureResutlViewController *captureVC = [[CaptureResutlViewController alloc] initWithNibName:@"CaptureResutlViewController" bundle:nil];
            captureVC.imgCapture = image;
            [self presentViewController:captureVC animated:YES completion:^{
                //
            }];
        }
        
    }];
}

- (void)simpleCamDidLoadCameraIntoView:(SimpleCam *)simpleCam
{
    NSLog(@"Camera loaded ... ");
}

- (void)simpleCamNotAuthorizedForCameraUse:(SimpleCam *)simpleCam
{
    [simpleCam closeWithCompletion:^{
        NSLog(@"SimpleCam is done closing ... Not Authorized");
    }];
}


#pragma mark - OCR Function

- (void)recognizeImageWithTesseract:(UIImage *)image
{
    // Test
//    image = [UIImage imageNamed:@"eng06"];
//    image = [UIImage imageNamed:@"fra01"];
//    image = [UIImage imageNamed:@"image_sample.jpg"];
//    image = [UIImage imageNamed:@"well_scaned_page.jpg"];
//    image = [UIImage imageNamed:@"eng004"];
    
    // 图片预处理操作: 二值化、灰度处理、
    
//    // 1.二值化
//    UIImage *imgBinary = [image imageBinaryConvert];
//
//    // 2.灰度处理
//    UIImage *imgGray = [imgBinary imageGrayProcess];
//
//    // 最终用于ocr识别的图片
//    UIImage *imgFinal = imgGray;
    
    // Preprocess the image so Tesseract's recognition will be more accurate
    UIImage *bwImage = [image g8_blackAndWhite];
    //UIImage *bwImage = [imgFinal g8_blackAndWhite];
    
    // Animate a progress activity indicator
    //[self.activityIndicator startAnimating];
    
    // Display the preprocessed image to be recognized in the view
    //self.imageToRecognize.image = bwImage;
    
    // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
    // It is assumed that there is a .traineddata file for the language pack
    // you want Tesseract to use in the "tessdata" folder in the root of the
    // project AND that the "tessdata" folder is a referenced folder and NOT
    // a symbolic group in your project
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];   // 指定语言
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng+chi_sim+chi_tra"];   // 指定语言
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng+fra+chi_sim+chi_tra"];   // 指定语言
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"chi_sim+chi_tra"];   // 指定语言
    
    // Use the original Tesseract engine mode in performing the recognition
    // (see G8Constants.h) for other engine mode options
    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;  // 最快最不精确...<中文不支持Cube模式>
    //operation.tesseract.engineMode = G8OCREngineModeCubeOnly;   // 较慢较精确
    //operation.tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;  // 最慢最精确
    
    // Let Tesseract automatically segment the page into blocks of text
    // based on its analysis (see G8Constants.h) for other page segmentation
    // mode options
    //operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;  // 自动页划分
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;  // 自动页划分
    
    // Optionally limit the time Tesseract should spend performing the
    // recognition
    operation.tesseract.maximumRecognitionTime = 60.0;
    
    // Set the delegate for the recognition to be this class
    // (see `progressImageRecognitionForTesseract` and
    // `shouldCancelImageRecognitionForTesseract` methods below)
    operation.delegate = self;
    
    // Optionally limit Tesseract's recognition to the following whitelist
    // and blacklist of characters
    //operation.tesseract.charWhitelist = @"01234";
    //operation.tesseract.charBlacklist = @"56789";
    
    // Set the image on which Tesseract should perform recognition
    operation.tesseract.image = bwImage;
    
    // Optionally limit the region in the image on which Tesseract should
    // perform recognition to a rectangle
    //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
    
    // Specify the function block that should be executed when Tesseract
    // finishes performing recognition on the image
    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
        //
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
        NSLog(@"%@", recognizedText);
        
        // Remove the animated progress activity indicator
        //[self.activityIndicator stopAnimating];
        
        // Spawn an alert with the recognized text
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Result"
                                                        message:recognizedText
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    };
    
    // Finally, add the recognition operation to the queue
    [self.operationQueue addOperation:operation];
}


#pragma mark - G8TesseractDelegate

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can observe the progress.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 */
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can cancel the recogntion
 *  prematurely if necessary.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 *
 *  @return Whether or not to cancel the recognition.
 */
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to cancel recognition prematurely
}


#pragma mark - UIActionSheetdelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"actionSheet button index %ld", (long)buttonIndex);
    
    if (actionSheet.tag == kTag)
    {
        UIImagePickerControllerSourceType aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        switch (buttonIndex)
        {
            case 0:
                NSLog(@"相机");
                aSourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSLog(@"从相册获取图片");
                break;
            default:
                return;
        }
        
        [self pickerImageWithType:aSourceType];
    }
}

- (void)pickerImageWithType:(UIImagePickerControllerSourceType)aSourceType
{
//    sourceType = UIImagePickerControllerSourceTypeCamera;             // 照相机
//    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;       // 图片库
//    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;   // 保存的相片
    
    if (aSourceType == UIImagePickerControllerSourceTypeCamera
        && ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        // 相机不可用时,自动切换到相册
        aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // 初始化
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if(aSourceType == UIImagePickerControllerSourceTypePhotoLibrary
       && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    }
    
    [picker setDelegate:self];
    [picker setAllowsEditing:NO];
    [picker setSourceType:aSourceType];
    [self presentViewController:picker animated:YES completion:nil] ;   // 进入照相界面
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIImage *img = nil;
//    img = [info objectForKey:UIImagePickerControllerEditedImage];
//
//    if (img == nil)
//    {
//        img = [info objectForKey:UIImagePickerControllerOriginalImage];
//    }
    
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            //
            [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kORCScaning mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
            // 识别
            [self recognizeImageWithTesseract:img];
        });
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
