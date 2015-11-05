//
//  UserInfoViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/28.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoCell.h"
#import "UserAvatarCell.h"
#import "SettingViewController.h"
#import "UserModifyViewController.h"
#import "UIImageView+WebCache.h"

@interface UserInfoViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) IBOutlet UIView *viewTableHead;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewBg;
@property (nonatomic, strong) IBOutlet UIImageView *imgviewAvatar;
@property (nonatomic, strong) IBOutlet UILabel *lblName;

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayList;

@property (nonatomic, strong) UIImage *imgAvatar;

- (IBAction)userUpdateAvatar;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.title = @"个人中心";
    //self.navView.lblTitle.text = @"Personal Info";
    
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    
    // 当前导航栏左侧图标替换
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    NSString *strValue = locatizedString(@"change");
    
    // 修改
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:strValue forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self initView];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:kUpdateUserInfo object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.imgAvatar != nil)
    {
        self.imgviewAvatar.image = self.imgAvatar;
    }
    if (self.imgviewBg.image != nil)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 处理耗时操作的代码块...
            
            // 指定图片进行高斯模糊
            CIContext *context = [CIContext contextWithOptions:nil];
            CIImage *img = [CIImage imageWithCGImage:self.imgAvatar.CGImage];
            CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [filter setValue:img forKey:kCIInputImageKey];
            [filter setValue:@3.0f forKey:@"inputRadius"];
            CIImage *result = [filter valueForKey:kCIOutputImageKey];
            CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
            UIImage *blurImage = [UIImage imageWithCGImage:outImage];
            
            // 截取头像中心部分
            CGFloat imgWidth = blurImage.size.width;
            CGFloat imgHeight = blurImage.size.height;
            CGFloat rate = 150.0/kScreenWidth;
            CGFloat width = imgWidth/4;
            CGFloat height = width * rate;
            UIImage *imgCenter = [blurImage clipImageInRect:CGRectMake((imgWidth-width)/2, (imgHeight-height)/2, width, height)];
            
            /********************************************/
            
            // 通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新
                self.imgviewBg.image = imgCenter;
            });
            
        });
    }
    
    [self.tableview reloadData];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)initView
{
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    self.tableview.tableHeaderView = self.viewTableHead;
    
    // 先显示默认头像
//    GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
//    blurFilter.blurRadiusInPixels = 10.0;
//    UIImage *image = [UIImage imageNamed:@"img_avatar"];
//    UIImage *blurredImage = [blurFilter imageByFilteringImage:image];
//    self.imgviewBg.image = blurredImage;
    
    //self.imgviewBg.image = [self createBackgroundImageForGaussianBlur:[UIImage imageNamed:@"img_avatar"]];
    self.imgviewBg.image = nil;
    
    __weak UserInfoViewController *weakSelf = self;
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 处理耗时操作的代码块...
//
//        // 指定图片进行高斯模糊
//        CIContext *context = [CIContext contextWithOptions:nil];
//        CIImage *img = [CIImage imageWithCGImage:[UIImage imageNamed:@"img_avatar"].CGImage];
//        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//        [filter setValue:img forKey:kCIInputImageKey];
//        [filter setValue:@3.0f forKey:@"inputRadius"];
//        CIImage *result = [filter valueForKey:kCIOutputImageKey];
//        CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
//        UIImage *blurImage = [UIImage imageWithCGImage:outImage];
//
//        // 截取头像中心部分
//        CGFloat imgWidth = blurImage.size.width;
//        CGFloat imgHeight = blurImage.size.height;
//        CGFloat rate = 150.0/kScreenWidth;
//        CGFloat width = imgWidth/4;
//        CGFloat height = width * rate;
//        UIImage *imgCenter = [blurImage clipImageInRect:CGRectMake((imgWidth-width)/2, (imgHeight-height)/2, width, height)];
//
//        /********************************************/
//
//        // 通知主线程刷新
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //回调或者说是通知主线程刷新
//            weakSelf.imgviewBg.image = imgCenter;
//        });
//
//    });
    
    self.imgviewAvatar.image = [UIImage imageNamed:@"img_avatar"];
    self.imgviewAvatar.layer.masksToBounds = YES;
    self.imgviewAvatar.layer.cornerRadius = 38;
    self.imgviewAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.imgviewAvatar.layer.borderWidth = 2;
    
    UserManager *user = [UserManager sharedInstance];
    if (user.userInfo.img != nil && user.userInfo.img.length > 0)
    {
        // 有头像
        
        if ([user.userInfo.img hasPrefix:@"http://"] == NO)
        {
            user.userInfo.img = [NSString stringWithFormat:@"http://%@", user.userInfo.img];
        }
        else
        {
            //
        }
        
        UIImageView *imgview = [[UIImageView alloc] init];
        imgview.hidden = YES;
        [imgview sd_setImageWithURL:[NSURL URLWithString:user.userInfo.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil)
            {
                NSLog(@"图片下载成功...<%@>", [NSURL URLWithString:user.userInfo.img]);
                self.imgAvatar = image;
                [self.tableview reloadData];
                
                //self.imgviewBg.image = [self createBackgroundImageForGaussianBlur:image];
                self.imgviewAvatar.image = image;
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    // 处理耗时操作的代码块...
                    
                    // 指定图片进行高斯模糊
                    CIContext *context = [CIContext contextWithOptions:nil];
                    CIImage *img = [CIImage imageWithCGImage:image.CGImage];
                    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                    [filter setValue:img forKey:kCIInputImageKey];
                    [filter setValue:@3.0f forKey:@"inputRadius"];
                    CIImage *result = [filter valueForKey:kCIOutputImageKey];
                    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
                    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
                    
                    // 截取头像中心部分
                    CGFloat imgWidth = blurImage.size.width;
                    CGFloat imgHeight = blurImage.size.height;
                    CGFloat rate = 150.0/kScreenWidth;
                    CGFloat width = imgWidth/4;
                    CGFloat height = width * rate;
                    UIImage *imgCenter = [blurImage clipImageInRect:CGRectMake((imgWidth-width)/2, (imgHeight-height)/2, width, height)];
                    
                    /********************************************/
                    
                    // 通知主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //回调或者说是通知主线程刷新
                        weakSelf.imgviewBg.image = imgCenter;
                    });
                    
                });
                
            }
            else
            {
                NSLog(@"图片下载失败...<%@>", [NSURL URLWithString:user.userInfo.img]);
            }
        }];
    }
    else
    {
        // 无头像
    }
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
    //[self.navigationController popViewControllerAnimated:YES];
    
    //[self.viewDeckController toggleLeftView];
    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        // 点击按钮隐藏菜单栏后的动画
        //[self.viewDeckController previewBounceView:IIViewDeckLeftSide];
        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
            
        }];
    }];
}

// 修改
- (void)moreAction
{
    UserModifyViewController *modifyVC = [[UserModifyViewController alloc] initWithNibName:@"UserModifyViewController" bundle:nil];
    [self.navigationController pushViewController:modifyVC animated:YES];
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


#pragma mark - GetData

- (NSMutableArray *)arrayList
{
    if (_arrayList == nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UserInfo_Final" ofType:@"plist"];
        _arrayList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    
    return _arrayList;
}


#pragma mark - Custom

- (UIImage *)createBackgroundImageForGaussianBlur:(UIImage *)img
{
    // 指定图片进行高斯模糊
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@3.0f forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    
    // 截取头像中心部分
    CGFloat imgWidth = blurImage.size.width;
    CGFloat imgHeight = blurImage.size.height;
    CGFloat rate = 150.0/kScreenWidth;
    CGFloat width = imgWidth/4;
    CGFloat height = width * rate;
    UIImage *imgCenter = [blurImage clipImageInRect:CGRectMake((imgWidth-width)/2, (imgHeight-height)/2, width, height)];
    return imgCenter;
    
//    // 截取头像中心部分
//    UIImage *imgSize = [img rescaleImageToSize:CGSizeMake(76, 76)];
//    UIImage *imgCenter = [imgSize clipImageInRect:CGRectMake((76-30)/2, (76-30)/2, 26, 26)];
//    
//    // 指定图片进行高斯模糊
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *image = [CIImage imageWithCGImage:imgCenter.CGImage];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:image forKey:kCIInputImageKey];
//    [filter setValue:@2.0f forKey:@"inputRadius"];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
//    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
//    
//    return blurImage;
}

- (IBAction)userUpdateAvatar
{
    [self uploadUserAvatar];
}

- (void)updateUserInfo
{
    [self.tableview reloadData];
}


#pragma mark - HttpRequest

- (void)uploadUserAvatar:(UIImage *)img
{
    NSString *struploading = locatizedString(@"uploading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:struploading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    NSData *dataImg = UIImageJPEGRepresentation(img, 0.8f);
    //NSString *stringBase64 = [dataImg base64Encoding];
    NSString *stringBase64 = [dataImg base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    __weak UserInfoViewController *weakSelf = self;
    
    [InterfaceManager updateUserImage:stringBase64 completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"提交成功");
                    
                    UserInfoModel *userInfo = response.data;
                    NSLog(@"data:%@", userInfo);
                    
                    // 保存img
                    if (userInfo.img != nil && userInfo.img.length > 0)
                    {
                        UserManager *userManager = [UserManager sharedInstance];
                        userManager.userInfo.img = userInfo.img;
                        
                        if ([userManager.userInfo.img hasPrefix:@"http://"] == NO)
                        {
                            userManager.userInfo.img = [NSString stringWithFormat:@"http://%@", userManager.userInfo.img];
                        }
                        else
                        {
                            //
                        }
                    }
                    
                    // 更新...~!@
                    weakSelf.imgAvatar = img;
                    [weakSelf.tableview reloadData];
                    
                    self.imgviewAvatar.image = img;
                    //self.imgviewBg.image = [self createBackgroundImageForGaussianBlur:img];
                    
                    //__weak UIImage *myImg = img;
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        // 处理耗时操作的代码块...
                        
                        // 指定图片进行高斯模糊
                        CIContext *context = [CIContext contextWithOptions:nil];
                        CIImage *image = [CIImage imageWithCGImage:img.CGImage];
                        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
                        [filter setValue:image forKey:kCIInputImageKey];
                        [filter setValue:@3.0f forKey:@"inputRadius"];
                        CIImage *result = [filter valueForKey:kCIOutputImageKey];
                        CGImageRef outImage = [context createCGImage:result fromRect:[result extent]];
                        UIImage *blurImage = [UIImage imageWithCGImage:outImage];
                        
                        // 截取头像中心部分
                        CGFloat imgWidth = blurImage.size.width;
                        CGFloat imgHeight = blurImage.size.height;
                        CGFloat rate = 150.0/kScreenWidth;
                        CGFloat width = imgWidth/4;
                        CGFloat height = width * rate;
                        UIImage *imgCenter = [blurImage clipImageInRect:CGRectMake((imgWidth-width)/2, (imgHeight-height)/2, width, height)];
                        
                        /********************************************/
                        
                        // 通知主线程刷新
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //回调或者说是通知主线程刷新
                            weakSelf.imgviewBg.image = imgCenter;
                        });
                        
                    });
                    
                    // 清空缓存,以便重新下载用户头像
                    //[[SDImageCache sharedImageCache] clearDisk];
                    
                    // 通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAvatar object:nil];
                }
                else
                {
                    NSLog(@"提交失败");
                    //[self toast:@"提交失败"];
                    
                    NSString *strTip = locatizedString(@"submit_fail");
                    [self toast:strTip];
                }
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
                //[self toast:@"提交失败"];
                
                NSString *strTip = locatizedString(@"submit_fail");
                [self toast:strTip];
            }
        }
        
    }];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
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
    NSArray *array = self.arrayList[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.arrayList[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    NSNumber *number = dic[@"cellHeight"];
    CGFloat height = [number floatValue];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//        static NSString *cellIdentifier = @"avatarCell";
//        UserAvatarCell *cell = (UserAvatarCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (cell == nil)
//        {
//            cell = [UserAvatarCell cellFromNib];
//        }
//        
//        NSArray *array = self.arrayList[indexPath.section];
//        NSDictionary *dic = array[indexPath.row];
//        [cell configWithData:dic];
//                
//        if (self.imgAvatar != nil)
//        {
//            cell.imgviewPic.image = self.imgAvatar;
//        }
//        else
//        {
//            // 默认头像
//            cell.imgviewPic.image = [UIImage imageNamed:@"img_avatar"];
//        }
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        return cell;
//    }
//    else
//    {
//        static NSString *cellIdentifier = @"userInfoCell";
//        UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//        if (cell == nil)
//        {
//            cell = [UserInfoCell cellFromNib];
//        }
//        
//        NSArray *array = self.arrayList[indexPath.section];
//        NSDictionary *dic = array[indexPath.row];
//        [cell configWithData:dic];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
//        return cell;
//    }
    
    static NSString *cellIdentifier = @"userInfoCell";
    UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [UserInfoCell cellFromNib];
    }
    
    NSArray *array = self.arrayList[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    [cell configWithData:dic];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *arr = self.arrayList[indexPath.section];
    NSDictionary *dic = arr[indexPath.row];
    NSString *strSelector = dic[@"selectorForJump"];
    if (strSelector != nil && strSelector.length > 0)
    {
        //SEL selector = NSSelectorFromString(strSelector);
        //[self performSelector:selector withObject:nil];
        
        // 消除警告: iOS PerformSelector may cause a leak because its selector is unknown
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(strSelector) withObject:nil];
#pragma clang diagnostic pop
    }
    else
    {
        //
    }
}


#pragma mark - Jump

// 设置
- (void)jumpSettingVC
{
    SettingViewController *settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [self.navigationController pushViewController:settingVC animated:YES];
}

// 上传头像
- (void)uploadUserAvatar
{
    NSString *strTip = locatizedString(@"upload_avatar");
    NSString *strCancel = locatizedString(@"cancel");
    NSString *strCamera = locatizedString(@"photo_camera");
    NSString *strAlbum = locatizedString(@"photo_album");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:strTip
                                                             delegate:self
                                                    cancelButtonTitle:strCancel
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:strCamera, strAlbum, nil];
    [actionSheet showInView:self.view.window];
}


#pragma mark - UIActionSheetdelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
    [picker setAllowsEditing:YES];  //设置可编辑
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
            //self.imgAvatar = imgPicker;
            //[self.tableview reloadData];
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            
            // 上传头像
            [self uploadUserAvatar:imgPicker];
        });
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     LogTrace(@"Picker Image Cancel!");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



@end
