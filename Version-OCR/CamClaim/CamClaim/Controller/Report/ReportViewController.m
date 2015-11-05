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
#import "MainCell.h"
#import "SearchViewController.h"

@interface ReportViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, weak) IBOutlet UIView *viewDate;
@property (nonatomic, weak) IBOutlet UILabel *lblYear;
@property (nonatomic, weak) IBOutlet UILabel *lblMonth;
@property (nonatomic, weak) IBOutlet UILabel *lblNumber;
@property (nonatomic, weak) IBOutlet UILabel *lblTotal;

@property (nonatomic, weak) IBOutlet UIView *viewType;
@property (nonatomic, weak) IBOutlet UILabel *lblRejected;
@property (nonatomic, weak) IBOutlet UILabel *lblApproved;
@property (nonatomic, weak) IBOutlet UILabel *lblApproving;
@property (nonatomic, weak) IBOutlet UILabel *lblPending;

//@property (nonatomic, weak) IBOutlet UIView *viewTableFoot;
//
//@property (nonatomic, strong) IBOutlet UIView *viewTableHead;
//@property (nonatomic, strong) IBOutlet UIView *viewSectionHead;
//
//@property (nonatomic, weak) IBOutlet UILabel *lblExpenditure;   // 报销金额
//@property (nonatomic, weak) IBOutlet UILabel *lblIncome;        // 回款金额
//@property (nonatomic, weak) IBOutlet UILabel *lblBalance;       // 结余金额
//
//@property (nonatomic, strong) IBOutlet UILabel *lblDate;
//@property (nonatomic, strong) IBOutlet UILabel *lblMonth;   // 不显示
//@property (nonatomic, strong) IBOutlet UILabel *lblYear;    // 不显示

//@property (nonatomic, strong) IBOutlet UIView *viewMonth;

@property (nonatomic, strong) NSMutableArray *arrayClaim;
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

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

- (IBAction)selectMonth;
//- (IBAction)monthBefore;
//- (IBAction)monthAfter;

@end


@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"月报表";
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    // 搜索
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    //[self.navView.btnMore setTitle:@"搜索" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [self initView];
    
    [self initPopViewForMonth];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [self setupRefreshForTableview];
    
    // 请求数据
    //[self requestReportList:YES];
    
    // Temp
    [self requestUserRecentFiveClaim:YES];
    
    // 新增发票成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewClaimSuccess) name:kAddNewClaimSuccess object:nil];
}

- (void)initView
{
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    self.viewDate.backgroundColor = [UIColor colorWithRed:(CGFloat)26/255 green:(CGFloat)31/255 blue:(CGFloat)38/255 alpha:1];
    self.viewType.backgroundColor = [UIColor whiteColor];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
//    self.lblDate.text = self.strDate;
    self.lblMonth.text = [self getCurrentMonth];
    self.lblYear.text = [self getCurrentYear];
    
//    self.lblExpenditure.text = @"--";
//    self.lblIncome.text = @"--";
//    self.lblBalance.text = @"--";
}

- (void)initPopViewForMonth
{
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

// 搜索
- (void)moreAction
{
    SearchViewController * searchVC = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    [self.navigationController pushViewController:searchVC animated:YES];
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
    //[self requestReportList:YES];
    
    // Temp
    [self requestUserRecentFiveClaim:YES];
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


#pragma mark - BtnTouchAction

- (IBAction)selectDateForReport:(id)sender
{
    NSInteger indexYear = [self.datePicker selectedRowInComponent:0];
    NSInteger indexMonth = [self.datePicker selectedRowInComponent:1];
    
    NSString *selectedMonth = [NSString stringWithFormat:@"%@/%@", self.arrayYear[indexYear], self.arrayMonth[indexMonth]];
    
//    self.lblDate.text = selectedMonth;
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
        
        //[self requestReportList:YES];
        
        // Temp
        [self requestUserRecentFiveClaim:YES];
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

- (IBAction)selectMonth
{
    [self showPopViewForDate];
}

//- (IBAction)monthBefore
//{
//    NSString *strYear = [self getCurrentYear];
//    NSString *strMonth = [self getCurrentMonth];
//    
//    NSInteger year = [strYear integerValue];
//    NSInteger month = [strMonth integerValue];
//    
//    if (month == 1)
//    {
//        month = 12;
//        year--;
//    }
//    else
//    {
//        month--;
//    }
//    
//    if (month < 10)
//    {
//        strMonth = [NSString stringWithFormat:@"0%ld", (long)month];
//    }
//    else
//    {
//        strMonth = [NSString stringWithFormat:@"%ld", (long)month];
//    }
//    
//    strYear = [NSString stringWithFormat:@"%ld", (long)year];
//    
//    self.strDate = [NSString stringWithFormat:@"%@/%@", strYear, strMonth];
////    self.lblDate.text = self.strDate;
//    
//    //[self requestReportList:YES];
//    
//    // Temp
//    [self requestUserRecentFiveClaim:YES];
//}
//
//- (IBAction)monthAfter
//{
//    NSString *strYear = [self getCurrentYear];
//    NSString *strMonth = [self getCurrentMonth];
//    
//    NSInteger year = [strYear integerValue];
//    NSInteger month = [strMonth integerValue];
//    
//    if (month == 12)
//    {
//        month = 1;
//        year++;
//    }
//    else
//    {
//        month++;
//    }
//    
//    if (month < 10)
//    {
//        strMonth = [NSString stringWithFormat:@"0%ld", (long)month];
//    }
//    else
//    {
//        strMonth = [NSString stringWithFormat:@"%ld", (long)month];
//    }
//    
//    strYear = [NSString stringWithFormat:@"%ld", (long)year];
//    
//    // 获取当前年月
//    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
//    [formatter setDateFormat:@"YYYY/MM"];
//    NSString *strCurrent = [formatter stringFromDate:[NSDate date]];
//    
//    NSString *yearCurrent = nil;
//    NSString *monthCurrent = nil;
//    
//    NSArray *arrayDate = [strCurrent componentsSeparatedByString:@"/"];
//    if (arrayDate != nil && arrayDate.count == 2)
//    {
//        yearCurrent = arrayDate[0];
//        monthCurrent = arrayDate[1];
//    }
//    
//    // 进行判断
//    if (yearCurrent != nil && monthCurrent != nil)
//    {
//        NSInteger year_ = [yearCurrent integerValue];
//        NSInteger month_ = [monthCurrent integerValue];
//        
//        if (year >= year_ && month > month_)
//        {
//            return;
//        }
//    }
//    
//    self.strDate = [NSString stringWithFormat:@"%@/%@", strYear, strMonth];
////    self.lblDate.text = self.strDate;
//    
//    //[self requestReportList:YES];
//    
//    // Temp
//    [self requestUserRecentFiveClaim:YES];
//}


#pragma mark - Notification

- (void)addNewClaimSuccess
{
    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:NO];
    //[self requestReportList:NO];
    
    // Temp
    [self requestUserRecentFiveClaim:NO];
}


//#pragma mark - TapGesture
//
//- (IBAction)hideSearchBar
//{
//    self.viewSearch.hidden = YES;
//    [self.searchBar resignFirstResponder];
//    self.viewSearchHeight.constant = 0;
//}


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

- (void)requestReportList:(BOOL)showLoading
{
    if (showLoading == YES)
    {
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    NSString *strYear = [self getCurrentYear];
    NSString *strMonth = [self getCurrentMonth];
    NSString *month = [NSString stringWithFormat:@"%@/%@", strYear, strMonth];
    
    // Test
    //month = @"2015/07";
    
    [InterfaceManager getUserReportByMonth:month completion:^(BOOL isSucceed, NSString *message, id data) {
        
        if (showLoading == YES)
        {
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        }
        
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
                                //self.lblExpenditure.text = item.canmoney;
                            }
                            
                            if (item.gmoney != nil && item.gmoney.length > 0)
                            {
                                //self.lblIncome.text = item.gmoney;
                            }
                            
                            if (item.jiyu != nil && item.jiyu.length > 0)
                            {
                                //self.lblBalance.text = item.jiyu;
                            }
                        }
                        else
                        {
                            // 返回多条数据（列表与总数）
                            
                            ClaimItem *item = [self.arrayClaim lastObject];
                            
                            if (item.canmoney != nil && item.canmoney.length > 0)
                            {
                                //self.lblExpenditure.text = item.canmoney;
                            }
                            
                            if (item.gmoney != nil && item.gmoney.length > 0)
                            {
                                //self.lblIncome.text = item.gmoney;
                            }
                            
                            if (item.jiyu != nil && item.jiyu.length > 0)
                            {
                                //self.lblBalance.text = item.jiyu;
                            }
                        }
                    }
                    else
                    {
                        NSLog(@"暂无月报表数据");
                        //[self toast:@"暂无月报表数据"];
                        
                        if (showLoading == YES)
                        {
                            [self toast:@"暂无月报表数据"];
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
                }
                else
                {
                    NSLog(@"暂无月报表数据");
                    //[self toast:@"暂无月报表数据"];
                    
                    if (showLoading == YES)
                    {
                        [self toast:@"暂无月报表数据"];
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
            }
            else
            {
                NSLog(@"暂无月报表数据");
                //[self toast:@"暂无月报表数据"];
                
                if (showLoading == YES)
                {
                    [self toast:@"暂无月报表数据"];
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
                //[self toast:@"获取月报表数据失败"];
                
                if (showLoading == YES)
                {
                    [self toast:@"获取月报表数据失败"];
                }
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

// Temp...~!@
- (void)requestUserRecentFiveClaim:(BOOL)showloading
{
    LogTrace(@"requestUserRecentFiveClaim");
    
    if (showloading == YES)
    {
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    [InterfaceManager getUserNewFiveClaimList:^(BOOL isSucceed, NSString *message, id data) {
        
        if (showloading == YES)
        {
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        }
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                // {"status":0,"message":"获取失败","data":null,"total":0}
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取最近五项报销记录成功");
                    
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
                    
                    // Test
                    //[self.arrayClaim removeAllObjects];
                    
                    if (self.arrayClaim.count > 0)
                    {
                        // 显示
                        [self.tableview reloadData];
                    }
                    else
                    {
                        NSLog(@"暂无报销数据");
                        //[self toast:@"暂无报销数据"];
                        
                        if (showloading == YES)
                        {
                            [self toast:@"暂无报销数据"];
                        }
                    }
                }
                else
                {
                    NSLog(@"暂无报销数据");
                    //[self toast:@"暂无报销数据"];
                    
                    if (showloading == YES)
                    {
                        [self toast:@"暂无报销数据"];
                    }
                }
            }
        }
        else
        {
            if (message != nil && message.length > 0)
            {
                //[self toast:message];
                
                if (showloading == YES)
                {
                    [self toast:message];
                }
            }
            else
            {
                //[self toast:@"获取最近五项报销记录失败"];
                
                if (showloading == YES)
                {
                    [self toast:@"获取最近五项报销记录失败"];
                }
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

#warning TODO: Temp...~!@
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayClaim.count;
    
//    if (self.arrayClaim.count == 0 || self.arrayClaim.count == 1)
//    {
//        return 0;
//    }
//    else
//    {
//        return self.arrayClaim.count - 1;
//    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 52;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"reportCell";
//    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        cell = [ReportCell cellFromNib];
//    }
//
//    ClaimItem *item = self.arrayClaim[indexPath.row];
//    [cell configWithData:item];
//    
//    //
//    cell.backgroundColor = [UIColor whiteColor];
//    cell.contentView.backgroundColor = [UIColor whiteColor];
//    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}

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
    
    //
}


//#pragma mark - UISearchBarDelegate
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSLog(@"searchBarSearchButtonClicked");
//    
//    [self hideSearchBar];
//    
//    // 搜索
//    
//}


@end
