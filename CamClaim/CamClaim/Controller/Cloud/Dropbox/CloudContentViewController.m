//
//  CloudContentViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/13.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CloudContentViewController.h"
// Dropbox
#import <DropboxSDK/DropboxSDK.h>
// VC
#import "CloudSubPathViewController.h"
#import "CloudContentDetailViewController.h"
// View
#import "CloudCell.h"

@interface CloudContentViewController () <DBRestClientDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) DBRestClient *restClient;
@property (nonatomic, strong) DBMetadata *dropboxMetadata;

@property (nonatomic, copy) NSString *cloudKey;

@end

@implementation CloudContentViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"云盘内容";
    
    if (self.cloudType == 0)
    {
        self.navView.lblTitle.text = @"Baidu Cloud";
        self.cloudKey = @"Baidu";
    }
    else if (self.cloudType == 1)
    {
        self.navView.lblTitle.text = @"Onedrive";
        self.cloudKey = @"Onedrive";
    }
    else
    {
        self.navView.lblTitle.text = @"Dropbox";
        self.cloudKey = @"Dropbox";
    }
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 上传
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:[UIImage imageNamed:@"btn_upload"] forState:UIControlStateNormal];
    
    //self.tableview.backgroundColor = [UIColor clearColor];
    //self.tableview.backgroundView = nil;
    
    self.tableview.hidden = YES;
    
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

// upload
- (void)moreAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    actionSheet.tag = kTag;
    [actionSheet showInView:self.view.window];
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


#pragma mark - GetCloudContent

- (DBRestClient *)restClient
{
    if (_restClient == nil)
    {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        _restClient.delegate = self;
    }
    
    return _restClient;
}

- (void)getCloudContent
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    self.navView.btnMore.enabled = NO;
    
    [self.restClient loadMetadata:@"/"];
}


#pragma mark - DBRestClientDelegate

// 1. Fetch Content
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    NSLog(@"<<<...loadedMetadata:%@", metadata);
    
    [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
    self.navView.btnMore.enabled = YES;
    
    NSLog(@"%@", metadata.contents);
    
    self.dropboxMetadata = metadata;
    [self.tableview reloadData];
    self.tableview.hidden = NO;
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
{
    NSLog(@"<<<...metadataUnchangedAtPath:%@", path);
    
    [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
    self.navView.btnMore.enabled = YES;
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    NSLog(@"<<<...loadMetadataFailedWithError:%@", [error description]);
    
    [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
    self.navView.btnMore.enabled = YES;
}

// 2. Upload
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath
          metadata:(DBMetadata*)metadata
{
    NSLog(@"...>>>uploadedFile:%@ from:%@", destPath, srcPath);
    
    // 刷新列表...~!@
    [self.restClient loadMetadata:@"/"];
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress forFile:(NSString*)destPath from:(NSString*)srcPath
{
    NSLog(@"...>>>uploadProgress:%f", progress);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    NSLog(@"...>>>uploadFileFailedWithError:%@", [error description]);
    
    [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
    self.navView.btnMore.enabled = YES;
}

// 3. Download
// 跳转到子界面来显示图片详情...

// 4. Download ThumbnailImage

- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath
{
    NSLog(@"loadedThumbnail:%@", destPath);
    
    NSString *fileName = [destPath lastPathComponent];
    NSString *file = [fileName stringByDeletingPathExtension];
    NSArray *arrayTemp = [file componentsSeparatedByString:@"+"];
    if (arrayTemp != nil && arrayTemp.count >= 2)
    {
        NSString *strIndex = [arrayTemp lastObject];
        NSInteger currentIndex = [strIndex integerValue];
        CloudCell *cell = (CloudCell *)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
        cell.imgviewType.image = [UIImage imageWithContentsOfFile:destPath];
    }
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error
{
    NSLog(@"...>>>loadThumbnailFailedWithError:%@", [error description]);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dropboxMetadata != nil && self.dropboxMetadata.contents != nil && self.dropboxMetadata.contents.count > 0)
    {
        return self.dropboxMetadata.contents.count;
    }
    else
    {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cloudCell";
    CloudCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [CloudCell cellFromNib];
    }

    DBMetadata *item = self.dropboxMetadata.contents[indexPath.row];
    [cell configWithData:item];
    
    if (item.isDirectory == NO)
    {
        // 文件
        NSString *strFormat = [[item.path pathExtension] lowercaseString];
        
        // 图片
        if ([strFormat isEqualToString:@"jpg"] == YES
            || [strFormat isEqualToString:@"jpeg"] == YES
            || [strFormat isEqualToString:@"png"] == YES
            || [strFormat isEqualToString:@"gif"] == YES
            || [strFormat isEqualToString:@"bmp"] == YES
            // ...~!@
            || [strFormat isEqualToString:@"tiff"] == YES
            || [strFormat isEqualToString:@"dxf"] == YES)
        {
            // download thumbnail
            
            NSString *fileName = [NSString stringWithFormat:@"%@%lu+%ld.jpg", self.cloudKey, (unsigned long)[item.path hash], indexPath.row];
            //NSString *fileName = [NSString stringWithFormat:@"%@+%ld.jpg", [NSString generateUniqueId], (long)indexPath.row];
            NSString *fileDir = [NSString getImageLocationPath];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", fileDir, fileName];
            
            NSFileManager *fileHandler = [NSFileManager defaultManager];
            if ([fileHandler fileExistsAtPath:filePath] == YES)
            {
                // 已存在图片,则直接显示
                cell.imgviewType.image = [UIImage imageWithContentsOfFile:filePath];
            }
            else
            {
                // 不存在,则下载
                [self.restClient loadThumbnail:item.path ofSize:@"iphone_bestfit" intoPath:filePath];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
    DBMetadata *item = self.dropboxMetadata.contents[indexPath.row];
    
    // 判断是否为文件夹
    if (item.isDirectory == YES)
    {
        // 文件夹
        CloudSubPathViewController *subVC = [[CloudSubPathViewController alloc] initWithNibName:@"CloudSubPathViewController" bundle:nil];
        subVC.cloudType = self.cloudType;
        subVC.dirPath = item.path;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else
    {
        // 文件
        
        // 目前只支持下载图片
        // 文件
        NSString *strFormat = [[item.path pathExtension] lowercaseString];
        
        // 图片
        if ([strFormat isEqualToString:@"jpg"] == YES
            || [strFormat isEqualToString:@"jpeg"] == YES
            || [strFormat isEqualToString:@"png"] == YES
            || [strFormat isEqualToString:@"gif"] == YES
            || [strFormat isEqualToString:@"bmp"] == YES
            // ...~!@
            || [strFormat isEqualToString:@"tiff"] == YES
            || [strFormat isEqualToString:@"dxf"] == YES)
        {
            CloudContentDetailViewController *detailVC = [[CloudContentDetailViewController alloc] initWithNibName:@"CloudContentDetailViewController" bundle:nil];
            detailVC.fileItem = item;
            detailVC.cloudType = self.cloudType;
            [self.navigationController pushViewController:detailVC animated:YES];
            
            //NSString *localImgPath = [NSString getImageLocationPath];
            //[self.restClient loadFile:item.path intoPath:localImgPath];
        }
        else
        {
            //[self toast:@"仅支持图片查看"];
            
            NSString *strValue = locatizedString(@"cloud_image_only");
            [self toast:strValue];
        }
    }
}


#pragma mark - UIActionSheetdelegate

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    LogTrace(@"actionSheet button index %ld", (long)buttonIndex);
    
    if (actionSheet.tag == kTag)
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
    //    sourceType = UIImagePickerControllerSourceTypeCamera;             // 照相机
    //    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;       // 图片库
    //    sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;   // 保存的相片
    
    if (aSourceType == UIImagePickerControllerSourceTypeCamera
        && ![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        aSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // 初始化
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    if(aSourceType == UIImagePickerControllerSourceTypePhotoLibrary
       && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    }
    
    [picker setDelegate:self];
    [picker setAllowsEditing:NO];
    [picker setSourceType:aSourceType];
    [self presentViewController:picker animated:YES completion:nil] ;   // 进入照相界面
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = nil;
    img = [info objectForKey:UIImagePickerControllerEditedImage];
    if (img == nil)
    {
        img = [info objectForKey:UIImagePickerControllerOriginalImage];
    }

    NSString *imgPath = [self saveImageToLocalPath:info];
    NSLog(@"imgPath:%@", imgPath);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        // 上传
        [self uploadFile:imgPath];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    LogTrace(@"Picker Image Cancel!");
}

- (NSString *)saveImageToLocalPath:(NSDictionary *)info
{
    NSString *dir = [NSString getImageLocationPath];    // 图片文件夹目录
    NSString *name = nil;       // 唯一标识
    NSString *ext = nil;        // 格式
    NSString *filename = nil;   // 文件名
    UIImage *image = nil;       // 图片对象
    NSURL *refURL;              //
    NSURL *url;                 //
    NSError *error = nil;
    
    refURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    // refURL: assets-library://asset/asset.JPG?id=4E656A60-D769-4E58-8E95-3C76EC863F48&ext=JPG
    
    if (refURL == nil)
    {
        LogTrace(@"Image from camera");
        
        name = [NSString generateUniqueId];
        ext = @"jpg";
        
        // name:177A2BE1-5BFA-453A-99C0-17F0247BB7FE
    }
    else
    {
        LogTrace(@"Image from photo library");
        
        NSString *query = [refURL query];
        NSLog(@"query:%@", query);
        
        // query:id=4E656A60-D769-4E58-8E95-3C76EC863F48&ext=JPG
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        for (NSString *pair in pairs)
        {
            NSArray *bits = [pair componentsSeparatedByString:@"="];
            NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            if ([key isEqualToString:@"id"])
            {
                name = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            }
            else if ([key isEqualToString:@"ext"])
            {
                ext = [[[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] lowercaseString];
            }
        }
    }
    
    NSLog(@"name:%@, name hash:%lu", name, (unsigned long)[name hash]);
    
    // name:177A2BE1-5BFA-453A-99C0-17F0247BB7FE, name hash:6076668713483780179
    // name:4E656A60-D769-4E58-8E95-3C76EC863F48, name hash:3434793882377839666
    
    filename = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu.%@", (unsigned long)[name hash], ext]];
    url = [NSURL fileURLWithPath:filename];
    
    // filename: /private/var/mobile/Containers/Data/Application/D86B855E-A206-45C2-BE31-DDF45B3E050B/tmp/image/6076668713483780179.jpg
    // url: file:///private/var/mobile/Containers/Data/Application/D86B855E-A206-45C2-BE31-DDF45B3E050B/tmp/image/6076668713483780179.jpg
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    int count = 1;
    while ([fileManager fileExistsAtPath:filename] == YES)
    {
        filename = [dir stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu_%d.%@", (unsigned long)[name hash], count, ext]];
        count++;
    }
    
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(image == nil)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    //[UIImageJPEGRepresentation(image, 0.8) writeToFile:filename options:NSAtomicWrite error:&error];
    [UIImageJPEGRepresentation(image, 1) writeToFile:filename options:NSAtomicWrite error:&error];
    
    return filename;
}

// 不再使用...~!@
- (NSString *)prepareImageWithDic:(NSDictionary *)info
{
    NSString *path = [NSString getImageLocationPath];
    NSString *name = nil;
    NSString *ext = nil;
    NSString *filename = nil;
    UIImage *image = nil;
    NSURL *refURL;
    NSURL *url;
    NSError *error = nil;
    
    refURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    if (refURL == nil)
    {
        LogTrace(@"Image from camera");
        
        name = [NSString generateUniqueId];
        ext = @"jpg";
    }
    else
    {
        LogTrace(@"Image from photo library");
        
        NSString *query = [refURL query];
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        for (NSString *pair in pairs)
        {
            NSArray *bits = [pair componentsSeparatedByString:@"="];
            NSString *key = [[bits objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            if ([key isEqualToString:@"id"])
            {
                name = [[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            }
            else if ([key isEqualToString:@"ext"])
            {
                ext = [[[bits objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] lowercaseString];
            }
        }
    }
    
    filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", name, ext]];
    url = [NSURL fileURLWithPath:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    int count = 1;
    while ([fileManager fileExistsAtPath:filename])
    {
        filename = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d.%@", name, count, ext]];
        count++;
    }
    
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(image == nil)
    {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [UIImageJPEGRepresentation(image, 0.8) writeToFile:filename options:NSAtomicWrite error:&error];
    return filename;
}


#pragma mark - Upload

- (void)uploadFile:(id)data
{
    // Dropbox
    if (data != nil)
    {
        if ([data isKindOfClass:[UIImage class]] == YES)
        {
            // 不直接传image文件
        }
        if ([data isKindOfClass:[NSString class]] == YES)
        {
            // image本地路径
            NSString *imgPath = (NSString *)data;
            NSString *fileName = [imgPath lastPathComponent];
            NSLog(@"fileName:%@", fileName);
            
            NSString *destinationPath = @"/";
            [self.restClient uploadFile:fileName toPath:destinationPath withParentRev:nil fromPath:imgPath];
            
            NSString *struploading = locatizedString(@"uploading");
            [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:struploading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
            self.navView.btnMore.enabled = NO;
        }
        else
        {
            //
        }
    }
}


@end
