//
//  OnedriveDetailViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/14.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "OnedriveDetailViewController.h"

@interface OnedriveDetailViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imgview;

@property (nonatomic, copy) NSString *cloudKey;

@end

@implementation OnedriveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = self.item.name;
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 保存
    self.navView.btnMore.hidden = YES;
    [self.navView.btnMore setImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
    
    self.viewContent.backgroundColor = [UIColor blackColor];
    
    self.cloudKey = @"Onedrive";
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [self getCloudContent];
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

// save
- (void)moreAction
{
    UIImageWriteToSavedPhotosAlbum(self.imgview.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        //[self toast:@"保存到相册成功"];
        
        NSString *strValue = locatizedString(@"cloud_save_ok");
        [self toast:strValue];
    }
    else
    {
        NSLog(@"error:%@", [error description]);
        //[self toast:@"保存图片失败"];
        
        NSString *strValue = locatizedString(@"cloud_save_fail");
        [self toast:strValue];
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


#pragma mark - DownloadCloudContent


// download
- (void)getCloudContent
{
    NSString *fileName = [NSString stringWithFormat:@"%@%lu.jpg", self.cloudKey, (unsigned long)[self.item.id hash]];
    NSString *fileDir = [NSString getImageLocationPath];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", fileDir, fileName];
    
    NSFileManager *fileHandler = [NSFileManager defaultManager];
    if ([fileHandler fileExistsAtPath:filePath] == YES)
    {
        // 已存在图片,则直接显示
        self.imgview.image = [UIImage imageWithContentsOfFile:filePath];
        self.navView.btnMore.hidden = NO;
    }
    else
    {
        // 不存在,则下载
        
        if (!self.client)
        {
            self.client = [ODClient loadCurrentClient];
        }
        
        // 不需要下载原图,size太大,下载时间过长。
        // 直接下载大尺寸的缩略图即可...~!@
        [self downloadLargeThumbnailImage:filePath];
    }
}

// 原图
- (void)downloadSourceImage:(NSString *)localPath
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [[[[self.client drive] items:self.item.id] contentRequest] downloadWithCompletion:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (!error)
        {
            // 生成图片
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            
            // save
            [UIImageJPEGRepresentation(img, 1) writeToFile:localPath options:NSAtomicWrite error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                // 下载完成，显示图片
                self.imgview.image = img;
                self.navView.btnMore.hidden = NO;
                [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
            });
        }
        else
        {
            NSLog(@"当前缩略图下载失败<id:%@>", self.item.id);
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
            });
        }
    }];
}

// 缩略图
- (void)downloadLargeThumbnailImage:(NSString *)localPath
{
    if ([self.item thumbnails:0])
    {
        NSString *strLoading = locatizedString(@"loading");
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
        
        // 若当前ODItem对象有缩略图,则开始下载
        [[[[[[self.client drive] items:self.item.id] thumbnails:@"0"] large] contentRequest] downloadWithCompletion:^(NSURL *location, NSURLResponse *response, NSError *error) {
            if (!error)
            {
                // 生成图片
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                
                // save
                [UIImageJPEGRepresentation(img, 1) writeToFile:localPath options:NSAtomicWrite error:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    // 下载完成，显示图片
                    self.imgview.image = img;
                    self.navView.btnMore.hidden = NO;
                    [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
                });
            }
            else
            {
                NSLog(@"当前缩略图下载失败<id:%@>", self.item.id);
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
                });
            }
        }];
    }
    else
    {
        [self downloadSourceImage:localPath];
    }
}


@end
