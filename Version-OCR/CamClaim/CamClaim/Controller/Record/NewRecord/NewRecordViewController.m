//
//  NewRecordViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "NewRecordViewController.h"
#import "ClaimTypeCell.h"
#import "TrafficTypeViewController.h"
#import "FoodTypeViewController.h"
#import "HotelTypeViewController.h"
#import "OtherTypeViewController.h"

@interface NewRecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayList;

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;

@end

@implementation NewRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navView.lblTitle.text = @"記錄選項";
//    self.navView.lblTitle.hidden = NO;
//    self.navView.imgLogo.hidden = YES;
    
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    
    // 当前导航栏左侧图标替换
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    self.tableview.tableHeaderView = self.viewTableHeader;
    
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
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"RecordType" ofType:@"plist"];
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
    return 20.0;
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
    return self.arrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellType";
    ClaimTypeCell *cell = (ClaimTypeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [ClaimTypeCell cellFromNib];
    }

    NSDictionary *dic = self.arrayList[indexPath.row];
    [cell configWithData:dic];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // item
    NSDictionary *dic = self.arrayList[indexPath.row];
    NSString *type = dic[@"type"];
    int typeFlag = [type intValue];
    if (typeFlag == 0)
    {
        // 交通
        TrafficTypeViewController *trafficVC = [[TrafficTypeViewController alloc] initWithNibName:@"TrafficTypeViewController" bundle:nil];
        [self.navigationController pushViewController:trafficVC animated:YES];
    }
    else if (typeFlag == 1)
    {
        // 膳食
        FoodTypeViewController *foodVC = [[FoodTypeViewController alloc] initWithNibName:@"FoodTypeViewController" bundle:nil];
        [self.navigationController pushViewController:foodVC animated:YES];
    }
    else if (typeFlag == 2)
    {
        // 住宿
        HotelTypeViewController *hotelVC = [[HotelTypeViewController alloc] initWithNibName:@"HotelTypeViewController" bundle:nil];
        [self.navigationController pushViewController:hotelVC animated:YES];
    }
    else
    {
        // 其它:礼物、工具、文仪用品、杂项申报
        OtherTypeViewController *otherVC = [[OtherTypeViewController alloc] initWithNibName:@"OtherTypeViewController" bundle:nil];
        otherVC.recordType = typeFlag;
        [self.navigationController pushViewController:otherVC animated:YES];
    }
}


@end
