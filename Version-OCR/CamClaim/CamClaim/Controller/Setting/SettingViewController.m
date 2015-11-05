//
//  SettingViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
//#import "UserInfoViewController.h"
#import "BindingViewController.h"
#import "CalendarViewController.h"
#import "HelpViewController.h"
#import "AboutUsViewController.h"
#import "ChangePasswordViewController.h"

@interface SettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayList;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"Setting";
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
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
    //[self.navigationController popViewControllerAnimated:YES];
    
    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        // 点击按钮隐藏菜单栏后的动画
        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
            
        }];
    }];
}


#pragma mark - AutoLayout

- (void)initViewWithAutoLayout
{
    //
    
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


#pragma mark -

- (NSMutableArray *)arrayList
{
    if (_arrayList == nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Setting_Final" ofType:@"plist"];
        //NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MenuList.plist"];
        _arrayList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    
    return _arrayList;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingCell";
    SettingCell *cell = (SettingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [SettingCell cellFromNib];
    }
    
    NSDictionary *dic = self.arrayList[indexPath.row];
    [cell configWithData:dic];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
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
        //
    }
}


#pragma mark - Jump

//- (void)jumpToUserInfo
//{
//    UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:nil];
//    [self.navigationController pushViewController:userInfoVC animated:YES];
//}

// 第三方平台绑定
- (void)jumpToBinding
{
    BindingViewController *bindingVC = [[BindingViewController alloc] initWithNibName:@"BindingViewController" bundle:nil];
    [self.navigationController pushViewController:bindingVC animated:YES];
}

// 修改密码
- (void)jumpToChangePassword
{
    ChangePasswordViewController *changeVC = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    [self.navigationController pushViewController:changeVC animated:YES];
}

// 日历
- (void)jumpToCalendar
{
//    CalendarViewController *calendarVC = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
//    [self.navigationController pushViewController:calendarVC animated:YES];
}

// 帮助
- (void)jumpToHelp
{
    HelpViewController *helpVC = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    [self.navigationController pushViewController:helpVC animated:YES];
}

// 关于我们
- (void)jumpToAboutUs
{
    AboutUsViewController *aboutVC = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
    [self.navigationController pushViewController:aboutVC animated:YES];
}


@end
