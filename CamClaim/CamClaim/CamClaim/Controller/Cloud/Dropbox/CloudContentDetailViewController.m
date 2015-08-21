//
//  CloudContentDetailViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/13.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CloudContentDetailViewController.h"

@interface CloudContentDetailViewController () <DBRestClientDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic,strong) DBMetadata *dropboxMetadata;

@property (nonatomic, weak) IBOutlet UIImageView *imgview;
@property (nonatomic, copy) NSString *destinationPath;

@property (nonatomic, copy) NSString *cloudKey;

@end

@implementation CloudContentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = self.fileItem.filename;
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;

    // 保存
    self.navView.btnMore.hidden = YES;
    [self.navView.btnMore setImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
    
    self.viewContent.backgroundColor = [UIColor blackColor];
    
    if (self.cloudType == 0)
    {
        self.cloudKey = @"Baidu";
    }
    else if (self.cloudType == 1)
    {
        self.cloudKey = @"Onedrive";
    }
    else
    {
        self.cloudKey = @"Dropbox";
    }
    
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
        [self toast:@"保存到相册成功"];
    }
    else
    {
        NSLog(@"error:%@", [error description]);
        [self toast:@"保存图片失败"];
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

- (DBRestClient *)restClient
{
    if (_restClient == nil)
    {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    
    return _restClient;
}

// download
- (void)getCloudContent
{
    NSString *fileName = [NSString stringWithFormat:@"%@%lu.jpg", self.cloudKey, (unsigned long)[self.fileItem.path hash]];
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
        [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
        [self.restClient loadFile:self.fileItem.path intoPath:filePath];
    }
}


#pragma mark - DBRestClientDelegate

//- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
//{
//    //
//}

// Implement the following callback instead of the previous if you care about the value of the
// Content-Type HTTP header and the file metadata. Only one will be called per successful response.
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath contentType:(NSString*)contentType metadata:(DBMetadata*)metadata
{
    NSLog(@"...>>>loadedFile:%@", destPath);
    NSLog(@"The file %@ was downloaded. Content type: %@", metadata.filename, contentType);
    
    // show
    UIImage *img = [UIImage imageWithContentsOfFile:destPath];
    self.imgview.image = img;
    self.destinationPath = destPath;    // 保存本地图片路径
    
    [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
    self.navView.btnMore.hidden = NO;
    
    // save
    [UIImageJPEGRepresentation(img, 1) writeToFile:destPath options:NSAtomicWrite error:nil];
}

- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath
{
    NSLog(@"...>>>uploadProgress:%f", progress);
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    NSLog(@"...>>>loadFileFailedWithError:%@", [error description]);
    
    [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
}


@end
