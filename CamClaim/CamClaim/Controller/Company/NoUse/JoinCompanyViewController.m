//
//  JoinCompanyViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/19.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "JoinCompanyViewController.h"
#import "CompanyModel.h"

@interface JoinCompanyViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;
@property (nonatomic, strong) IBOutlet UIView *viewBg;
@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) IBOutlet UITextField *textfieldEmail;
@property (nonatomic, strong) IBOutlet UITextField *textfieldPhone;
@property (nonatomic, strong) IBOutlet UITextField *textfieldCompany;
@property (nonatomic, strong) IBOutlet UITextField *textfieldUserNumber;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence_;

//
@property (nonatomic, strong) IBOutlet UIView *viewClaimPicker;
@property (nonatomic, strong) IBOutlet UIPickerView *claimPicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel_;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone_;

@property (nonatomic, strong) NSMutableArray *arrayUserCompany;
@property (nonatomic, copy) NSString *companyid;
@property (nonatomic, copy) NSString *strPick;

- (IBAction)btnTouchAction:(id)sender;

- (IBAction)cancelPopViewForClaim;
- (IBAction)donePopViewForClaim;

@end

@implementation JoinCompanyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"加入公司";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 提交
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:@"Save" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [self initView];
    
    [self getAllCompany:NO];
}

- (void)initView
{
    self.textfieldEmail.returnKeyType = UIReturnKeyNext;
    self.textfieldPhone.returnKeyType = UIReturnKeyNext;
    self.textfieldUserNumber.returnKeyType = UIReturnKeyDone;
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, 286);
    self.viewBg.backgroundColor = [UIColor whiteColor];
    
    self.viewTranslucence_ = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.viewTranslucence_.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tapGesture_ = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopViewForClaim)];
    [self.viewTranslucence_ addGestureRecognizer:tapGesture_];
    
    CGRect myRect = self.viewClaimPicker.bounds;
    myRect.origin.x = 0;
    myRect.origin.y = CGRectGetHeight(self.viewTranslucence_.frame) - myRect.size.height;
    self.viewClaimPicker.frame = CGRectMake(myRect.origin.x, myRect.origin.y, kScreenWidth, myRect.size.height);
    [self.viewTranslucence_ addSubview:self.viewClaimPicker];
    
    self.claimPicker.delegate = self;
    self.claimPicker.dataSource = self;
    [self.claimPicker reloadAllComponents];
    
    // 显示已完善的信息
    UserManager *userManager = [UserManager sharedInstance];
    if (userManager.userInfo.email != nil && userManager.userInfo.email.length > 0)
    {
        self.textfieldEmail.text = userManager.userInfo.email;
    }
    if (userManager.userInfo.phone != nil && userManager.userInfo.phone.length > 0)
    {
        self.textfieldPhone.text = userManager.userInfo.phone;
    }
}

- (NSMutableArray *)arrayUserCompany
{
    if (_arrayUserCompany == nil)
    {
        _arrayUserCompany = [[NSMutableArray alloc] init];
    }
    
    return _arrayUserCompany;
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

// 保存
- (void)moreAction
{
    int status = [self checkContent];
    if (status != 0)
    {
        switch (status) {
            case 1:
                [self toast:@"邮箱不能为空"];
                break;
            case 2:
                [self toast:@"手机号不能为空"];
                break;
            case 3:
                [self toast:@"公司不能为空"];
                break;
            case 4:
                [self toast:@"邮箱地址非法"];
                break;
            case 5:
                [self toast:@"员工号不能为空"];
                break;
            default:
                break;
        }
        
        return;
    }
    
    [self hideKeyboard];
    
    [self joinCompany];
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

- (IBAction)btnTouchAction:(id)sender
{
    [self hideKeyboard];
    
    if (self.arrayUserCompany != nil && self.arrayUserCompany.count > 0)
    {
        [self showClaimPicker];
    }
    else
    {
        [self getAllCompany:YES];
    }
}

- (IBAction)cancelPopViewForClaim
{
    [self hidePopViewForClaim];
}

- (IBAction)donePopViewForClaim
{
    NSInteger index = [self.claimPicker selectedRowInComponent:0];
    CompanyModel *company = self.arrayUserCompany[index];
    self.strPick = company.companyinfo;
    self.companyid = company.id;
    
    self.textfieldCompany.text = self.strPick;
    //self.strPick = nil;
    
    [self hidePopViewForClaim];
}


#pragma mark - Custom

- (void)hidePopViewForClaim
{
    [self.viewTranslucence_ removeFromSuperview];
}

- (void)showClaimPicker
{
    [self.claimPicker reloadAllComponents];
    [self.claimPicker selectRow:0 inComponent:0 animated:YES];
    [self.view addSubview:self.viewTranslucence_];
}

// 0-合法 1-邮箱为空 2-手机号为空 3-公司为空 4-邮箱地址非法 5-员工号为空
- (int)checkContent
{
    if ([NSString checkContent:self.textfieldEmail.text] == NO)
    {
        return 1;
    }
    
    if ([NSString checkContent:self.textfieldPhone.text] == NO)
    {
        return 2;
    }
    
    if ([NSString checkContent:self.textfieldCompany.text] == NO)
    {
        return 3;
    }
    
    if ([NSString checkMailAddress:self.textfieldEmail.text] == NO)
    {
        return 4;
    }
    
    if ([NSString checkContent:self.textfieldUserNumber.text] == NO)
    {
        return 5;
    }
    
    return 0;
}


#pragma mark - HttpRequest

- (void)getAllCompany:(BOOL)showLoading
{
    if (showLoading == YES)
    {
        UserManager *userManager = [UserManager sharedInstance];
        if (userManager.arrayCompany != nil)
        {
            [self.arrayUserCompany removeAllObjects];
            self.arrayUserCompany = userManager.arrayCompany;
            
            if (self.arrayUserCompany.count == 0)
            {
                [self toast:@"暂无公司,请添加"];
            }
            return;
        }
    }
    
    if (showLoading == YES)
    {
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    [InterfaceManager getUserCompany:^(BOOL isSucceed, NSString *message, id data) {
        
        if (showLoading == YES)
        {
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        }
        
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
                        [self.arrayUserCompany removeAllObjects];
                        
                        for (NSDictionary *dic in array)
                        {
                            NSError *error;
                            CompanyModel *item = [[CompanyModel alloc] initWithDictionary:dic error:&error];
                            if (item != nil)
                            {
                                [self.arrayUserCompany addObject:item];
                            }
                        }   // for
                        
                        NSLog(@"arrayUserCompany:%@", self.arrayUserCompany);
                        
                        // 保存用户发票类型
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [NSMutableArray arrayWithArray:self.arrayUserCompany];
                        
                        if (showLoading == YES)
                        {
                            [self showClaimPicker];
                        }
                    }
                    else
                    {
                        // 无发票类型数据
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.arrayCompany = [[NSMutableArray alloc] init];
                        
                        if (showLoading == YES)
                        {
                            [self toast:@"暂无公司,请添加"];
                        }
                    }
                }
                else
                {
                    NSLog(@"获取失败");
                    //[self toast:@"获取失败"];
                    
                    if (showLoading == YES)
                    {
                        [self toast:@"获取失败"];
                    }
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
                //[self toast:message];
                
                if (showLoading == YES)
                {
                    [self toast:message];
                }
            }
            else
            {
                //[self toast:@"获取失败"];
                
                if (showLoading == YES)
                {
                    [self toast:@"获取失败"];
                }
            }
        }
        
    }];
}

- (void)joinCompany
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager userJoinCompany:self.companyid withEmail:self.textfieldEmail.text andphone:self.textfieldPhone.text andUserNumber:self.textfieldUserNumber.text completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":1,"message":"joing公司成功","data":null,"total":0}
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"加入公司成功");
                    [self toast:@"加入公司成功"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    NSLog(@"加入公司失败");
                    [self toast:@"加入公司失败"];
                }
            }
            else
            {
                // 无数据
                NSLog(@"加入公司失败");
                [self toast:@"加入公司失败"];
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
                [self toast:@"加入公司失败"];
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
    //return self.arrayClaim.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"cellRecord";
//    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil)
//    {
//        cell = [RecordCell cellFromNib];
//    }
//
//    ClaimItem *item = self.arrayClaim[indexPath.row];
//    [cell configWithData:item];
//
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textfieldEmail)
    {
        [self.textfieldEmail resignFirstResponder];
        [self.textfieldPhone becomeFirstResponder];
    }
    else if (textField == self.textfieldPhone)
    {
        [self.textfieldPhone resignFirstResponder];
        [self.textfieldUserNumber becomeFirstResponder];
    }
    else if (textField == self.textfieldUserNumber)
    {
        [self.textfieldUserNumber resignFirstResponder];
    }
    
    return YES;
}


#pragma mark - UIPickerViewDelegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrayUserCompany.count;
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 46;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CompanyModel *company = self.arrayUserCompany[row];
    return company.companyinfo;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    CompanyModel *company = self.arrayUserCompany[row];
//    self.strPick = company.companyinfo;
//    self.companyid = company.id;
}


@end
