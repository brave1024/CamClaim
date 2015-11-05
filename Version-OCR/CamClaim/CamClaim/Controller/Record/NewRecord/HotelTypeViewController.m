//
//  HotelTypeViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/9/27.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "HotelTypeViewController.h"
#import "MapViewController.h"

@interface HotelTypeViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayList;

@property (nonatomic, strong) IBOutlet UIView *viewTableHeader;

@property (nonatomic, strong) IBOutlet UILabel *lblDate;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewClaim;

@property (nonatomic, strong) IBOutlet UILabel *lblStart;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldHotel;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldUse;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldDateNumber;
@property (nonatomic, strong) IBOutlet UITextField *txtfieldCost;

// 半透明遮罩
@property (nonatomic, strong) UIView *viewTranslucence;

//
@property (nonatomic, strong) IBOutlet UIView *viewPicker;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnCancel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *barbtnDone;

@property (nonatomic, strong) IBOutlet UIButton *btnSave;
@property (nonatomic, strong) IBOutlet UIButton *btnSubmit;

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, assign) CLLocationCoordinate2D startLoc;
@property (nonatomic, copy) NSString *startAddress;
@property BOOL hasGetStart;

- (IBAction)getUserLocation:(id)sender;

- (IBAction)saveAction;
- (IBAction)submitAction;

@end

@implementation HotelTypeViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"住宿";
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
        
    [self initView];
    
    [self initPopViewForDate];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHeader;
    
    self.viewTableHeader.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);   // 460
    
    UIImage *img = [UIImage imageNamed:@"btn_save"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.btnSave setBackgroundImage:img forState:UIControlStateNormal];
    
    UIImage *img_ = [UIImage imageNamed:@"btn_resubmit"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.btnSubmit setBackgroundImage:img_ forState:UIControlStateNormal];
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
    //[formatter setDateFormat:@"YYYY.MM.dd"];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    self.lblDate.text = [formatter stringFromDate:[NSDate date]];
}

- (void)initData
{
    self.date = [NSDate date];
    
    
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


#pragma mark - BtnTouchAction

// 保存
- (IBAction)saveAction
{
    
    
}

// 提交
- (IBAction)submitAction
{
    
    
}

// 上传发票
- (IBAction)uploadClaimImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传发票"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"相册", nil];
    actionSheet.tag = kTag + 1;
    [actionSheet showInView:self.view.window];
}

- (IBAction)showPopViewForDate
{
    [self.view addSubview:self.viewTranslucence];
}

- (IBAction)cancelPopViewForTime
{
    [self.viewTranslucence removeFromSuperview];
}

- (IBAction)donePopViewForTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *strDate = [formatter stringFromDate:self.datePicker.date];
    self.lblDate.text = strDate;
    self.date = self.datePicker.date;
    
    [self.viewTranslucence removeFromSuperview];
}

- (IBAction)getUserLocation:(id)sender
{
    // 起始位置
    MapViewController *mapVC = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    mapVC.startFlag = YES;
    mapVC.beforeVC = self;
    [self.navigationController pushViewController:mapVC animated:YES];
}


#pragma mark - Custom

- (void)hidePopViewForDate
{
    [self.viewTranslucence removeFromSuperview];
    
}

- (void)getStartLocation:(CLLocationCoordinate2D)location andAddress:(NSString *)address
{
    self.startLoc = location;
    self.startAddress = address;
    self.hasGetStart = YES;
    
    self.lblStart.text = address;
}


#pragma mark - HttpRequest

// 上传发票请求
- (void)requestForUploadClaimImage:(UIImage *)img
{
    
    
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
    //return self.arrayList.count;
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *cellID = @"cellType";
//    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil)
//    {
//        cell = [SettingCell cellFromNib];
//    }
//
//    NSDictionary *dic = self.arrayList[indexPath.row];
//    [cell configWithData:dic];
//
//    cell.lblContent.hidden = YES;
//
//    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
//    return cell;
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
    
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kTag)
    {
        //
        
    }
    else if (actionSheet.tag == kTag + 1)
    {
        UIImagePickerControllerSourceType aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        switch (buttonIndex)
        {
            case 0:
                LogTrace( @"相机");
                aSourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                LogTrace( @"从相册获取图片");
                break;
                
            default:
                return;
        }
        
        [self pickerImageWithType:aSourceType];
    }
}

- (void)pickerImageWithType:(UIImagePickerControllerSourceType)aSourceType
{
    if (aSourceType == UIImagePickerControllerSourceTypeCamera &&
        ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    //    sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
    //    sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
    //    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    if(aSourceType == UIImagePickerControllerSourceTypePhotoLibrary &&
       [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeImage];
    }
    
    [picker setDelegate:self];
    [picker setAllowsEditing:NO];  //设置可编辑
    [picker setSourceType:aSourceType];
    [self presentViewController:picker animated:YES completion:nil];   //进入照相界面
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgPicker = nil;
    imgPicker = [info objectForKey:UIImagePickerControllerEditedImage];
    if (imgPicker == nil)
    {
        imgPicker = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            self.imgviewClaim.image = imgPicker;
            
            // 上传发票
            [self requestForUploadClaimImage:imgPicker];
        });
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    LogTrace(@"Picker Image Cancel!");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 只可输入数字和小数点
    
    
    return YES;
}


@end
