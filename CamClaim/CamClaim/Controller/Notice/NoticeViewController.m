//
//  NoticeViewController.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"
#import "InviteCell.h"
#import "NoticeDetailViewController.h"
#import "NoticeInviteModel.h"

@interface NoticeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayNotice;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navView.lblTitle.hidden = YES;
//    self.navView.imgLogo.hidden = NO;
//    
//    // 当前导航栏左侧图标替换
//    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    if (self.fromMainPage == YES)
    {
        // 从首界面跳转过来
        //self.navView.lblTitle.text = @"Message";
        
        NSString *strValue = locatizedString(@"message");
        self.navView.lblTitle.text = strValue;
        
        self.navView.lblTitle.hidden = NO;
        self.navView.imgLogo.hidden = YES;
    }
    else
    {
        self.navView.lblTitle.hidden = YES;
        self.navView.imgLogo.hidden = NO;
        
        // 当前导航栏左侧图标替换
        [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    }
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [self setupRefreshForTableview];
    
    // 发请求
    [self requestNoticeList];
}

- (void)initView
{
    
}

- (NSMutableArray *)arrayNotice
{
    if (_arrayNotice == nil)
    {
        _arrayNotice = [[NSMutableArray alloc] init];
    }
    return _arrayNotice;
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
//    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
//        // 点击按钮隐藏菜单栏后的动画
//        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
//            
//        }];
//    }];
    
    if (self.fromMainPage == YES)
    {
        // 从首界面跳转过来
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
            // 点击按钮隐藏菜单栏后的动画
            [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
                
            }];
        }];
    }
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
    [self requestNoticeList];
}


#pragma mark - Request

- (void)requestNoticeList
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager getUserInviteRecord:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取资讯信息成功");
                    
                    [self.arrayNotice removeAllObjects];
                    
                    NSArray *arrayData = response.data;
                    for (NSDictionary *dic in arrayData)
                    {
                        NSError *error = nil;
                        NoticeInviteModel *item = [[NoticeInviteModel alloc] initWithDictionary:dic error:&error];
                        if (item != nil && error == nil)
                        {
                            [self.arrayNotice addObject:item];
                        }
                    }
                    
                    if (self.arrayNotice.count > 0)
                    {
                        // 显示
                        [self.tableview reloadData];
                    }
                    else
                    {
                        NSLog(@"暂无消息记录");
                        //[self toast:@"暂无消息记录"];
                        
                        NSString *strTip = locatizedString(@"noData");
                        [self toast:strTip];
                        
                        [self.arrayNotice removeAllObjects];
                        [self.tableview reloadData];
                    }
                }
                else
                {
                    NSLog(@"暂无消息记录");
                    //[self toast:@"暂无消息记录"];
                    
                    NSString *strTip = locatizedString(@"noData");
                    [self toast:strTip];
                    
                    [self.arrayNotice removeAllObjects];
                    [self.tableview reloadData];
                }
            }
            else
            {
                NSLog(@"暂无消息记录");
                //[self toast:@"暂无消息记录"];
                
                NSString *strTip = locatizedString(@"noData");
                [self toast:strTip];
                
                [self.arrayNotice removeAllObjects];
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
                //[self toast:@"获取消息记录失败"];
                
                NSString *strTip = locatizedString(@"loadFail");
                [self toast:strTip];
            }
            
            [self.arrayNotice removeAllObjects];
            [self.tableview reloadData];
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
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayNotice.count;
    //return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 62.0f;
    return 76.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"noticeCell";
//    NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil)
//    {
//        cell = [NoticeCell cellFromNib];
//    }
//    
//    NSDictionary *dic = [[NSDictionary alloc] init];
//    [cell configWithData:dic];
    
    InviteCell *cell = (InviteCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [InviteCell cellFromNib];
    }
    
    NoticeInviteModel *item = self.arrayNotice[indexPath.row];
    [cell configWithData:item];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
//    NoticeDetailViewController *detailVC = [[NoticeDetailViewController alloc] initWithNibName:@"NoticeDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
