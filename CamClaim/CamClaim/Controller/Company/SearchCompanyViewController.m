//
//  SearchCompanyViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/10/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "SearchCompanyViewController.h"
#import "CompanyCell.h"
#import "CompanyModel.h"
#import "JoinCompanyViewController.h"
#import "InviteCompanyViewController.h"

@interface SearchCompanyViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayData;

@property (nonatomic, weak) IBOutlet UIView *viewNoResult;

@property (nonatomic, weak) IBOutlet UILabel *lblResult;

// 半透明遮罩
@property (nonatomic, weak) IBOutlet UIView *viewTranslucence;

@end

@implementation SearchCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"Add New";
    
    NSString *strValue = locatizedString(@"company_search_title");
    self.navView.lblTitle.text = strValue;
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self initData];
    
    [self settingLanguage];
    
}

- (void)initView
{
    self.viewTranslucence.hidden = YES;
    self.viewTranslucence.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSearchBar)];
    [self.viewTranslucence addGestureRecognizer:tapGesture];
    
    [self.searchBar becomeFirstResponder];
    
    self.viewNoResult.hidden = YES;
}

- (void)initData
{
    
    
}

- (NSMutableArray *)arrayData
{
    if (_arrayData == nil)
    {
        _arrayData = [[NSMutableArray alloc] init];
        
        // Test
        //[_arrayData addObjectsFromArray:@[@"Cookov", @"Apple", @"Google", @"Microsoft", @"Tencent", @"Alibaba", @"Baidu"]];
    }
    return _arrayData;
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
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *strValue = locatizedString(@"company_no_result");
    self.lblResult.text = strValue;
}


#pragma mark - Custom

- (void)dismissSearchBar
{
    [self.searchBar resignFirstResponder];
    self.viewTranslucence.hidden = YES;
}


#pragma mark - HttpRequest

// 获取所有公司...
- (void)requestForSearchCompany
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager searchCompany:self.searchBar.text completion:^(BOOL isSucceed, NSString *message, id data) {
        
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
                        
                        [self.arrayData removeAllObjects];
                        
                        for (NSDictionary *dic in array)
                        {
                            NSError *error;
                            CompanyModel *item = [[CompanyModel alloc] initWithDictionary:dic error:&error];
                            if (item != nil)
                            {
                                [self.arrayData addObject:item];
                            }
                        }   // for
                        
                        NSLog(@"arrayCompany:%@", self.arrayData);
                        
                        if (self.arrayData.count > 0)
                        {
                            self.viewNoResult.hidden = YES;
                        }
                        else
                        {
                            self.viewNoResult.hidden = NO;
                        }
                        
                        [self.tableview reloadData];
                    }
                    else
                    {
                        // 无加入的公司
                        
                        //[self toast:@"未搜索到相关的公司"];
                        self.viewNoResult.hidden = NO;
                        [self.arrayData removeAllObjects];
                        [self.tableview reloadData];
                        
                        NSString *strTitle = locatizedString(@"company_no_result_title");
                        NSString *strTip = locatizedString(@"company_join_title");
                        NSString *strCancel = locatizedString(@"cancel");
                        NSString *strDone = locatizedString(@"done");
                        
                        //
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strTip delegate:self cancelButtonTitle:strCancel otherButtonTitles:strDone, nil];
                        [alert show];
                        
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有找到您的公司" message:@"立刻邀请您的公司入驻CamClaim，将得到$1000佣金" delegate:self cancelButtonTitle:strCancel otherButtonTitles:strDone, nil];
//                        [alert show];
                    }
                }
                else
                {
                    NSLog(@"获取失败");
                    //[self toast:@"搜索公司失败"];
                    
                    NSString *strTip = locatizedString(@"company_search_fail");
                    [self toast:strTip];
                }
            }
            else
            {
                // 无公司数据
                //[self toast:@"未搜索到相关的公司"];
                self.viewNoResult.hidden = NO;
                [self.arrayData removeAllObjects];
                [self.tableview reloadData];
                
                NSString *strTitle = locatizedString(@"company_no_result_title");
                NSString *strTip = locatizedString(@"company_join_title");
                NSString *strCancel = locatizedString(@"cancel");
                NSString *strDone = locatizedString(@"done");
                
                //
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strTip delegate:self cancelButtonTitle:strCancel otherButtonTitles:strDone, nil];
                [alert show];
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有找到您的公司" message:@"立刻邀请您的公司入驻CamClaim，将得到$1000佣金" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//                [alert show];
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
                //[self toast:@"搜索公司失败"];
                
                NSString *strTip = locatizedString(@"company_search_fail");
                [self toast:strTip];
            }
        }
        
    }];
}

- (void)requestForJoinCompany:(CompanyModel *)item
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager userJoinCompany:item.id completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"加入公司请求成功");
                    
                    // {"status":1,"message":"joing公司成功","data":null,"total":0}
                    
                    //[self toast:@"加入公司请求成功"];
                    
                    NSString *strTip = locatizedString(@"company_request_success");
                    [self toast:strTip];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"加入公司请求失败");
                    //[self toast:@"加入公司请求失败"];
                    
                    NSString *strTip = locatizedString(@"company_request_fail");
                    [self toast:strTip];
                }
            }
            else
            {
                NSLog(@"加入公司请求失败");
                //[self toast:@"加入公司请求失败"];
                
                NSString *strTip = locatizedString(@"company_request_fail");
                [self toast:strTip];
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
                //[self toast:@"加入公司请求失败"];
                
                NSString *strTip = locatizedString(@"company_request_fail");
                [self toast:strTip];
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
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
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
    return self.arrayData.count;
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
    
    CompanyModel *item = self.arrayData[indexPath.row];
    [cell configWithData:item];
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"是否加入该公司" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.tag = indexPath.row;
//    [alert show];
    
    //[self requestForJoinCompany];

    CompanyModel *item = self.arrayData[indexPath.row];
    if (item.companyinfo != nil && item.companyinfo.length > 0)
    {
        JoinCompanyViewController *joinVC = [[JoinCompanyViewController alloc] initWithNibName:@"JoinCompanyViewController" bundle:nil];
        joinVC.company = item;
        [self.navigationController pushViewController:joinVC animated:YES];
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissSearchBar];
    
    // search
    [self requestForSearchCompany];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.viewTranslucence.hidden = NO;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    
    
    return YES;
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //
    }
    else
    {
        InviteCompanyViewController *inviteVC = [[InviteCompanyViewController alloc] initWithNibName:@"InviteCompanyViewController" bundle:nil];
        [self.navigationController pushViewController:inviteVC animated:YES];
    }
}


@end
