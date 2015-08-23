//
//  SubmitClaimViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/18.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "SubmitClaimViewController.h"

@interface SubmitClaimViewController ()

@property (nonatomic, weak) IBOutlet UIButton *btnTime;
@property (nonatomic, weak) IBOutlet UIButton *btnType;
@property (nonatomic, weak) IBOutlet UIButton *btnCompany;
@property (nonatomic, weak) IBOutlet UIButton *btnSubmit;

@property (nonatomic, weak) IBOutlet UITextField *textfieldUse;
@property (nonatomic, weak) IBOutlet UITextField *textfieldMoney;
@property (nonatomic, weak) IBOutlet UITextField *textfieldTime;
@property (nonatomic, weak) IBOutlet UITextField *textfieldTimeNew;
@property (nonatomic, weak) IBOutlet UITextField *textfieldLocation;

@property (nonatomic, weak) IBOutlet UITextField *textfieldBill;
@property (nonatomic, weak) IBOutlet UITextField *textfieldCompany;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence;

//
@property (nonatomic, strong) IBOutlet UIView *viewPicker;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone;

- (IBAction)btnTouchAction:(id)sender;

@end

@implementation SubmitClaimViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"提交";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    
    [self initView];
    
    [self initPopViewForDate];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
}

- (void)initView
{
//    UIImage *img = [UIImage imageNamed:@"img_input"];
//    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_bg_submit"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_bg_submit_press"];
    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnSubmit setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [self.btnSubmit setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSubmit setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
}

- (void)initPopViewForDate
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
    
    // 默认显示今天
    self.datePicker.date = [NSDate date];
    //[self.datePicker setMinimumDate:minDate];
    [self.datePicker setMaximumDate:[NSDate date]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    self.textfieldTimeNew.text = [formatter stringFromDate:[NSDate date]];
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
    //
    self.scrollviewWidth.constant = kScreenWidth;
    self.viewLineWidth.constant = kScreenWidth - 20;
    self.btnSubmitWidth.constant = kScreenWidth - 40;
    
    if (kScreenWidth == kWidthFor5)
    {
        self.textfieldWidth.constant = 200;
        self.viewTimeWidth.constant = 200;
        self.viewBillWidth.constant = 184;
        self.viewCompanyWidth.constant = 208;
    }
    else if (kScreenWidth == kWidthFor6)
    {
        self.textfieldWidth.constant = 200 + (kScreenWidth - 320);
        self.viewTimeWidth.constant = 200 + (kScreenWidth - 320);
        self.viewBillWidth.constant = 184 + (kScreenWidth - 320);
        self.viewCompanyWidth.constant = 208 + (kScreenWidth - 320);
    }
    else if (kScreenWidth == kWidthFor6plus)
    {
        self.textfieldWidth.constant = 200 + (kScreenWidth - 320);
        self.viewTimeWidth.constant = 200 + (kScreenWidth - 320);
        self.viewBillWidth.constant = 184 + (kScreenWidth - 320);
        self.viewCompanyWidth.constant = 208 + (kScreenWidth - 320);
    }
}


#pragma mark - Language

- (void)settingLanguage
{
    
    
}


#pragma mark - 

- (IBAction)btnTouchAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (tag == kTag)
    {
        // 提交发票
        
        
    }
    else if (tag == kTag + 1)
    {
        //
        NSLog(@"日期");
        [self.view addSubview:self.viewTranslucence];
    }
    else if (tag == kTag + 2)
    {
        //
        NSLog(@"类型");
        
    }
    else if (tag == kTag + 3)
    {
        //
        NSLog(@"公司");
        
    }
    else if (tag == kTag + 4)
    {
        //
        NSLog(@"取消");
        [self.viewTranslucence removeFromSuperview];
    }
    else if (tag == kTag + 5)
    {
        //
        NSLog(@"确定");
        [self.viewTranslucence removeFromSuperview];
        
        NSDate *dateSelected = self.datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"YYYY.MM.dd"];
        self.textfieldTimeNew.text = [formatter stringFromDate:dateSelected];
    }
    else
    {
        //
    }
}


#pragma mark -

- (void)hidePopViewForDate
{
    [self.viewTranslucence removeFromSuperview];
}



@end
