//
//  ReportViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/7.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportCell.h"
#import "ClaimList.h"

@interface ReportViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UIView *viewTableFoot;

@property (nonatomic, strong) IBOutlet UIView *viewTableHead;
@property (nonatomic, strong) IBOutlet UIView *viewSectionHead;

@property (nonatomic, weak) IBOutlet UILabel *lblExpenditure;   // 报销金额
@property (nonatomic, weak) IBOutlet UILabel *lblIncome;        // 回款金额
@property (nonatomic, weak) IBOutlet UILabel *lblBalance;       // 结余金额

@property (nonatomic, strong) IBOutlet UILabel *lblDate;

@property (nonatomic, strong) NSMutableArray *arrayClaim;
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

@end


@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    self.viewSectionHead.backgroundColor = [UIColor colorWithRed:(CGFloat)95/255 green:(CGFloat)178/255 blue:(CGFloat)255/255 alpha:1];
    
    self.navView.lblTitle.text = @"月报表";
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    self.tableview.tableHeaderView = self.viewTableHead;
    //self.tableview.tableFooterView = self.viewTableFoot;
    
    self.viewSectionHead.backgroundColor = [UIColor colorWithRed:(CGFloat)36/255 green:(CGFloat)101/255 blue:(CGFloat)194/255 alpha:1];
    [self.tableview reloadData];
    
    self.lblExpenditure.text = @"--";
    self.lblIncome.text = @"--";
    self.lblBalance.text = @"--";
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    // 请求数据
    [self requestReportList];
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


#pragma mark - Request

- (void)requestReportList
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    NSString *strMonth = [NSString stringWithFormat:@"%@/%@", @"2015", @"07"];
    
    [InterfaceManager getUserReportByMonth:strMonth completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);

                /*
                {
                    "data": [
                             {
                                 "canmoney": "0",
                                 "forusername": "lili",
                                 "gmoney": "0",
                                 "id": 0,
                                 "jd": null,
                                 "jiyu": "0",
                                 "location": "沙田",
                                 "message": null,
                                 "pfile": null,
                                 "status": null,
                                 "typeid": "餐飲費",
                                 "useinfo": "eat",
                                 "userid": 0,
                                 "usetime": "2015/07",
                                 "wd": null
                             },
                             {
                                 "canmoney": "0",
                                 "forusername": "lili",
                                 "gmoney": "0",
                                 "id": 0,
                                 "jd": null,
                                 "jiyu": "0",
                                 "location": "沙田",
                                 "message": null,
                                 "pfile": null,
                                 "status": null,
                                 "typeid": "餐飲費",
                                 "useinfo": "using eat",
                                 "userid": 0,
                                 "usetime": "2015/07",
                                 "wd": null
                             },
                             {
                                 "canmoney": "0",
                                 "forusername": "asdasd",
                                 "gmoney": "0",
                                 "id": 0,
                                 "jd": null,
                                 "jiyu": "0",
                                 "location": "dasda",
                                 "message": null,
                                 "pfile": null,
                                 "status": null,
                                 "typeid": "交通費",
                                 "useinfo": "dasdas",
                                 "userid": 0,
                                 "usetime": "2015/07",
                                 "wd": null
                             },
                             {
                                 "canmoney": "0",
                                 "forusername": "",
                                 "gmoney": "0",
                                 "id": 0,
                                 "jd": null,
                                 "jiyu": "0",
                                 "location": "",
                                 "message": null,
                                 "pfile": null,
                                 "status": null,
                                 "typeid": "",
                                 "useinfo": "",
                                 "userid": 0,
                                 "usetime": "",
                                 "wd": null
                             }
                             ],
                    "message": "获取数据成功",
                    "status": 1,
                    "total": 0
                }
                */
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取月报表记录成功");
                    
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
                        
                        if (self.arrayClaim.count == 0)
                        {
                            // 未返回数据
                        }
                        else if (self.arrayClaim.count == 1)
                        {
                            // 只返回一条数据（无列表，只有总数）
                            
                            ClaimItem *item = [self.arrayClaim lastObject];
                            
                            if (item.canmoney != nil && item.canmoney.length > 0)
                            {
                                self.lblExpenditure.text = item.canmoney;
                            }
                            
                            if (item.gmoney != nil && item.gmoney.length > 0)
                            {
                                self.lblIncome.text = item.gmoney;
                            }
                            
                            if (item.jiyu != nil && item.jiyu.length > 0)
                            {
                                self.lblBalance.text = item.jiyu;
                            }
                        }
                        else
                        {
                            // 返回多条数据（列表与总数）
                            
                            ClaimItem *item = [self.arrayClaim lastObject];
                            
                            if (item.canmoney != nil && item.canmoney.length > 0)
                            {
                                self.lblExpenditure.text = item.canmoney;
                            }
                            
                            if (item.gmoney != nil && item.gmoney.length > 0)
                            {
                                self.lblIncome.text = item.gmoney;
                            }
                            
                            if (item.jiyu != nil && item.jiyu.length > 0)
                            {
                                self.lblBalance.text = item.jiyu;
                            }
                        }
                    }
                    else
                    {
                        NSLog(@"暂无报销数据");
                        //[self toast:@"暂无报销数据"];
                    }
                }
                else
                {
                    NSLog(@"暂无月报表记录数据");
                    //[self toast:@"暂无月报表记录数据"];
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
                //[self toast:@"获取月报表记录失败"];
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
    return 34.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.viewSectionHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.arrayClaim.count;
    
    if (self.arrayClaim.count == 0 || self.arrayClaim.count == 1)
    {
        return 0;
    }
    else
    {
        return self.arrayClaim.count - 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"reportCell";
    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [ReportCell cellFromNib];
    }

    ClaimItem *item = self.arrayClaim[indexPath.row];
    [cell configWithData:item];
    
    //
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
