/**
 * Copyright (c) 2009 Alex Fajkowski, Apparent Logic LLC
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

#import <UIKit/UIKit.h>

/**
 * Convenience methods to help with resizing images retrieved from the 
 * ObjectiveFlickr library.
 */
@interface UIImage (Utils)

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIImage *)imageWithPathForResource:(NSString *)name ofType:(NSString *)exth;
- (UIImage *)rescaleImageToSize:(CGSize)size;
- (UIImage *)cropImageToRect:(CGRect)cropRect;
- (UIImage *)clipImageInRect:(CGRect)rect;
- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox;
- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark --
#pragma mark --  ========================图片预处理========================

// 灰度
- (UIImage *)imageGrayProcess;
// 二值化
- (UIImage *)imageBinaryConvert;


@end