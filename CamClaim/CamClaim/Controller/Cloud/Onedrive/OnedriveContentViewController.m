//
//  OnedriveContentViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/14.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "OnedriveContentViewController.h"
#import "CloudCell.h"
#import "ODXTextViewController.h"
#import "ODXActionController.h"
#import "OnedriveSubPathViewController.h"
#import "OnedriveDetailViewController.h"

@interface OnedriveContentViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) ODItem *currentItem;

@property (nonatomic, strong) NSMutableDictionary *items;       // 保存Onedrive对象 ODItem
@property (nonatomic, strong) NSMutableDictionary *thumbnails;  //
@property (nonatomic, strong) NSMutableArray *itemsLookup;      //

@end

@implementation OnedriveContentViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //self.navView.lblTitle.text = @"云盘内容";
    
    self.navView.lblTitle.text = @"Onedrive";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 上传
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:[UIImage imageNamed:@"btn_upload"] forState:UIControlStateNormal];
    
    //self.tableview.backgroundColor = [UIColor clearColor];
    //self.tableview.backgroundView = nil;
    
    self.tableview.hidden = YES;
    
    self.items = [NSMutableDictionary dictionary];
    self.thumbnails = [NSMutableDictionary dictionary];
    self.itemsLookup = [NSMutableArray array];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    [self getCloudContent];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
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


/*
To retrieve a user's drive:
[[[odClient drive] request] getWithCompletion:^(ODDrive *drive, NSError *error){
    //Returns an ODDrive object or an error if there was one
}];
 
To get a user's root folder of their drive:
[[[[odClient drive] items:@"root"] request] getWithCompletion:^(ODItem *item, NSError *error){
    //Returns an ODItem object or an error if there was one
}];
*/

#pragma mark - GetCloudContent

- (void)getCloudContent
{
    NSString *strLoading = locatizedString(@"loading");
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:strLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    self.navView.btnMore.enabled = NO;
    
    if (!self.client)
    {
        self.client = [ODClient loadCurrentClient];
    }
    
    // 获取当前目录
    NSString *itemId = (self.currentItem) ? self.currentItem.id : @"root";
    ODChildrenCollectionRequest *childrenRequest = [[[[self.client drive] items:itemId] children] request];
    
    // https://api.onedrive.com/v1.0/drive/items/root/children
    
//    // 获取当前目录对应的item
//    ODItemRequestBuilder *item = [[self.client drive] items:itemId];
//    // 获取当前目录下的所有子目录
//    ODChildrenCollectionRequestBuilder *child = [item children];
//    // 生成请求request
//    ODChildrenCollectionRequest *childrenRequest = [child request];
    
    NSLog(@"%@", [self.client serviceFlags][@"NoThumbnails"]);
    
    if (![self.client serviceFlags][@"NoThumbnails"])
    {
        [childrenRequest expand:@"thumbnails"];
        
        // baseURL:https://api.onedrive.com/v1.0
        // https://api.onedrive.com/v1.0/drive/items/root/children
    }
    
    [self loadChildrenWithRequest:childrenRequest];
}

- (void)loadChildrenWithRequest:(ODChildrenCollectionRequest *)childrenRequests
{
    [childrenRequests getWithCompletion:^(ODCollection *response, ODChildrenCollectionRequest *nextRequest, NSError *error){
        
        NSLog(@"response%@, nextRequest:%@, error:%@", response, nextRequest, error);
        
        // 注：当前方法不管成功还是失败，最终均会执行onLoadedChildren:方法
        
        if (!error)
        {
            if (response.value)
            {
                // 有返回数据
                [self onLoadedChildren:response.value];
            }
            
            if (nextRequest)
            {
                // 循环调用
                [self loadChildrenWithRequest:nextRequest];
            }
        }
        else if ([error isAuthenticationError])
        {
            NSLog(@"Onedrive获取内容失败:%@", [error description]);
            
            // 当前请求失败,则直接显示之前已获取的数据
            [self onLoadedChildren:@[]];
        }
    }];
}

// 已请求到数据，则使用列表进行显示...~!@
- (void)onLoadedChildren:(NSArray *)children
{
    // 1. 显示内容 <文本>
    dispatch_async(dispatch_get_main_queue(), ^(){
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        self.tableview.hidden = NO;
        [self.tableview reloadData];
        self.navView.btnMore.enabled = YES;
    });
    
    // 2. 保存新数据
    [children enumerateObjectsUsingBlock:^(ODItem *item, NSUInteger index, BOOL *stop){
        if (![self.itemsLookup containsObject:item.id])
        {
            // 将新请求到的ODItem对象的id保存在itemsLookup数组中...~!@
            [self.itemsLookup addObject:item.id];
        }
        // 将新请求到的数据保存在items字典中...~!@
        self.items[item.id] = item;
    }];
    
    // 3. 下载缩略图 <异步>
    [self loadThumbnails:children];
}

// 下载缩略图...<暂无缓存>
// 待优化
- (void)loadThumbnails:(NSArray *)items
{
    for (ODItem *item in items)
    {
        if ([item thumbnails:0])
        {
            // 若当前ODItem对象有缩略图,则开始下载
            [[[[[[self.client drive] items:item.id] thumbnails:@"0"] small] contentRequest] downloadWithCompletion:^(NSURL *location, NSURLResponse *response, NSError *error) {
                if (!error)
                {
                    // 将当前ODItem的缩略图保存在thumbnails字典中...~!@
                    self.thumbnails[item.id] = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        // 每下载完一张缩略图,便刷新一次
                        [self.tableview reloadData];
                    });
                }
                else
                {
                    NSLog(@"当前缩略图下载失败<id:%@>", item.id);
                }
            }];
        }
    }   // for
}

// 按指定索引获取对应的ODItem对象
- (ODItem *)itemForIndex:(NSIndexPath *)indexPath
{
    NSString *itemId = self.itemsLookup[indexPath.row];
    return self.items[itemId];
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
    return [self.itemsLookup count];
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
    
    // 显示内容
    ODItem *item = [self itemForIndex:indexPath];
    [cell configWithData:item];
    
    // 判断当前item有无缩略图
    if (self.thumbnails[item.id])
    {
        UIImage *image = self.thumbnails[item.id];
        cell.imgviewType.image = image;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 点击查看
    __block ODItem *item = [self itemForIndex:indexPath];
    
    if (item.folder)
    {
        // 文件夹
        
        // 查看文件夹详情
        OnedriveSubPathViewController *subVC = [[OnedriveSubPathViewController alloc] initWithNibName:@"OnedriveSubPathViewController" bundle:nil];
        subVC.currentItem = item;
        subVC.client = self.client;
        [self.navigationController pushViewController:subVC animated:YES];
    }
    else if ([item.file.mimeType isEqualToString:@"text/plain"])
    {
        // 文本
        
        [[[[self.client drive] items:item.id] contentRequest] downloadWithCompletion:^(NSURL *filePath, NSURLResponse *response, NSError *error){
            if (!error)
            {
                NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *newFilePath = [documentPath stringByAppendingPathComponent:item.name];
                [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:newFilePath] error:nil];
                
                ODXTextViewController *txtVC = [[ODXTextViewController alloc] initWithNibName:@"ODXTextViewController" bundle:nil];
                [txtVC setItemSaveCompletion:^(ODItem *newItem){
                    if (newItem)
                    {
                        if (![self.itemsLookup containsObject:newItem.id])
                        {
                            [self.itemsLookup addObject:newItem.id];
                        }
                        self.items[newItem.id] = newItem;
                        
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            [self.tableview reloadData];
                        });
                    }
                }];
                
                txtVC.title = item.name;
                txtVC.item = item;
                txtVC.client = self.client;
                txtVC.filePath = newFilePath;
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [super.navigationController pushViewController:txtVC animated:YES];
                });
            }
            else
            {
                NSLog(@"Onedrive下载失败:%@", [error description]);
            }
        }];
    }
    else
    {
        // 非文件夹和文本文件
        
        // 目前只支持下载图片
        NSString *strName = item.name;
        NSArray *arrayTemp = [strName componentsSeparatedByString:@"."];
        if (arrayTemp != nil && arrayTemp.count >= 2)
        {
            NSString *strFormat = [arrayTemp lastObject];
            LogDebug(@"file format:%@", strFormat);
            
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
                // 查看图片详情
                OnedriveDetailViewController *detailVC = [[OnedriveDetailViewController alloc] initWithNibName:@"OnedriveDetailViewController" bundle:nil];
                detailVC.item = item;
                detailVC.client = self.client;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            else
            {
                // 其它
                //[self toast:@"仅支持图片查看"];
                
                NSString *strValue = locatizedString(@"cloud_image_only");
                [self toast:strValue];
            }
        }
        else
        {
            // 其它
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
            // image名称
            NSString *fileName = [imgPath lastPathComponent];
            NSLog(@"fileName:%@", fileName);
            
            // 开始加载...~!@
            NSString *struploading = locatizedString(@"uploading");
            [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:struploading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
            self.navView.btnMore.enabled = NO;
            
            // 获取当前目录<根目录>
            [[[[self.client drive] items:@"root"] request] getWithCompletion:^(ODItem *item, NSError *error){
                
                //Returns an ODItem object or an error if there was one
                if (!error)
                {
                    // 上传
                    [ODXActionController uploadFileWithParent:item client:self.client viewController:self path:[NSURL URLWithString:imgPath] completionHandler:^(ODItem *response, NSError *error) {

                        if (!error)
                        {
                            NSLog(@"上传成功");

                            // 刷新
                            [self refreshCurrentDir];
                            
//                            dispatch_async(dispatch_get_main_queue(), ^(){
//                                [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
//                                self.navView.btnMore.enabled = YES;
//                            });
                        }
                        else
                        {
                            NSLog(@"上传失败:%@", [error description]);
                            
                            dispatch_async(dispatch_get_main_queue(), ^(){
                                [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
                                self.navView.btnMore.enabled = YES;
                            });
                        }
                        
                    }];
                    
                }
                else
                {
                    NSLog(@"获取根目录失败:%@", [error description]);
                    
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
                        self.navView.btnMore.enabled = YES;
                    });
                }
                
            }];
        }
        else
        {
            //
        }
    }
}


#pragma mark - Refresh

- (void)refreshCurrentDir
{
    if (!self.client)
    {
        self.client = [ODClient loadCurrentClient];
    }
    
    // 获取当前目录
    NSString *itemId = (self.currentItem) ? self.currentItem.id : @"root";
    ODChildrenCollectionRequest *childrenRequest = [[[[self.client drive] items:itemId] children] request];
    
    // https://api.onedrive.com/v1.0/drive/items/root/children
    
    NSLog(@"%@", [self.client serviceFlags][@"NoThumbnails"]);
    
    if (![self.client serviceFlags][@"NoThumbnails"])
    {
        [childrenRequest expand:@"thumbnails"];
        
        // baseURL:https://api.onedrive.com/v1.0
        // https://api.onedrive.com/v1.0/drive/items/root/children
    }
    
    [self loadChildrenWithRequest:childrenRequest];
}


@end
