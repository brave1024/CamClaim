//
//  RecordViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/18.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordCell.h"
#import "ClaimList.h"
#import "SubmitClaimViewController.h"
#import "RecordAddViewController.h"
#import "NewRecordViewController.h"

@interface RecordViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
//@property (nonatomic, weak) IBOutlet UIButton *btnNew;
//@property (nonatomic, weak) IBOutlet UIButton *btnSearch;
@property (nonatomic, weak) IBOutlet UIButton *btnFill;

@property (nonatomic, weak) IBOutlet UIView *viewFunction;
@property (nonatomic, weak) IBOutlet UIView *viewFill;

@property (nonatomic, strong) NSMutableArray *arrayClaim;
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UILabel *lblMonth;
@property (nonatomic, strong) IBOutlet UILabel *lblYear;

@property (nonatomic, copy) NSString *strDate;

@property (nonatomic, strong) IBOutlet UIView *viewMonth;

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

// 隐藏底部新增发票按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomHeight;

- (IBAction)btnTouchAction:(id)sender;

- (IBAction)selectDateForReport:(id)sender;
- (IBAction)dismissDatePickerView:(id)sender;

@end

@implementation RecordViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"记录";
    
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    
    // 当前导航栏左侧图标替换
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    // 新增
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:@"New" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)237/255 blue:(CGFloat)239/255 alpha:1];

    [self initView];
    
    // 初始化年月选择视图
    [self initPopViewForMonth];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [self setupRefreshForTableview];
    
    // 请求数据
    [self requestClaimList:YES];
    
    // 新增发票成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewClaimSuccess) name:kAddNewClaimSuccess object:nil];
    
    // 更新用户头像
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserAvatar) name:kUpdateAvatar object:nil];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    UIImage *imgBtn = [UIImage imageNamed:@"new_btn_capture"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
//    UIImage *imgBtn = [UIImage imageNamed:@"btn_bg_submit"];
//    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
//    
//    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_bg_submit_press"];
//    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnFill setBackgroundImage:imgBtn forState:UIControlStateNormal];
    //[self.btnFill setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnFill setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnFill setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    //self.viewFunction.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    self.viewFunction.backgroundColor = [UIColor colorWithRed:(CGFloat)247/255 green:(CGFloat)97/255 blue:(CGFloat)29/255 alpha:1];
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)217/255 green:(CGFloat)218/255 blue:(CGFloat)219/255 alpha:1];
    [self.viewFunction addSubview:viewLine];
    
    //self.viewFill.backgroundColor = [UIColor colorWithRed:(CGFloat)87/255 green:(CGFloat)129/255 blue:(CGFloat)254/255 alpha:1];
    
    self.lblDate.text = self.strDate;
    self.lblMonth.text = [self getCurrentMonth];
    self.lblYear.text = [self getCurrentYear];
    
    self.lblDate.textColor = [UIColor whiteColor];
    self.lblMonth.textColor = [UIColor colorWithRed:(CGFloat)42/255 green:(CGFloat)184/255 blue:(CGFloat)252/255 alpha:1];
    self.lblYear.textColor = [UIColor colorWithRed:(CGFloat)42/255 green:(CGFloat)184/255 blue:(CGFloat)252/255 alpha:1];
    
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

// 查看or隐藏菜单栏
- (void)backAction
{
    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        // 点击按钮隐藏菜单栏后的动画
        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
            
        }];
    }];
}

// New
- (void)moreAction
{
    // 填写发票
//    RecordAddViewController *addVC = [[RecordAddViewController alloc] initWithNibName:@"RecordAddViewController" bundle:nil];
//    [self.navigationController pushViewController:addVC animated:YES];
    
    // 填写发票
    NewRecordViewController *newVC = [[NewRecordViewController alloc] initWithNibName:@"NewRecordViewController" bundle:nil];
    [self.navigationController pushViewController:newVC animated:YES];
}


#pragma mark - AutoLayout

- (void)initViewWithAutoLayout
{
    //
    self.viewBottomHeight.constant = 0;
    
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
    [self requestClaimList:YES];
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
        
        [self requestClaimList:YES];
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


#pragma mark - Notification

- (void)addNewClaimSuccess
{
    [self.tableview scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:NO];
    [self requestClaimList:NO];
}

- (void)updateUserAvatar
{
    [self.tableview reloadData];
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

- (void)requestClaimList:(BOOL)showLoading
{
    if (showLoading == YES)
    {
        NSString *strLoading = locatizedString(@"loading");
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    }
    
    NSString *strYear = [self getCurrentYear];
    NSString *strMonth = [self getCurrentMonth];
    NSString *month = [NSString stringWithFormat:@"%@/%@", strYear, strMonth];
    
    // Test
    //month = @"2015/07";
    
    [InterfaceManager getUserClaimByMonth:month completion:^(BOOL isSucceed, NSString *message, id data) {
        
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
                        //[self toast:@"暂无发票记录数据"];
                        
                        if (showLoading == YES)
                        {
                            [self toast:@"暂无发票记录数据"];
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
                    NSLog(@"暂无发票记录数据");
                    //[self toast:@"暂无发票记录数据"];
                    
                    if (showLoading == YES)
                    {
                        [self toast:@"暂无发票记录数据"];
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
                NSLog(@"暂无发票记录数据");
                //[self toast:@"暂无发票记录数据"];
                
                if (showLoading == YES)
                {
                    [self toast:@"暂无发票记录数据"];
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
                //[self toast:@"获取发票记录失败"];
                
                if (showLoading == YES)
                {
                    [self toast:@"获取发票记录失败"];
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


#pragma mark - BtnTouchAction

- (IBAction)btnTouchAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (tag == kTag)
    {
        // 填写发票
        
//        SubmitClaimViewController *submitVC = [[SubmitClaimViewController alloc] initWithNibName:@"SubmitClaimViewController" bundle:nil];
//        [self.navigationController pushViewController:submitVC animated:YES];
        
        RecordAddViewController *addVC = [[RecordAddViewController alloc] initWithNibName:@"RecordAddViewController" bundle:nil];
        [self.navigationController pushViewController:addVC animated:YES];
    }
    else
    {
        //
    }
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
}


@end
