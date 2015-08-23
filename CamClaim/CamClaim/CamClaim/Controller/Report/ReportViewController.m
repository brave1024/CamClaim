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

@interface ReportViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UIView *viewTableFoot;

@property (nonatomic, strong) IBOutlet UIView *viewTableHead;
@property (nonatomic, strong) IBOutlet UIView *viewSectionHead;

@property (nonatomic, weak) IBOutlet UILabel *lblExpenditure;   // 报销金额
@property (nonatomic, weak) IBOutlet UILabel *lblIncome;        // 回款金额
@property (nonatomic, weak) IBOutlet UILabel *lblBalance;       // 结余金额

@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblMonth;
@property (nonatomic, strong) IBOutlet UILabel *lblYear;

@property (nonatomic, strong) NSMutableArray *arrayClaim;
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

@property (nonatomic, strong) IBOutlet UIView *viewMonth;

@property (nonatomic, copy) NSString *strDate;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence;

//
@property (nonatomic, strong) IBOutlet UIView *viewPicker;
@property (nonatomic, strong) IBOutlet UIPickerView *datePicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone;

@property (nonatomic, strong) NSMutableArray *arrayYear;
@property (nonatomic, strong) NSMutableArray *arrayMonth;
@property NSInteger currentMonth;

- (IBAction)selectDateForReport:(id)sender;
- (IBAction)dismissDatePickerView:(id)sender;

@end


@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"月报表";
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    self.viewSectionHead.backgroundColor = [UIColor colorWithRed:(CGFloat)95/255 green:(CGFloat)178/255 blue:(CGFloat)255/255 alpha:1];
    
    [self initView];
    
    [self initPopViewForMonth];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    // 请求数据
    [self requestReportList];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    self.viewTableHead.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    self.tableview.tableHeaderView = self.viewTableHead;
    //self.tableview.tableFooterView = self.viewTableFoot;
    
    self.viewSectionHead.backgroundColor = [UIColor colorWithRed:(CGFloat)36/255 green:(CGFloat)101/255 blue:(CGFloat)194/255 alpha:1];
    [self.tableview reloadData];
    
    self.lblDate.text = self.strDate;
    self.lblMonth.text = [self getCurrentMonth];
    self.lblYear.text = [self getCurrentYear];
    
    self.lblExpenditure.text = @"--";
    self.lblIncome.text = @"--";
    self.lblBalance.text = @"--";
    
    self.lblDate.textColor = [UIColor blackColor];
    self.lblMonth.textColor = [UIColor colorWithRed:(CGFloat)42/255 green:(CGFloat)184/255 blue:(CGFloat)252/255 alpha:1];
    self.lblYear.textColor = [UIColor colorWithRed:(CGFloat)42/255 green:(CGFloat)184/255 blue:(CGFloat)252/255 alpha:1];
    
//    UIImage *img = [UIImage imageNamed:@"img_input"];
//    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
//    self.imgviewMonth.image = img;
    
    self.viewMonth.backgroundColor = [UIColor whiteColor];
    self.viewMonth.layer.cornerRadius = 4;
    self.viewMonth.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.viewMonth.layer.borderWidth = 0.5;
}

- (void)initPopViewForMonth
{
    UITapGestureRecognizer *tapGestureForMonth = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPopViewForDate)];
    [self.viewMonth addGestureRecognizer:tapGestureForMonth];
    
    // 初始化日期选择视图
    self.viewTranslucence = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    self.viewTranslucence.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopViewForDate)];
    [self.viewTranslucence addGestureRecognizer:tapGesture];
    
    CGRect myRect = self.viewPicker.bounds;
    myRect.origin.x = 0;
    myRect.origin.y = CGRectGetHeight(self.viewTranslucence.frame) - myRect.size.height;
    self.viewPicker.frame = CGRectMake(myRect.origin.x, myRect.origin.y, kScreenWidth, myRect.size.height);
    [self.viewTranslucence addSubview:self.viewPicker];
    
    // Month Array for picker view
    //self.arrayMonth = [[NSMutableArray alloc]initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    self.arrayMonth = [[NSMutableArray alloc]initWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM"];
    NSString *monthString = [formatter stringFromDate:[NSDate date]];
    NSInteger month = [monthString integerValue];
    self.currentMonth = month;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString *yearString = [formatter stringFromDate:[NSDate date]];
    NSInteger year = [yearString integerValue];
    
    // Year Array for picker view
    self.arrayYear = [[NSMutableArray alloc] init];
    for (int i=0; i<10; i++)
    {
        [self.arrayYear addObject:[NSString stringWithFormat:@"%ld", year-i]];
    }
    
    self.datePicker.delegate = self;
    self.datePicker.showsSelectionIndicator = YES;
    [self.datePicker selectRow:0 inComponent:0 animated:YES];
    [self.datePicker selectRow:month-1 inComponent:1 animated:YES];
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


#pragma mark - GetDate

- (NSString *)strDate
{
    if (_strDate == nil)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
        //[formatter setDateFormat:@"YYYY.MM.dd hh.mm.ss"];
        //[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        [formatter setDateFormat:@"YYYY/MM"];
        _strDate = [formatter stringFromDate:[NSDate date]];
    }
    
    return _strDate;
}

- (NSString *)getCurrentYear
{
    if (self.strDate != nil && self.strDate.length > 0)
    {
        NSArray *arrayDate = [self.strDate componentsSeparatedByString:@"/"];
        if (arrayDate != nil && arrayDate.count == 2)
        {
            return arrayDate[0];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}

- (NSString *)getCurrentMonth
{
    if (self.strDate != nil && self.strDate.length > 0)
    {
        NSArray *arrayDate = [self.strDate componentsSeparatedByString:@"/"];
        if (arrayDate != nil && arrayDate.count == 2)
        {
            return arrayDate[1];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return nil;
    }
}


#pragma mark -

- (IBAction)selectDateForReport:(id)sender
{
    NSInteger indexYear = [self.datePicker selectedRowInComponent:0];
    NSInteger indexMonth = [self.datePicker selectedRowInComponent:1];
    
    NSString *selectedMonth = [NSString stringWithFormat:@"%@/%@", self.arrayYear[indexYear], self.arrayMonth[indexMonth]];
    
    self.lblDate.text = selectedMonth;
    self.lblMonth.text = [NSString stringWithFormat:@"%@", self.arrayMonth[indexMonth]];
    self.lblYear.text = [NSString stringWithFormat:@"%@", self.arrayYear[indexYear]];
    
    NSLog(@"用户选择的年月:%@, 之前选择的年月:%@", selectedMonth, self.strDate);
    
    if ([self.strDate isEqualToString:selectedMonth] == YES)
    {
        // 年月未改变,不需要重复请求数据
        NSLog(@"年月未改变,不需要重复请求数据");
        self.strDate = [NSString stringWithString:selectedMonth];
    }
    else
    {
        // 请求数据
        NSLog(@"请求数据");
        self.strDate = [NSString stringWithString:selectedMonth];
        
        [self requestReportList];
    }
    
    [self.viewTranslucence removeFromSuperview];
}

- (IBAction)dismissDatePickerView:(id)sender
{
    [self.viewTranslucence removeFromSuperview];
}

- (void)hidePopViewForDate
{
    [self.viewTranslucence removeFromSuperview];
}

- (void)showPopViewForDate
{
    [self.view addSubview:self.viewTranslucence];
}


#pragma mark - UIPickerViewDelegate

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.arrayYear.count;
    }
    else
    {
        return self.arrayMonth.count;
    }
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return kScreenWidth / 2;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.arrayYear[row];
    }
    else
    {
        return self.arrayMonth[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView selectedRowInComponent:0] == 0)
    {
        // 用户选中今年
        
        NSInteger selectedMonth = [pickerView selectedRowInComponent:1];
        if (selectedMonth > self.currentMonth-1)
        {
            [pickerView selectRow:self.currentMonth-1 inComponent:1 animated:YES];
        }
        else
        {
            // 小于等于当月
        }
    }
}


#pragma mark - Request

- (void)requestReportList
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    NSString *strYear = [self getCurrentYear];
    NSString *strMonth = [self getCurrentMonth];
    NSString *month = [NSString stringWithFormat:@"%@/%@", strYear, strMonth];
    
    // Test
    //month = @"2015/07";
    
    [InterfaceManager getUserReportByMonth:month completion:^(BOOL isSucceed, NSString *message, id data) {
        
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
                        NSLog(@"暂无月报表数据");
                        [self toast:@"暂无月报表数据"];
                        
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
                    NSLog(@"暂无月报表数据");
                    [self toast:@"暂无月报表数据"];
                    
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
                NSLog(@"暂无月报表数据");
                [self toast:@"暂无月报表数据"];
                
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
                [self toast:@"获取月报表数据失败"];
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
