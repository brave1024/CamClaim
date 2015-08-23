//
//  MenuViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/6.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "MenuViewController.h"
#import "MainPageViewController.h"
#import "CameraViewController.h"
#import "ReportViewController.h"
#import "CloudViewController.h"
#import "RecordViewController.h"
#import "LoginViewController.h"
#import "UIImageView+WebCache.h"


@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayList;

@property (nonatomic, strong) IBOutlet UIView *viewHeader;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewAvatar;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblCompany;

@property (nonatomic, strong) IBOutlet UIView *viewFooter;

@end


@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:(CGFloat)36/255 green:(CGFloat)101/255 blue:(CGFloat)194/255 alpha:1];
        
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    self.viewHeader.backgroundColor = [UIColor colorWithRed:(CGFloat)36/255 green:(CGFloat)101/255 blue:(CGFloat)194/255 alpha:1];
    
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 98-0.5, kScreenWidth, 0.5)];
    viewLine.backgroundColor = [UIColor whiteColor];
    viewLine.alpha = 0.8;
    [self.viewHeader addSubview:viewLine];
    
    //self.tableview.tableHeaderView = self.viewHeader;
    self.tableview.tableFooterView = nil;
    
    self.lblName.text = @"--";
    self.lblCompany.text = @"--";
    
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


#pragma mark -

- (NSMutableArray *)arrayList
{
    if (_arrayList == nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MenuList" ofType:@"plist"];
        //NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MenuList.plist"];
        _arrayList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    
    return _arrayList;
}


#pragma mark - 

- (UIView *)viewFooter
{
    if (_viewFooter == nil)
    {
        CGFloat viewWidth = 240;
        if (kScreenWidth == kWidthFor5)
        {
            viewWidth = 320 - 80;
        }
        else if (kScreenWidth == kWidthFor6)
        {
            viewWidth = 375 - 120;
        }
        else if (kScreenWidth == kWidthFor6plus)
        {
            viewWidth = 414 - 120;
        }
        
        _viewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
        _viewFooter.backgroundColor = [UIColor clearColor];
        
        UIImage *imgBtn = [UIImage imageNamed:@"btn_register"];
        imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
        
        UIImage *imgBtn_ = [UIImage imageNamed:@"btn_register_press"];
        imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 24, viewWidth-40, 36)];
        [btn setTitle:@"Log out" forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:imgBtn forState:UIControlStateNormal];
        [btn setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [_viewFooter addSubview:btn];
    }
    
    return _viewFooter;
}


#pragma mark - logout

- (void)logoutAction
{
    // 用户注销
    NSLog(@"用户注销...");
    
    [kAppDelegate.navVC popToRootViewControllerAnimated:NO];
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        //
        
        UserManager *user = [UserManager sharedInstance];
        user.userInfo = nil;
        user.allClaimStatus = nil;
        user.hasLogin = NO;
        
        self.imgviewAvatar.image = [UIImage imageNamed:@"avatar_default"];
        self.lblName.text = @"--";
        self.lblCompany.text = @"--";
        
        //
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef removeObjectForKey:kPassword];
        [userDef removeObjectForKey:kLoginType];
        [userDef synchronize];
        
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [kAppDelegate.navVC presentViewController:navVC animated:YES completion:^{
            //
        }];
        
        // 注销通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kLogout object:nil];
        
    }];
}


#pragma mark - Notification

// 1. app启动时的自动登录...<不一定登录成功>
// 2. 登录界面的手动登录...<必定登录成功>
- (void)loginOver
{
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.hasLogin == YES)
    {
        // 登录成功
        [self showUserInfo];
        
        self.tableview.tableFooterView = self.viewFooter;
    }
    else
    {
        // 登录失败
        
        self.tableview.tableFooterView = nil;
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


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 98;
    
    //return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewHeader;
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 40;
    
    if (kScreenHeight == kHeightFor4)
    {
        return 38;
    }
    else
    {
        return 42;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"menuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dic = self.arrayList[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.imageView.image = [UIImage imageNamed:dic[@"imageName"]];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = self.arrayList[indexPath.row];
    NSString *strSelector = dic[@"selectorForJump"];
    if (strSelector != nil && strSelector.length > 0)
    {
        //SEL selector = NSSelectorFromString(strSelector);
        //[self performSelector:selector withObject:nil];
        
        // 消除警告: iOS PerformSelector may cause a leak because its selector is unknown
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(strSelector) withObject:nil];
#pragma clang diagnostic pop
    }
    else
    {
        [kAppDelegate.navVC popToRootViewControllerAnimated:NO];
        [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            //
        }];
    }
}


#pragma mark -

// 跳转到拍照界面
- (void)jumpToCameraVC
{
//    CameraViewController *cameraVC = [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil];
//    [kAppDelegate.navVC popToRootViewControllerAnimated:NO];
//    [kAppDelegate.navVC pushViewController:cameraVC animated:NO];
    
    [kAppDelegate.navVC popToRootViewControllerAnimated:NO];
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        // 返回到主界面后再启动相机
        UIViewController *mainVC = kAppDelegate.navVC.topViewController;
        if ([mainVC isKindOfClass:[MainPageViewController class]] == YES)
        {
            MainPageViewController *vc = (MainPageViewController *)mainVC;
            [vc showCamera];
        }
    }];
}

// 跳转到报表界面
- (void)jumpToReportVC
{
    ReportViewController *reportVC = [[ReportViewController alloc] initWithNibName:@"ReportViewController" bundle:nil];
    [kAppDelegate.navVC popToRootViewControllerAnimated:NO];
    [kAppDelegate.navVC pushViewController:reportVC animated:NO];
    
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        //
    }];
}

// 跳转到云盘界面
- (void)jumpToCloudVC
{
    CloudViewController *cloudVC = [[CloudViewController alloc] initWithNibName:@"CloudViewController" bundle:nil];
    [kAppDelegate.navVC popToRootViewControllerAnimated:NO];
    [kAppDelegate.navVC pushViewController:cloudVC animated:NO];
    
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        //
    }];
}

// 跳转到发票记录界面
- (void)jumpToRecordVC
{
    RecordViewController *recordVC = [[RecordViewController alloc] initWithNibName:@"RecordViewController" bundle:nil];
    [kAppDelegate.navVC popToRootViewControllerAnimated:NO];
    [kAppDelegate.navVC pushViewController:recordVC animated:NO];
    
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        //
    }];
}





@end
