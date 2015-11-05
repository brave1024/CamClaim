//
//  CameraViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/7.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "CameraViewController.h"
// Tesseract
#import <TesseractOCR/TesseractOCR.h>
// OpenCV
#import <opencv2/opencv.hpp>


@interface CameraViewController () <IIViewDeckControllerDelegate, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *imgview;
@property (nonatomic, weak) IBOutlet UIView *viewResult;
@property (nonatomic, weak) IBOutlet UIButton *btnComfirm;

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@property (nonatomic, weak) IBOutlet UIView *viewOcr;
@property (nonatomic, weak) IBOutlet UIView *viewAction;
//@property (nonatomic, weak) IBOutlet UIView *viewOcrResult;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewOcr;
@property (nonatomic, weak) IBOutlet UITextView *txtviewOcr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewOcrResultHeight;

@property typeOcr ocrType;
@property (nonatomic, weak) IBOutlet UIButton *btnEnglish;
@property (nonatomic, weak) IBOutlet UIButton *btnSimChinese;
@property (nonatomic, weak) IBOutlet UIButton *btnTraChinese;
@property (nonatomic, weak) IBOutlet UIButton *btnStart;

- (IBAction)confirmAction:(id)sender;

//// 原图
//- (IBAction)restoreToOriginImage;
//// 二值化
//- (IBAction)binaryProcessImage;
//// 灰度
//- (IBAction)grayProcessImage;
//// 综合处理
//- (IBAction)totalPrecessImage;

- (IBAction)btnTouchAction:(id)sender;
- (IBAction)startOcr;

// OpenCV
- (cv::Mat)cvMatFromUIImage:(UIImage *)image;
- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
//
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image;
- (UIImage *)UIImageFromIplImage:(IplImage *)image;

- (UIImage *)grayImage:(UIImage *)srcimage;
- (UIImage *)binaryImage:(UIImage *)srcimage;

int  Otsu(unsigned char* pGrayImg , int iWidth , int iHeight);

// Test
- (IBAction)sharpenAction;
- (IBAction)grayAction;
- (IBAction)binaryAction;
- (IBAction)totalAction;

@end


@implementation CameraViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.navView.lblTitle.text = @"拍照";
//    self.navView.lblTitle.hidden = YES;
//    self.navView.imgLogo.hidden = NO;
//    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    self.navView.lblTitle.text = @"识别";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    // 选择照片
    self.navView.btnMore.hidden = NO;
    [self.navView.btnMore setImage:nil forState:UIControlStateNormal];
    [self.navView.btnMore setTitle:@"相册" forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.navView.btnMore setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.navView.btnMore.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    self.viewContent.backgroundColor = [UIColor blackColor];
    
//    UIImage *imgBtn = [UIImage imageNamed:@"btn_bg_submit"];
//    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
//    
//    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_bg_submit_press"];
//    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];

    UIImage *imgBtn = [UIImage imageNamed:@"new_btn_capture"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    
    [self.btnComfirm setBackgroundImage:imgBtn forState:UIControlStateNormal];
//    [self.btnComfirm setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnComfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnComfirm setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.imgview.image = self.imgCapture;
    
    UIImage *img = [UIImage imageNamed:@"confirm-center-new"];
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(14, 25, 14, 25)];
    
    UIImage *img_ = [UIImage imageNamed:@"confirm-center-new_pressed"];
    img_ = [img_ resizableImageWithCapInsets:UIEdgeInsetsMake(14, 25, 14, 25)];
    
    [self.btnEnglish setBackgroundImage:img forState:UIControlStateNormal];
    [self.btnEnglish setBackgroundImage:img_ forState:UIControlStateSelected];
    self.btnEnglish.selected = YES;
    
    [self.btnSimChinese setBackgroundImage:img forState:UIControlStateNormal];
    [self.btnSimChinese setBackgroundImage:img_ forState:UIControlStateSelected];
    self.btnSimChinese.selected = NO;
    
    [self.btnTraChinese setBackgroundImage:img forState:UIControlStateNormal];
    [self.btnTraChinese setBackgroundImage:img_ forState:UIControlStateSelected];
    self.btnTraChinese.selected = NO;
    
    [self.btnStart setBackgroundImage:img forState:UIControlStateNormal];
    [self.btnStart setBackgroundImage:img_ forState:UIControlStateHighlighted];
    
    self.viewAction.backgroundColor = [UIColor colorWithRed:(CGFloat)247/255 green:(CGFloat)97/255 blue:(CGFloat)29/255 alpha:1];
    
    // OCR...
    self.ocrType = typeOcrEnglish;  // 默认英文识别
    self.imgview.hidden = YES;
    self.viewResult.hidden = YES;
    
    self.viewOcrResultHeight.constant = 0;
    
    self.imgviewOcr.image = self.imgCapture;
    
    // Create a queue to perform recognition operations
    self.operationQueue = [[NSOperationQueue alloc] init];
    
//    // 为了防止线程阻塞，主线程卡死情况，此处需使用多线程进行处理
//    // 运用多线程时使用GCD
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        // 开始OCR识别...~!@
//        [self recognizeImageWithTesseract:self.imgCapture];
//
//        // 2.更新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kORCScaning mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
//            
//        });
//        
//    });
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
    [self dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

// 相册
- (void)moreAction
{
    // 初始化
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == YES)
    {
        picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    }
    [picker setDelegate:self];
    [picker setAllowsEditing:NO];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:nil] ;   // 进入照相界面
}


#pragma mark - BtnTouchAction

- (IBAction)confirmAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        //
        
        
    }];
}

//// 原图
//- (IBAction)restoreToOriginImage
//{
//    self.imgviewOcr.image = self.imgCapture;
//}
//
//// 灰度
//- (IBAction)grayProcessImage
//{
//    self.imgviewOcr.image = [self.imgCapture imageGrayProcess];
//}
//
//// 二值化
//- (IBAction)binaryProcessImage
//{
//    self.imgviewOcr.image = [self.imgCapture imageBinaryConvert];
//}
//
//// 综合处理
//- (IBAction)totalPrecessImage
//{
//    UIImage *imgGray = [self.imgCapture imageGrayProcess];
//    self.imgviewOcr.image = [imgGray imageBinaryConvert];
//}

// 选择语言
- (IBAction)btnTouchAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    switch (tag) {
        case kTag:
            if (self.btnEnglish.selected == YES)
            {
                //
            }
            else
            {
                self.btnEnglish.selected = YES;
                self.btnSimChinese.selected = NO;
                self.btnTraChinese.selected = NO;
                self.ocrType = typeOcrEnglish;
            }
            break;
        case kTag + 1:
            if (self.btnSimChinese.selected == YES)
            {
                //
            }
            else
            {
                self.btnEnglish.selected = NO;
                self.btnSimChinese.selected = YES;
                self.btnTraChinese.selected = NO;
                self.ocrType = typeOcrSimChinese;
            }
            break;
        case kTag + 2:
            if (self.btnTraChinese.selected == YES)
            {
                //
            }
            else
            {
                self.btnEnglish.selected = NO;
                self.btnSimChinese.selected = NO;
                self.btnTraChinese.selected = YES;
                self.ocrType = typeOcrTraChinese;
            }
            break;
        default:
            break;
    }
}

// 开始识别
- (IBAction)startOcr
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kORCScaning mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    // 开始OCR识别...~!@
    [self recognizeImageWithTesseract:self.imgCapture forLanguage:self.ocrType];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            //
            [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kORCScaning mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
            // 保存
            self.imgCapture = img;
            self.imgviewOcr.image = img;
            // 识别
            //[self recognizeImageWithTesseract:img];
            [self recognizeImageWithTesseract:img forLanguage:self.ocrType];
        });
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - OCR

- (void)recognizeImageWithTesseract:(UIImage *)image
{
    // Test
//    image = [UIImage imageNamed:@"eng06"];
//    image = [UIImage imageNamed:@"fra01"];
//    image = [UIImage imageNamed:@"image_sample.jpg"];
//    image = [UIImage imageNamed:@"well_scaned_page.jpg"];
//    image = [UIImage imageNamed:@"eng004"];
    
    // 图片预处理操作: 锐化、灰度处理、二值化、
    
    // 1.锐化
    UIImage *imgSharp = [image sharpen];
    
//    // 2.灰度处理
//    UIImage *imgGray = [image imageGrayProcess];
//    
//    // 3.二值化
//    UIImage *imgBinary = [imgGray imageBinaryConvert];

    // 2.灰度＋二值化 <二值化过程中包含了灰度处理，故不再分开进行操作>
    UIImage *imgBinary = [self binaryImage:imgSharp];

    // 3. 去噪
    
    
    // 4. 倾斜校正
    
    
    // 5. 图片分割
    
    
    // 最终用于ocr识别的图片
    UIImage *imgFinal = imgBinary;
    
    // Preprocess the image so Tesseract's recognition will be more accurate
    //UIImage *bwImage = [image g8_blackAndWhite];
    UIImage *bwImage = [imgFinal g8_blackAndWhite];
    
    // Animate a progress activity indicator
    //[self.activityIndicator startAnimating];
    
    // Display the preprocessed image to be recognized in the view
    //self.imageToRecognize.image = bwImage;
    
    // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
    // It is assumed that there is a .traineddata file for the language pack
    // you want Tesseract to use in the "tessdata" folder in the root of the
    // project AND that the "tessdata" folder is a referenced folder and NOT
    // a symbolic group in your project
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];   // 指定语言
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng+chi_sim+chi_tra"];   // 指定语言
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng+fra+chi_sim+chi_tra"];   // 指定语言
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"chi_sim+chi_tra"];   // 指定语言
    
    // Use the original Tesseract engine mode in performing the recognition
    // (see G8Constants.h) for other engine mode options
    operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;  // 最快最不精确...<中文不支持Cube模式>
    //operation.tesseract.engineMode = G8OCREngineModeCubeOnly;   // 较慢较精确
    //operation.tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;  // 最慢最精确
    
    // Let Tesseract automatically segment the page into blocks of text
    // based on its analysis (see G8Constants.h) for other page segmentation
    // mode options
    //operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;  // 自动页划分
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;  // 自动页划分
    
    // Optionally limit the time Tesseract should spend performing the
    // recognition
    operation.tesseract.maximumRecognitionTime = 60.0;
    
    // Set the delegate for the recognition to be this class
    // (see `progressImageRecognitionForTesseract` and
    // `shouldCancelImageRecognitionForTesseract` methods below)
    operation.delegate = self;
    
    // Optionally limit Tesseract's recognition to the following whitelist
    // and blacklist of characters
    //operation.tesseract.charWhitelist = @"01234";
    //operation.tesseract.charBlacklist = @"56789";
    
    // Set the image on which Tesseract should perform recognition
    operation.tesseract.image = bwImage;
    
    // Optionally limit the region in the image on which Tesseract should
    // perform recognition to a rectangle
    //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
    
    // Specify the function block that should be executed when Tesseract
    // finishes performing recognition on the image
    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
        
        // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
        NSLog(@"%@", recognizedText);
        
        // Remove the animated progress activity indicator
        //[self.activityIndicator stopAnimating];
        
        // Spawn an alert with the recognized text
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OCR Result"
//                                                        message:recognizedText
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 隐藏加载视图
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
            
            self.txtviewOcr.text = recognizedText;
            self.viewOcrResultHeight.constant = 166;
            
        });
        
    };
    
    // Finally, add the recognition operation to the queue
    [self.operationQueue addOperation:operation];
}

- (void)recognizeImageWithTesseract:(UIImage *)image forLanguage:(typeOcr)lang
{
    // 1.锐化
    UIImage *imgSharp = [image sharpen];
    
    // 2.灰度＋二值化 <二值化过程中包含了灰度处理，故不再分开进行操作>
    UIImage *imgBinary = [self binaryImage:imgSharp];
    
    // 3. 去噪
    
    
    // 4. 倾斜校正
    
    
    // 5. 图片分割
    
    
    // 最终用于ocr识别的图片
    UIImage *imgFinal = imgBinary;
    
    // Preprocess the image so Tesseract's recognition will be more accurate
    //UIImage *bwImage = [image g8_blackAndWhite];
    UIImage *bwImage = [imgFinal g8_blackAndWhite];
    
    // Animate a progress activity indicator
    //[self.activityIndicator startAnimating];
    
    // Display the preprocessed image to be recognized in the view
    //self.imageToRecognize.image = bwImage;
    
    // Create a new `G8RecognitionOperation` to perform the OCR asynchronously
    // It is assumed that there is a .traineddata file for the language pack
    // you want Tesseract to use in the "tessdata" folder in the root of the
    // project AND that the "tessdata" folder is a referenced folder and NOT
    // a symbolic group in your project
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng"];   // 指定语言
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng+chi_sim+chi_tra"];   // 指定语言
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"eng+fra+chi_sim+chi_tra"];   // 指定语言
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:@"chi_sim+chi_tra"];   // 指定语言
    
    // 指定语言
    NSString *strLanguage = @"eng";
    if (lang == typeOcrEnglish)
    {
        strLanguage = @"eng";
    }
    else if (lang == typeOcrSimChinese)
    {
        strLanguage = @"chi_sim";
    }
    else if (lang == typeOcrTraChinese)
    {
        strLanguage = @"chi_tra";
    }
    
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] initWithLanguage:strLanguage];   // 指定语言
    
    // Use the original Tesseract engine mode in performing the recognition
    // (see G8Constants.h) for other engine mode options
    //operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;  // 最快最不精确...<中文不支持Cube模式>
    //operation.tesseract.engineMode = G8OCREngineModeCubeOnly;   // 较慢较精确
    //operation.tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;  // 最慢最精确
    
    // 指定模式
    if (lang == typeOcrEnglish)
    {
        operation.tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    }
    else if (lang == typeOcrSimChinese)
    {
        operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    }
    else if (lang == typeOcrTraChinese)
    {
        operation.tesseract.engineMode = G8OCREngineModeTesseractOnly;
    }
    
    // Let Tesseract automatically segment the page into blocks of text
    // based on its analysis (see G8Constants.h) for other page segmentation
    // mode options
    //operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;  // 自动页划分
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAuto;  // 自动页划分
    
    // Optionally limit the time Tesseract should spend performing the
    // recognition
    operation.tesseract.maximumRecognitionTime = 60.0;
    
    // Set the delegate for the recognition to be this class
    // (see `progressImageRecognitionForTesseract` and
    // `shouldCancelImageRecognitionForTesseract` methods below)
    operation.delegate = self;
    
    // Optionally limit Tesseract's recognition to the following whitelist
    // and blacklist of characters
    //operation.tesseract.charWhitelist = @"01234";
    //operation.tesseract.charBlacklist = @"56789";
    
    // Set the image on which Tesseract should perform recognition
    operation.tesseract.image = bwImage;
    
    // Optionally limit the region in the image on which Tesseract should
    // perform recognition to a rectangle
    //operation.tesseract.rect = CGRectMake(20, 20, 100, 100);
    
    // Specify the function block that should be executed when Tesseract
    // finishes performing recognition on the image
    operation.recognitionCompleteBlock = ^(G8Tesseract *tesseract) {
        
        // Fetch the recognized text
        NSString *recognizedText = tesseract.recognizedText;
        NSLog(@"%@", recognizedText);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 隐藏加载视图
            [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
            
            self.txtviewOcr.text = recognizedText;
            self.viewOcrResultHeight.constant = 166;
            
            // 上传ocr结果
            [self userUploadOcrResult:recognizedText andImage:imgFinal];
        });
        
    };
    
    // Finally, add the recognition operation to the queue
    [self.operationQueue addOperation:operation];
}


#pragma mark - G8TesseractDelegate

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can observe the progress.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 */
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

/**
 *  This function is part of Tesseract's delegate. It will be called
 *  periodically as the recognition happens so you can cancel the recogntion
 *  prematurely if necessary.
 *
 *  @param tesseract The `G8Tesseract` object performing the recognition.
 *
 *  @return Whether or not to cancel the recognition.
 */
- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to cancel recognition prematurely
}


#pragma mark - OpenCV Method

// UIImage to cvMat
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

// CvMat to UIImage
- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // width
                                        cvMat.rows,                                     // height
                                        8,                                              // bits per component
                                        8 * cvMat.elemSize(),                           // bits per pixel
                                        cvMat.step[0],                                  // bytesPerRow
                                        colorSpace,                                     // colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,    // bitmap info
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // decode
                                        false,                                          // should interpolate
                                        kCGRenderingIntentDefault                       // intent
                                        );
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

// 由于OpenCV主要针对的是计算机视觉方面的处理，因此在函数库中，最重要的结构体是IplImage结构。
// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image
{
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocating the buffer for CGImage
    NSData *data = [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault);
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}


#pragma mark - Custom Method By OpenCV

// OSTU算法求出阈值
int Otsu(unsigned char* pGrayImg , int iWidth , int iHeight)
{
    if((pGrayImg==0)||(iWidth<=0)||(iHeight<=0))return -1;
    int ihist[256];
    int thresholdValue=0; // „–÷µ
    int n, n1, n2 ;
    double m1, m2, sum, csum, fmax, sb;
    int i,j,k;
    memset(ihist, 0, sizeof(ihist));
    n=iHeight*iWidth;
    sum = csum = 0.0;
    fmax = -1.0;
    n1 = 0;
    for(i=0; i < iHeight; i++)
    {
        for(j=0; j < iWidth; j++)
        {
            ihist[*pGrayImg]++;
            pGrayImg++;
        }
    }
    pGrayImg -= n;
    for (k=0; k <= 255; k++)
    {
        sum += (double) k * (double) ihist[k];
    }
    for (k=0; k <=255; k++)
    {
        n1 += ihist[k];
        if(n1==0)continue;
        n2 = n - n1;
        if(n2==0)break;
        csum += (double)k *ihist[k];
        m1 = csum/n1;
        m2 = (sum-csum)/n2;
        sb = (double) n1 *(double) n2 *(m1 - m2) * (m1 - m2);
        if (sb > fmax)
        {
            fmax = sb;
            thresholdValue = k;
        }
    }
    return(thresholdValue);
}

// 灰度
- (UIImage *)grayImage:(UIImage *)srcimage
{
    UIImage *resimage;
    
    //openCV二值化过程：
    
    /*
     //1.Src的UIImage ->  Src的IplImage
     IplImage* srcImage1 = [self CreateIplImageFromUIImage:srcimage];
     
     //2.设置Src的IplImage的ImageROI
     int width = srcImage1->width;
     int height = srcImage1->height;
     printf("图片大小%d,%d\n",width,height);
     
     
     // 分割矩形区域
     int x = 400;
     int y = 1100;
     int w = 1200;
     int h = 600;
     
     //cvSetImageROI:基于给定的矩形设置图像的ROI（感兴趣区域，region of interesting）
     cvSetImageROI(srcImage1, cvRect(x, y, w , h));
     
     //3.创建新的dstImage1的IplImage，并复制Src的IplImage
     IplImage* dstImage1 = cvCreateImage(cvSize(w, h), srcImage1->depth, srcImage1->nChannels);
     //cvCopy:如果输入输出数组中的一个是IplImage类型的话，其ROI和COI将被使用。
     cvCopy(srcImage1, dstImage1,0);
     //cvResetImageROI:释放基于给定的矩形设置图像的ROI（感兴趣区域，region of interesting）
     cvResetImageROI(srcImage1);
     
     resimage = [self UIImageFromIplImage:dstImage1];
     */
    
    //4.dstImage1的IplImage转换成cvMat形式的matImage
    cv::Mat matImage = [self cvMatFromUIImage:srcimage];
    
    cv::Mat matGrey;
    
    //5.cvtColor函数对matImage进行灰度处理
    //取得IplImage形式的灰度图像
    cv::cvtColor(matImage, matGrey, CV_BGR2GRAY);// 转换成灰色
    
    //6.使用灰度后的IplImage形式图像，用OSTU算法算阈值：threshold
    //IplImage grey = matGrey;
    
    resimage = [self UIImageFromCVMat:matGrey];
    
    /*
     unsigned char* dataImage = (unsigned char*)grey.imageData;
     int threshold = Otsu(dataImage, grey.width, grey.height);
     printf("阈值：%d\n",threshold);
     
     //7.利用阈值算得新的cvMat形式的图像
     cv::Mat matBinary;
     cv::threshold(matGrey, matBinary, threshold, 255, cv::THRESH_BINARY);
     
     //8.cvMat形式的图像转UIImage
     UIImage* image = [[UIImage alloc ]init];
     image = [self UIImageFromCVMat:matBinary];
     
     resimage = image;
     */
    
    return resimage;
}

// 二值化
- (UIImage *)binaryImage:(UIImage *)srcimage
{
    UIImage *resimage;
    
    //openCV二值化过程：
    
    /*
     //1.Src的UIImage ->  Src的IplImage
     IplImage* srcImage1 = [self CreateIplImageFromUIImage:srcimage];
     
     //2.设置Src的IplImage的ImageROI
     int width = srcImage1->width;
     int height = srcImage1->height;
     printf("图片大小%d,%d\n",width,height);
     //
     
     // 分割矩形区域
     int x = 400;
     int y = 1100;
     int w = 1200;
     int h = 600;
     
     //cvSetImageROI:基于给定的矩形设置图像的ROI（感兴趣区域，region of interesting）
     cvSetImageROI(srcImage1, cvRect(x, y, w , h));
     
     //3.创建新的dstImage1的IplImage，并复制Src的IplImage
     IplImage* dstImage1 = cvCreateImage(cvSize(w, h), srcImage1->depth, srcImage1->nChannels);
     //cvCopy:如果输入输出数组中的一个是IplImage类型的话，其ROI和COI将被使用。
     cvCopy(srcImage1, dstImage1,0);
     //cvResetImageROI:释放基于给定的矩形设置图像的ROI（感兴趣区域，region of interesting）
     cvResetImageROI(srcImage1);
     
     resimage = [self UIImageFromIplImage:dstImage1];
     */
    
    //4.dstImage1的IplImage转换成cvMat形式的matImage
    cv::Mat matImage = [self cvMatFromUIImage:srcimage];
    
    cv::Mat matGrey;
    
    //5.cvtColor函数对matImage进行灰度处理
    //取得IplImage形式的灰度图像
    cv::cvtColor(matImage, matGrey, CV_BGR2GRAY);// 转换成灰色
    
    //6.使用灰度后的IplImage形式图像，用OSTU算法算阈值：threshold
    IplImage grey = matGrey;
    unsigned char* dataImage = (unsigned char*)grey.imageData;
    int threshold = Otsu(dataImage, grey.width, grey.height);
    printf("阈值：%d\n", threshold);
    
    //7.利用阈值算得新的cvMat形式的图像
    cv::Mat matBinary;
    cv::threshold(matGrey, matBinary, threshold, 255, cv::THRESH_BINARY);
    
    //8.cvMat形式的图像转UIImage
    UIImage* image = [[UIImage alloc ]init];
    image = [self UIImageFromCVMat:matBinary];
    
    resimage = image;
    
    return resimage;
}


#pragma mark - Test

- (IBAction)sharpenAction
{
    self.imgviewOcr.image = [self.imgCapture sharpen];
}

- (IBAction)grayAction
{
    self.imgviewOcr.image = [self.imgCapture imageGrayProcess];
}

- (IBAction)binaryAction
{
    self.imgviewOcr.image = [self binaryImage:self.imgCapture];
}

- (IBAction)totalAction
{
    UIImage *imgSharp = [self.imgCapture sharpen];
    UIImage *imgBinary = [self binaryImage:imgSharp];
    self.imgviewOcr.image = imgBinary;
}


#pragma mark - HttpRequest

// 后台上传ocr图片及识别结果
- (void)userUploadOcrResult:(NSString *)result andImage:(UIImage *)img
{
    if (result != nil && result.length > 0)
    {
        // UIImage图片转成Base64字符串：
        UIImage *originImage = img;
        NSData *data = UIImageJPEGRepresentation(originImage, 1.0f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [InterfaceManager userUploadOCRImage:encodedImageStr withImageData:result completion:^(BOOL isSucceed, NSString *message, id data) {
            
            if (isSucceed == YES)
            {
                if (data != nil)
                {
                    NSLog(@"response:%@", data);
                    
                    // {"status":0,"message":"回传失败","data":null,"total":0}
                    
                    ResponseModel *response = (ResponseModel *)data;
                    if (response.status == 1)
                    {
                        NSLog(@"ocr上传成功");
                        //[self toast:@"ocr上传成功"];
                    }
                    else
                    {
                        NSLog(@"ocr上传失败");
                        //[self toast:@"ocr上传失败"];
                    }
                }
            }
            else
            {
                if (message != nil && message.length > 0)
                {
                    //[self toast:message];
                }
                else
                {
                    //[self toast:@"ocr上传失败"];
                }
            }
            
        }];
    }
}

@end
