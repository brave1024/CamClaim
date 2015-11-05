//
//  CompanyViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/10/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CompanyViewController.h"
#import "NoticeViewController.h"
#import "JoinCompanyViewController.h"
#import "InviteCompanyViewController.h"
#import "CompanyCell.h"

@interface CompanyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UIView *viewTableHead;
@property (nonatomic, strong) IBOutlet UIView *viewSection4Join;
@property (nonatomic, strong) IBOutlet UIView *viewSection4My;

@property BOOL hasCompany;  // 用户已加入公司

@end

@implementation CompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHead;
    
    self.hasCompany = YES;
    [self.tableview reloadData];
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


#pragma mark - TapGesture

- (IBAction)jumpToInviteCompany
{
    InviteCompanyViewController *inviteVC = [[InviteCompanyViewController alloc] initWithNibName:@"InviteCompanyViewController" bundle:nil];
    [self.navigationController pushViewController:inviteVC animated:YES];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.hasCompany == YES)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.hasCompany == YES)
    {
        if (section == 0)
        {
            return self.viewSection4Join;
        }
        else
        {
            return self.viewSection4My;
        }
    }
    else
    {
        return self.viewSection4Join;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.hasCompany == YES)
    {
        if (section == 0)
        {
            return 1;
        }
        else
        {
            return 6;
        }
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"companyCell";
    CompanyCell *cell = (CompanyCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [CompanyCell cellFromNib];
    }
    
    if (self.hasCompany == YES)
    {
        if (indexPath.section == 0)
        {
            cell.imgviewPic.hidden = YES;
            cell.viewAdd.hidden = NO;
            cell.lblContemt.text = @"Join New Company";
            cell.imgviewArrow.hidden = NO;
        }
        else
        {
            cell.imgviewPic.hidden = NO;
            cell.viewAdd.hidden = YES;
            cell.imgviewArrow.hidden = YES;
            cell.lblContemt.text = @"Cookov Co.Ltd.";
        }
    }
    else
    {
        cell.imgviewPic.hidden = YES;
        cell.viewAdd.hidden = NO;
        cell.lblContemt.text = @"Join New Company";
        cell.imgviewArrow.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BOOL jumpFlag = NO;
    
    if (self.hasCompany == YES)
    {
        if (indexPath.section == 0)
        {
            jumpFlag = YES;
        }
    }
    else
    {
        jumpFlag = YES;
    }
    
    if (jumpFlag == YES)
    {
        JoinCompanyViewController *joinVC = [[JoinCompanyViewController alloc] initWithNibName:@"JoinCompanyViewController" bundle:nil];
        [self.navigationController pushViewController:joinVC animated:YES];
    }
}


@end
