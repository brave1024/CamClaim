//
//  CompanyViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/10/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CompanyViewController.h"
#import "NoticeViewController.h"
#import "SearchCompanyViewController.h"
#import "InviteCompanyViewController.h"
#import "CompanyCell.h"
#import "CompanyModel.h"

@interface CompanyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) IBOutlet UIView *viewTableHead;
@property (nonatomic, strong) IBOutlet UIView *viewSection4Join;
@property (nonatomic, strong) IBOutlet UIView *viewSection4My;

@property (nonatomic, strong) IBOutlet UILabel *lblMoney;
@property (nonatomic, strong) IBOutlet UILabel *lblTip;
@property (nonatomic, strong) IBOutlet UILabel *lblNew;
@property (nonatomic, strong) IBOutlet UILabel *lblMy;

@property (nonatomic, strong) NSMutableArray *arrayCompany;

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
    self.navView.viewDot.hidden = YES;
    self.navView.viewDot.backgroundColor = [UIColor redColor];
    self.navView.viewDot.layer.masksToBounds = YES;
    self.navView.viewDot.layer.cornerRadius = 4;
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self setupRefreshForTableview];
    
    [self initData];
    
    [self settingLanguage];
    
    [self getAllCompany];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHead;
    
    // 默认无公司
    self.hasCompany = NO;
    [self.tableview reloadData];
}

- (void)initData
{
    
}

- (NSMutableArray *)arrayCompany
{
    if (_arrayCompany == nil)
    {
        _arrayCompany = [[NSMutableArray alloc] init];
        
        // Test
//        [_arrayCompany addObject:@"Company 01"];
//        [_arrayCompany addObject:@"Company 02"];
//        [_arrayCompany addObject:@"Company 03"];
//        [_arrayCompany addObject:@"Company 04"];
//        [_arrayCompany addObject:@"Company 05"];
    }
    
    return _arrayCompany;
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
    NSString *strValue = locatizedString(@"compmay_reward");
    self.lblMoney.text = strValue;
    
    strValue = locatizedString(@"company_invite");
    self.lblTip.text = strValue;
    
    strValue = locatizedString(@"company_add_new");
    self.lblNew.text = strValue;
    
    strValue = locatizedString(@"company_my");
    self.lblMy.text = strValue;
}


#pragma mark - TapGesture

- (IBAction)jumpToInviteCompany
{
    InviteCompanyViewController *inviteVC = [[InviteCompanyViewController alloc] initWithNibName:@"InviteCompanyViewController" bundle:nil];
    [self.navigationController pushViewController:inviteVC animated:YES];
}


#pragma mark - Refresh

// 使用MJRefresh
// 当前界面由于是一次加载完指定日期的所有数据，故不做分页
- (void)setupRefreshForTableview
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    // dateKey用于存储刷新时间，可以保证不同界面拥有不同的刷新时间
    [self.tableview addHeaderWithTarget:self action:@selector(headerRereshingForBasketballMatchList) dateKey:@"tableviewList"];
    
    // 自动刷新(一进入程序就下拉刷新)
    //[self.tableview headerBeginRefreshing];
}

// 下拉刷新操作...
- (void)headerRereshingForBasketballMatchList
{
    [self.tableview headerEndRefreshing];
    
    // 首新请求投注比赛列表
    [self getAllCompany];
}


#pragma mark - HttpRequest

// 获取所有公司...
- (void)getAllCompany
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager getUserCompany:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取成功");
                    
                    NSArray *array = response.data;
                    NSLog(@"array:%@", array);
                    
                    if (array != nil && array.count > 0)
                    {
                        // 有加入的公司
                        
                        [self.arrayCompany removeAllObjects];
                        
                        for (NSDictionary *dic in array)
                        {
                            NSError *error;
                            CompanyModel *item = [[CompanyModel alloc] initWithDictionary:dic error:&error];
                            if (item != nil)
                            {
                                [self.arrayCompany addObject:item];
                            }
                        }   // for
                        
                        NSLog(@"arrayCompany:%@", self.arrayCompany);
                        
                        // 保存用户所有已加入的公司
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [NSMutableArray arrayWithArray:self.arrayCompany];
                        
                        self.hasCompany = YES;
                        [self.tableview reloadData];
                    }
                    else
                    {
                        // 无加入的公司
                        
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [[NSMutableArray alloc] init];
                        
                        //[self toast:@"暂无公司,请申请加入"];
                        
                        NSString *strTip = locatizedString(@"no_company");
                        [self toast:strTip];
                        
                        self.hasCompany = NO;
                        [self.tableview reloadData];
                    }
                }
                else
                {
                    NSLog(@"获取失败");
                    //[self toast:@"获取失败"];
                    
                    NSString *strTip = locatizedString(@"loadFail");
                    [self toast:strTip];
                    
                    self.hasCompany = NO;
                    [self.tableview reloadData];
                }
            }
            else
            {
                // 无公司数据
                NSLog(@"获取失败");
                //[self toast:@"获取失败"];
                
                NSString *strTip = locatizedString(@"loadFail");
                [self toast:strTip];
                
                self.hasCompany = NO;
                [self.tableview reloadData];
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
                //[self toast:@"获取失败"];
                
                NSString *strTip = locatizedString(@"loadFail");
                [self toast:strTip];
            }
            
            self.hasCompany = NO;
            [self.tableview reloadData];
        }
        
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
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
            return self.arrayCompany.count;
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
            cell.viewAdd.hidden = YES;
            cell.lblContent.hidden = YES;
            cell.imgviewArrow.hidden = YES;
            
            cell.lblTip.hidden = NO;
            cell.imgviewSearch.hidden = NO;
            
            NSString *strTip = locatizedString(@"company_search");
            cell.lblTip.text = strTip;
            cell.lblTip.textColor = [UIColor lightGrayColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else
        {
            CompanyModel *item = self.arrayCompany[indexPath.row];
            [cell configWithData:item];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    else
    {
        if (indexPath.section == 0)
        {
            cell.imgviewPic.hidden = YES;
            cell.viewAdd.hidden = YES;
            cell.lblContent.hidden = YES;
            cell.imgviewArrow.hidden = YES;
            
            cell.lblTip.hidden = NO;
            cell.imgviewSearch.hidden = NO;
            
            NSString *strTip = locatizedString(@"company_search");
            cell.lblTip.text = strTip;
            cell.lblTip.textColor = [UIColor lightGrayColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        else
        {
            cell.imgviewPic.hidden = YES;
            cell.viewAdd.hidden = YES;
            cell.lblContent.hidden = YES;
            cell.imgviewArrow.hidden = YES;
            
            cell.lblTip.hidden = NO;
            cell.imgviewSearch.hidden = YES;
            
            cell.lblTip.text = @"您还未加入任何公司，请立即申请加入吧";
            cell.lblTip.textColor = [UIColor colorWithRed:(CGFloat)247/255 green:(CGFloat)107/255 blue:(CGFloat)0/255 alpha:1];
            
            NSString *strTip = locatizedString(@"no_company");
            cell.lblTip.text = strTip;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BOOL jumpFlag = NO;
    
//    if (self.hasCompany == YES)
//    {
//        if (indexPath.section == 0)
//        {
//            jumpFlag = YES;
//        }
//    }
//    else
//    {
//        jumpFlag = YES;
//    }
    
    if (indexPath.section == 0)
    {
        jumpFlag = YES;
    }
    
    if (jumpFlag == YES)
    {
        SearchCompanyViewController *searchVC = [[SearchCompanyViewController alloc] initWithNibName:@"SearchCompanyViewController" bundle:nil];
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}


@end
