//
//  CompanyViewController.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CompanyViewController.h"
#import "CompanyCell.h"
#import "CompanyDetailViewController.h"
#import "CompanyModel.h"
#import "JoinCompanyViewController.h"

@interface CompanyViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
//@property (nonatomic, weak) IBOutlet UIView *viewTableFoot;
@property (nonatomic, strong) NSMutableArray *arrayCompany;

@property (nonatomic, weak) IBOutlet UIButton *btnJoin;

@property BOOL isEditing;

- (IBAction)joinCompanyAction;

@end

@implementation CompanyViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"公司";
    
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    
    // 编辑
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:@"Edit" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    // 当前导航栏左侧图标替换
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [self setupRefreshForTableview];
    
    [self initData];
    
    // 请求公司
    [self getAllCompany];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableview.editing = NO;
    self.isEditing = NO;
    
    [self.navView.btnMore setTitle:@"Edit" forState:UIControlStateNormal];
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

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    UIImage *imgBtn = [UIImage imageNamed:@"new_btn_capture"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
    [self.btnJoin setBackgroundImage:imgBtn forState:UIControlStateNormal];
    //[self.btnJoin setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnJoin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnJoin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

- (void)initData
{
    self.isEditing = NO;
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

- (void)moreAction
{
    if (self.isEditing == NO)
    {
        self.tableview.editing = YES;
        self.isEditing = YES;
        
        [self.navView.btnMore setTitle:@"Done" forState:UIControlStateNormal];
    }
    else
    {
        self.tableview.editing = NO;
        self.isEditing = NO;
        
        [self.navView.btnMore setTitle:@"Edit" forState:UIControlStateNormal];
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


#pragma mark - BtnTouchAction

- (IBAction)joinCompanyAction
{
    JoinCompanyViewController *joinVC = [[JoinCompanyViewController alloc] initWithNibName:@"JoinCompanyViewController" bundle:nil];
    [self.navigationController pushViewController:joinVC animated:YES];
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
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
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
                        
                        // 保存用户发票类型
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [NSMutableArray arrayWithArray:self.arrayCompany];
                        
                        [self.tableview reloadData];
                    }
                    else
                    {
                        // 无发票类型数据
                        
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [[NSMutableArray alloc] init];
                        
                        [self toast:@"暂无公司,请添加"];
                        [self.tableview reloadData];
                    }
                }
                else
                {
                    NSLog(@"获取失败");
                    [self toast:@"获取失败"];
                }
            }
            else
            {
                // 无公司数据
                
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
                [self toast:@"获取失败"];
                
            }
        }
        
    }];
}

// 增加新公司
- (void)addNewCompany:(NSString *)name
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager addUserCompany:name completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":1,"message":"添加公司成功","data":null,"total":0}
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"添加公司成功");
                    [self toast:@"添加公司成功"];
                    
                    [self getAllCompany];
                }
                else
                {
                    NSLog(@"添加公司失败");
                    [self toast:@"添加公司失败"];
                }
            }
            else
            {
                // 无数据
                NSLog(@"添加公司失败");
                [self toast:@"添加公司失败"];
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
                [self toast:@"添加公司失败"];
            }
        }
        
    }];
}

// 删除新公司
- (void)deleteUserCompany:(NSString *)comid
{
    if (comid == nil)
    {
        return;
    }
    
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager deleteUserCompany:comid completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":1,"message":"更新成功","data":null,"total":0}
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"删除公司成功");
                    [self toast:@"删除公司成功"];
                    
                    [self getAllCompany];
                }
                else
                {
                    NSLog(@"删除公司失败");
                    [self toast:@"删除公司失败"];
                }
            }
            else
            {
                // 无数据
                NSLog(@"删除公司失败");
                [self toast:@"删除公司失败"];
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
                [self toast:@"删除公司失败"];
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
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCompany.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"companyCell";
    CompanyCell *cell = (CompanyCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [CompanyCell cellFromNib];
    }
    
    if (indexPath.row == self.arrayCompany.count)
    {
        cell.imgviewPic.hidden = YES;
        cell.viewAdd.hidden = NO;
        cell.lblContemt.text = @"Add New";
        cell.lblContemt.textColor = [UIColor darkGrayColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else
    {
        CompanyModel *item = self.arrayCompany[indexPath.row];
        [cell configWithData:item];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

// 设置可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return YES;
    
    if (indexPath.row == self.arrayCompany.count)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

// 更改删除按钮
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 88;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // 删除
        NSLog(@"删除");
        
        CompanyModel *item = self.arrayCompany[indexPath.row];
        [self deleteUserCompany:item.id];
    }
    else
    {
        //
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    CompanyDetailViewController *companyVC = [[CompanyDetailViewController alloc] initWithNibName:@"CompanyDetailViewController" bundle:nil];
//    
//    [self.navigationController pushViewController:companyVC animated:YES];
    
    if (indexPath.row == self.arrayCompany.count)
    {
        // 新增公司
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入公司名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        //alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tag = kTag;
        [alert show];
    }
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kTag)
    {
        // 新增公司
        
        UITextField *txtfield = [alertView textFieldAtIndex:0];
        LogDebug(@"companyt=%@", txtfield.text);
        
        if (buttonIndex == 1)
        {
            // 确定
            NSString *strContent = [txtfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (strContent != nil && strContent.length > 0)
            {
                // 请求
                [self addNewCompany:strContent];
            }
            else
            {
                [txtfield resignFirstResponder];
                [self toast:@"公司名不能为空"];
            }
        }
        else
        {
            // 取消
            [txtfield resignFirstResponder];
        }
    }
}


@end
