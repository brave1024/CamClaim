//
//  RecordTypeViewController.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "RecordTypeViewController.h"
#import "RecordCell.h"
#import "ClaimList.h"

@interface RecordTypeViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayClaim;
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

@end

@implementation RecordTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"分类记录";
    
    self.navView.lblTitle.text = @"分类记录";
    
    if (self.claimType == typeClaimRecordPending)
    {
        self.navView.lblTitle.text = @"Pending";
    }
    else if (self.claimType == typeClaimRecordApproved)
    {
        self.navView.lblTitle.text = @"Approved";
    }
    else if (self.claimType == typeClaimRecordApproving)
    {
        self.navView.lblTitle.text = @"Approving";
    }
    else if (self.claimType == typeClaimRecordRejected)
    {
        self.navView.lblTitle.text = @"Rejected";
    }
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    self.navView.btnMore.hidden = YES;
    
    //self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [self setupRefreshForTableview];
    
    // 请求数据
    [self requestClaimList];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
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

// 返回
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//
- (void)moreAction
{
    //
    
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
    [self requestClaimList];
}


#pragma mark - Request

- (void)requestClaimList
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    // Test
    NSString *type = [NSString stringWithFormat:@"%ld", (long)self.claimType];
    
    [InterfaceManager getUserClaimByType:type completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取发票记录成功");
                    
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
                    
                    if (self.arrayClaim.count > 0)
                    {
                        // 显示
                        [self.tableview reloadData];
                    }
                    else
                    {
                        NSLog(@"暂无发票记录数据");
                        [self toast:@"暂无发票记录数据"];
                        
                        if (self.arrayClaim == nil)
                        {
                            self.arrayClaim = [[NSMutableArray alloc] init];
                        }
                        else
                        {
                            [self.arrayClaim removeAllObjects];
                        }
                        [self.tableview reloadData];
                    }
                }
                else
                {
                    NSLog(@"暂无发票记录数据");
                    [self toast:@"暂无发票记录数据"];
                    
                    if (self.arrayClaim == nil)
                    {
                        self.arrayClaim = [[NSMutableArray alloc] init];
                    }
                    else
                    {
                        [self.arrayClaim removeAllObjects];
                    }
                    [self.tableview reloadData];
                }
            }
            else
            {
                NSLog(@"暂无发票记录数据");
                [self toast:@"暂无发票记录数据"];
                
                if (self.arrayClaim == nil)
                {
                    self.arrayClaim = [[NSMutableArray alloc] init];
                }
                else
                {
                    [self.arrayClaim removeAllObjects];
                }
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
                [self toast:@"获取发票记录失败"];
            }
            
            if (self.arrayClaim == nil)
            {
                self.arrayClaim = [[NSMutableArray alloc] init];
            }
            else
            {
                [self.arrayClaim removeAllObjects];
            }
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
    return self.arrayClaim.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellRecord";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [RecordCell cellFromNib];
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


@end
