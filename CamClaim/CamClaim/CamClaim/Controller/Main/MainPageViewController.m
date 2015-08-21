//
//  MainPageViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "MainPageViewController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "MainCell.h"
#import "SimpleCam.h"
#import "AllClaimStatus.h"
#import "ClaimList.h"
#import "UIImageView+WebCache.h"

// 第三方分享
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"

@interface MainPageViewController () <NavViewDelegate, UITableViewDataSource, UITableViewDelegate, IIViewDeckControllerDelegate, SimpleCamDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UIView *UIViewAds;

@property (nonatomic, strong) IBOutlet UIView *viewTableHead;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewAvatar;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblCompany;

@property (nonatomic, weak) IBOutlet UIView *viewTableFoot;
@property (nonatomic, weak) IBOutlet UILabel *lblPending;
@property (nonatomic, weak) IBOutlet UILabel *lblApproved;
@property (nonatomic, weak) IBOutlet UILabel *lblClaim;
@property (nonatomic, weak) IBOutlet UIButton *btnCapture;

@property (nonatomic, strong) SimpleCam *simpleCam;

@property BOOL hasRequested;    // 是否已经请求过数据
@property (nonatomic, strong) NSMutableArray *arrayClaim;
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

- (IBAction)takePictureAction;

@end


@implementation MainPageViewController

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
    
    // 分享
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableview.tableHeaderView = self.viewTableHead;
    //self.tableview.tableFooterView = self.viewTableFoot;
    
    // 增加下拉刷新
    [self.tableview addHeaderWithTarget:self action:@selector(refeshingForMainPage) dateKey:@"tableMain"];
    // 自动刷新(一进入程序就下拉刷新)
    //[self.tableview headerBeginRefreshing];
    
//    UIImage *img = [UIImage imageNamed:@"img_input"];
//    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
//    
//    UIImage *img_ = [UIImage imageNamed:@"img_input_press"];
//    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_register"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
//    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_register_press"];
//    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnCapture setBackgroundImage:imgBtn forState:UIControlStateNormal];
//    [self.btnCapture setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnCapture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnCapture setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.hasRequested = NO;
    
    self.lblName.text = @"--";
    self.lblCompany.text = @"--";
    self.lblClaim.text = @"--";
    self.lblPending.text = @"--";
    self.lblApproved.text = @"--";
    
    // 手动登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOver) name:kLoginSuccess object:nil];
    
    // 自动登录完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOver) name:kAutoLoginOver object:nil];
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
    //[self.viewDeckController toggleLeftView];
    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        // 点击按钮隐藏菜单栏后的动画
        //[self.viewDeckController previewBounceView:IIViewDeckLeftSide];
        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
            
        }];
    }];
}

// 隐藏入口
- (void)moreAction
{
//    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    
//    [self presentViewController:navVC animated:YES completion:^{
//        //
//    }];

    
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
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    //[container setIPadContainerWithView:self.view arrowDirect:UIPopoverArrowDirectionUp];
    [container setIPhoneContainerWithViewController:self];
    
    // 创建自定义分享列表
//    NSArray *shareList = [ShareSDK customShareListWithType:
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
//                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
//                          SHARE_TYPE_NUMBER(ShareTypeFacebook),
//                          SHARE_TYPE_NUMBER(ShareTypeTwitter),
//                          SHARE_TYPE_NUMBER(ShareTypeLinkedIn),
//                          SHARE_TYPE_NUMBER(ShareTypeSMS),
//                          SHARE_TYPE_NUMBER(ShareTypeMail),
//                          nil];
    
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeFacebook,
                          ShareTypeTwitter,
                          ShareTypeMail,
                          ShareTypeSMS,nil];
    
    //弹出分享菜单
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


#pragma mark - BtnAction

- (IBAction)takePictureAction
{
    [self showCamera];
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
    [self beginRequestForHomePage];
    
    [self.tableview headerEndRefreshing];
}


#pragma mark - Notification

// 1. app启动时的自动登录...<不一定登录成功>
// 2. 登录界面的手动登录...<必定登录成功>
- (void)loginOver
{
    // 登录操作完成
    [MRProgressOverlayView dismissOverlayForView:self.view.window animated:YES];
    
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.hasLogin == YES)
    {
        // 登录成功
        
        [self showUserInfo];
        
        // 请求首页数据
        [self beginRequestForHomePage];
    }
    else
    {
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
    if (department != nil || position != nil)
    {
        self.lblCompany.text = [NSString stringWithFormat:@"%@ %@", department, position];
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
}


#pragma mark - HTTP Request

- (void)beginRequestForHomePage
{
    self.hasRequested = YES;
    
    [self requestUserRecentFiveClaim];
    
    [self requestUserAllClaimStatus];
}

- (void)requestUserRecentFiveClaim
{
    LogTrace(@"requestUserRecentFiveClaim");
    
    
    [InterfaceManager getUserNewFiveClaimList:^(BOOL isSucceed, NSString *message, id data) {
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":0,"message":"获取失败","data":null,"total":0}
                
                /*
                {
                    "data": [
                             {
                                 "canmoney": null,
                                 "canmoneyvalue": "312.00",
                                 "forusername": "asdasd",
                                 "gmoney": null,
                                 "id": 9,
                                 "jd": null,
                                 "location": "dasda",
                                 "pfile": null,
                                 "status": 0,
                                 "statusname": "pending",
                                 "typeid": 0,
                                 "useinfo": null,
                                 "userid": 0,
                                 "usetime": "2015/07/23",
                                 "wd": null
                             },
                             {
                                 "canmoney": null,
                                 "canmoneyvalue": "1000.00",
                                 "forusername": "王样",
                                 "gmoney": null,
                                 "id": 5,
                                 "jd": null,
                                 "location": "上海",
                                 "pfile": null,
                                 "status": 0,
                                 "statusname": "cancel",
                                 "typeid": 0,
                                 "useinfo": null,
                                 "userid": 0,
                                 "usetime": "2015/07/01",
                                 "wd": null
                             },
                             {
                                 "canmoney": null,
                                 "canmoneyvalue": "400.00",
                                 "forusername": "lili",
                                 "gmoney": null,
                                 "id": 6,
                                 "jd": null,
                                 "location": "沙田",
                                 "pfile": null,
                                 "status": 0,
                                 "statusname": "pending",
                                 "typeid": 0,
                                 "useinfo": null,
                                 "userid": 0,
                                 "usetime": "2015/07/01",
                                 "wd": null
                             },
                             {
                                 "canmoney": null,
                                 "canmoneyvalue": "1000.00",
                                 "forusername": "王样",
                                 "gmoney": null,
                                 "id": 7,
                                 "jd": null,
                                 "location": "上海",
                                 "pfile": null,
                                 "status": 0,
                                 "statusname": "cancel",
                                 "typeid": 0,
                                 "useinfo": null,
                                 "userid": 0,
                                 "usetime": "2015/07/01",
                                 "wd": null
                             },
                             {
                                 "canmoney": null,
                                 "canmoneyvalue": "200.00",
                                 "forusername": "lili",
                                 "gmoney": null,
                                 "id": 8,
                                 "jd": null,
                                 "location": "沙田",
                                 "pfile": null,
                                 "status": 0,
                                 "statusname": "pending",
                                 "typeid": 0,
                                 "useinfo": null,
                                 "userid": 0,
                                 "usetime": "2015/07/01",
                                 "wd": null
                             }
                             ],
                    "message": "获取成功",
                    "status": 1,
                    "total": 0
                }
                */
                
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
                    }
                }
                else
                {
                    NSLog(@"暂无报销数据");
                    //[self toast:@"暂无报销数据"];
                }
            }
        }
        else
        {
            if (message != nil && message.length > 0)
            {
                [self toast:message];
            }
            else
            {
                //[self toast:@"获取最近五项报销记录失败"];
            }
        }
        
    }];
}

- (void)requestUserAllClaimStatus
{
    LogTrace(@"requestUserAllClaimStatus");
    
    
    [InterfaceManager getUserAllClaimStatus:^(BOOL isSucceed, NSString *message, id data) {
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                /*
                {
                    "data": {
                        "approved": 0,
                        "claim": 0,
                        "pending": 0
                    },
                    "message": "获取成功",
                    "status": 1,
                    "total": 0
                }
                */
                
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
                        self.lblClaim.text = self.allClaimStatus.claim;
                    }
                    else
                    {
                        self.lblClaim.text = @"--";
                    }
                    
                    if (self.allClaimStatus.approved != nil && self.allClaimStatus.approved.length > 0)
                    {
                        self.lblApproved.text = self.allClaimStatus.approved;
                    }
                    else
                    {
                        self.lblApproved.text = @"--";
                    }
                    
                    if (self.allClaimStatus.pending != nil && self.allClaimStatus.pending.length > 0)
                    {
                        self.lblPending.text = self.allClaimStatus.pending;
                    }
                    else
                    {
                        self.lblPending.text = @"--";
                    }
                }
                else
                {
                    NSLog(@"获取所有报销状态失败");
                    //[self toast:@"获取所有报销状态失败"];
                }
            }
        }
        else
        {
            if (message != nil && message.length > 0)
            {
                //[self toast:message];
            }
            else
            {
                //[self toast:@"获取所有报销状态失败"];
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
    //return 30;
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
//    view.backgroundColor = [UIColor clearColor];
//    
//    UILabel *lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, (kScreenWidth-20), 20)];
//    lblTime.backgroundColor = [UIColor clearColor];
//    lblTime.text = @"July 2015";
//    lblTime.textAlignment = NSTextAlignmentRight;
//    lblTime.font = [UIFont systemFontOfSize:15];
//    lblTime.textColor = [UIColor whiteColor];
//    [view addSubview:lblTime];
//    
//    return view;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayClaim.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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


@end
