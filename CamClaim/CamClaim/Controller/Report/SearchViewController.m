//
//  SearchViewController.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/30.
//  Copyright © 2015年 kufa88. All rights reserved.
//

#import "SearchViewController.h"
#import "MainCell.h"
#import "ClaimList.h"
#import "TrafficDetailViewController.h"
#import "FoodDetailViewController.h"
#import "HotelDetailViewController.h"
#import "OtherDetailViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayClaim;

// 半透明遮罩
@property (nonatomic, weak) IBOutlet UIView *viewTranslucence;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"Search";
    
    NSString *strValue = locatizedString(@"search");
    self.navView.lblTitle.text = strValue;
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 保存
//    self.navView.btnMore.hidden = NO;
//    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
//    [self.navView.btnMore setTitle:@"Save" forState:UIControlStateNormal];
//    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];    
}

- (void)initView
{
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)236/255 blue:(CGFloat)236/255 alpha:1];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;

    self.viewTranslucence.hidden = YES;
    self.viewTranslucence.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSearchBar)];
    [self.viewTranslucence addGestureRecognizer:tapGesture];
    
    [self.searchBar becomeFirstResponder];
}

- (NSMutableArray *)arrayClaim
{
    if (_arrayClaim == nil)
    {
        _arrayClaim = [[NSMutableArray alloc] init];
    }
    return _arrayClaim;
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


#pragma mark - Custom

- (void)dismissSearchBar
{
    [self.searchBar resignFirstResponder];
    self.viewTranslucence.hidden = YES;
}


#pragma mark - HttpRequest

// 获取所有公司...
- (void)requestForSearchClaim
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager getUserReportByKey:self.searchBar.text completion:^(BOOL isSucceed, NSString *message, id data) {
        
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
                        // 有搜索到发票
                        
                        [self.arrayClaim removeAllObjects];
                        
                        for (NSDictionary *dic in array)
                        {
                            NSError *error = nil;
                            ClaimItem *item = [[ClaimItem alloc] initWithDictionary:dic error:&error];
                            if (item != nil && error == nil)
                            {
                                [self.arrayClaim addObject:item];
                            }
                        }   // for
                        
                        NSLog(@"arrayCompany:%@", self.arrayClaim);
                        
                        [self.tableview reloadData];
                    }
                    else
                    {
                        // 未搜索到发票
                        
                        NSLog(@"暂无发票数据");
                        //[self toast:@"暂无发票数据"];
                        
                        NSString *strTip = locatizedString(@"noData");
                        [self toast:strTip];

                        [self.arrayClaim removeAllObjects];
                        [self.tableview reloadData];
                    }
                }
                else
                {
                    // 未搜索到发票
                    
                    NSLog(@"暂无发票数据");
                    //[self toast:@"暂无发票数据"];
                    
                    NSString *strTip = locatizedString(@"noData");
                    [self toast:strTip];
                    
                    [self.arrayClaim removeAllObjects];
                    [self.tableview reloadData];
                }
            }
            else
            {
                // 未搜索到发票
                
                NSLog(@"暂无发票数据");
                //[self toast:@"暂无发票数据"];
                
                NSString *strTip = locatizedString(@"noData");
                [self toast:strTip];
                
                [self.arrayClaim removeAllObjects];
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
                //[self toast:@"暂无发票数据"];
                
                NSString *strTip = locatizedString(@"loadFail");
                [self toast:strTip];
            }
            
            [self.arrayClaim removeAllObjects];
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
    return nil;
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
    
    ClaimItem *item = self.arrayClaim[indexPath.row];
    if (item.typeid != nil && item.typeid.length > 0)
    {
        if ([item.typeid isEqualToString:@"交通"] == YES)
        {
            TrafficDetailViewController *trafficVC = [[TrafficDetailViewController alloc] initWithNibName:@"TrafficDetailViewController" bundle:nil];
            trafficVC.item = item;
            [self.navigationController pushViewController:trafficVC animated:YES];
        }
        else if ([item.typeid isEqualToString:@"膳食"] == YES)
        {
            FoodDetailViewController *foodVC = [[FoodDetailViewController alloc] initWithNibName:@"FoodDetailViewController" bundle:nil];
            foodVC.item = item;
            [self.navigationController pushViewController:foodVC animated:YES];
        }
        else if ([item.typeid isEqualToString:@"住宿"] == YES)
        {
            HotelDetailViewController *hotelVC = [[HotelDetailViewController alloc] initWithNibName:@"HotelDetailViewController" bundle:nil];
            hotelVC.item = item;
            [self.navigationController pushViewController:hotelVC animated:YES];
        }
        else
        {
            // 文儀用品、杂项开支、工具、禮物
            OtherDetailViewController *otherVC = [[OtherDetailViewController alloc] initWithNibName:@"OtherDetailViewController" bundle:nil];
            otherVC.item = item;
            [self.navigationController pushViewController:otherVC animated:YES];
        }
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissSearchBar];
    
    // search
    [self requestForSearchClaim];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.viewTranslucence.hidden = NO;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    
    
    return YES;
}


@end
