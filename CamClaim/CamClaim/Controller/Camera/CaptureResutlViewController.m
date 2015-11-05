//
//  CaptureResutlViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/10/12.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CaptureResutlViewController.h"
#import "Masonry.h"
#import "TrafficTypeViewController.h"
#import "FoodTypeViewController.h"
#import "HotelTypeViewController.h"
#import "OtherTypeViewController.h"

@interface CaptureResutlViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imgview;
@property (nonatomic, weak) IBOutlet UIView *viewBottom;

@property (nonatomic, strong) IBOutlet UIView *viewType;
@property (nonatomic, strong) IBOutlet UIButton *btnTraffic;
@property (nonatomic, strong) IBOutlet UIButton *btnFood;
@property (nonatomic, strong) IBOutlet UIButton *btnHotel;
@property (nonatomic, strong) IBOutlet UIButton *btnGift;
@property (nonatomic, strong) IBOutlet UIButton *btnTool;
@property (nonatomic, strong) IBOutlet UIButton *btnOffice;
@property (nonatomic, strong) IBOutlet UIButton *btnOther;

@property (nonatomic, strong) IBOutlet UILabel *lblTraffic;
@property (nonatomic, strong) IBOutlet UILabel *lblFood;
@property (nonatomic, strong) IBOutlet UILabel *lbltHotel;
@property (nonatomic, strong) IBOutlet UILabel *lblGift;
@property (nonatomic, strong) IBOutlet UILabel *lblTool;
@property (nonatomic, strong) IBOutlet UILabel *lblOffice;
@property (nonatomic, strong) IBOutlet UILabel *lblOther;

@property (nonatomic, strong) UIScrollView *scrollview;

- (IBAction)btnTouchAction:(id)sender;

@end

@implementation CaptureResutlViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"CamClaim";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 选择照片
//    self.navView.btnMore.hidden = NO;
//    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
//    [self.navView.btnMore setTitle:@"Confirm" forState:UIControlStateNormal];
//    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    self.imgview.image = self.imgCapture;
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self initData];
    
    [self settingLanguage];
}

- (void)initView
{
    UILabel *lblTitle = [UILabel new];
    lblTitle.text = @"Select Type";
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont systemFontOfSize:15];
    lblTitle.textAlignment = NSTextAlignmentLeft;
    lblTitle.textColor = [UIColor darkGrayColor];
    [self.viewBottom addSubview:lblTitle];
    
    NSString *strValue = locatizedString(@"type_select");
    lblTitle.text = strValue;
    
    [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.viewBottom.mas_left).offset(10);
        make.top.mas_equalTo(self.viewBottom.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(120, 22));
        
    }];
    
    self.scrollview = [UIScrollView new];
    self.scrollview.backgroundColor = [UIColor clearColor];
    [self.viewBottom addSubview:self.scrollview];
    
    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(lblTitle.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.viewBottom.mas_bottom).offset(0);
        make.left.mas_equalTo(self.viewBottom.mas_left).offset(0);
        make.right.mas_equalTo(self.viewBottom.mas_right).offset(0);
        
    }];
    
    [self.scrollview addSubview:self.viewType];
    self.scrollview.contentSize = CGSizeMake(525, 80);
    self.scrollview.scrollEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    
    self.viewType.backgroundColor = [UIColor clearColor];
}

- (void)initData
{
    
    
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
//    [self dismissViewControllerAnimated:YES completion:^{
//        //
//    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 确定
- (void)moreAction
{
    //
    
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
    NSString *strValue = locatizedString(@"type_traffic");
    self.lblTraffic.text = strValue;
    
    strValue = locatizedString(@"type_meal");
    self.lblFood.text = strValue;
    
    strValue = locatizedString(@"type_hotel");
    self.lbltHotel.text = strValue;
    
    strValue = locatizedString(@"type_gift");
    self.lblGift.text = strValue;
    
    strValue = locatizedString(@"type_tool");
    self.lblTool.text = strValue;
    
    strValue = locatizedString(@"type_office");
    self.lblOffice.text = strValue;
    
    strValue = locatizedString(@"type_other");
    self.lblOther.text = strValue;
}


#pragma mark - 

- (IBAction)btnTouchAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    int typeFlag = 0;
    
    if (tag == kTag)
    {
        // 交通
        TrafficTypeViewController *trafficVC = [[TrafficTypeViewController alloc] initWithNibName:@"TrafficTypeViewController" bundle:nil];
        trafficVC.imgCapture = self.imgCapture;
        [self.navigationController pushViewController:trafficVC animated:YES];
        return;
    }
    else if (tag == kTag + 1)
    {
        // 膳食
        FoodTypeViewController *foodVC = [[FoodTypeViewController alloc] initWithNibName:@"FoodTypeViewController" bundle:nil];
        foodVC.imgCapture = self.imgCapture;
        [self.navigationController pushViewController:foodVC animated:YES];
        return;
    }
    else if (tag == kTag + 2)
    {
        // 住宿
        HotelTypeViewController *hotelVC = [[HotelTypeViewController alloc] initWithNibName:@"HotelTypeViewController" bundle:nil];
        hotelVC.imgCapture = self.imgCapture;
        [self.navigationController pushViewController:hotelVC animated:YES];
        return;
    }
    else if (tag == kTag + 3)
    {
        typeFlag = 3;
    }
    else if (tag == kTag + 4)
    {
        typeFlag = 4;
    }
    else if (tag == kTag + 5)
    {
        typeFlag = 5;
    }
    else if (tag == kTag + 6)
    {
        typeFlag = 6;
    }
    
    // 其它:礼物、工具、文仪用品、杂项申报
    OtherTypeViewController *otherVC = [[OtherTypeViewController alloc] initWithNibName:@"OtherTypeViewController" bundle:nil];
    otherVC.recordType = typeFlag;
    otherVC.imgCapture = self.imgCapture;
    [self.navigationController pushViewController:otherVC animated:YES];
}


@end
