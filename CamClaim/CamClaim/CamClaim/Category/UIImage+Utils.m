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

#import "UIImage+Utils.h"


@implementation UIImage (Utils)

// 十六进制的颜色值转为RGB格式的UIColor对象
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if ([cString length] < 6) {
        return [UIColor whiteColor];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor whiteColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

// 读取bundle内的图片
+ (UIImage *)imageWithPathForResource:(NSString *)name ofType:(NSString *)exth
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:exth];
    return [UIImage imageWithContentsOfFile:path];
}

// 缩放图片至指定尺寸
- (UIImage *)rescaleImageToSize:(CGSize)size
{
	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	[self drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
}

// 截取指定尺寸的图片...???
- (UIImage *)cropImageToRect:(CGRect)cropRect
{
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(cropRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, cropRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-cropRect.origin.x, cropRect.origin.y - (self.size.height - cropRect.size.height) , self.size.width, self.size.height);
	CGContextDrawImage(ctx, drawRect, self.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (CGSize)calculateNewSizeForCroppingBox:(CGSize)croppingBox
{
	// Make the shortest side be equivalent to the cropping box.
	CGFloat newHeight, newWidth;
	if (self.size.width < self.size.height) {
		newWidth = croppingBox.width;
		newHeight = (self.size.height / self.size.width) * croppingBox.width;
	} else {
		newHeight = croppingBox.height;
		newWidth = (self.size.width / self.size.height) *croppingBox.height;
	}
	
	return CGSizeMake(newWidth, newHeight);
}

- (UIImage *)cropCenterAndScaleImageToSize:(CGSize)cropSize
{
	UIImage *scaledImage = [self rescaleImageToSize:[self calculateNewSizeForCroppingBox:cropSize]];
	return [scaledImage cropImageToRect:CGRectMake((scaledImage.size.width-cropSize.width)/2, (scaledImage.size.height-cropSize.height)/2, cropSize.width, cropSize.height)];
}


#pragma mark --
#pragma mark --  ========================根据服务器返回的类型转化为图片========================

+ (NSString *)imageNameFromKey:(NSString *)key
{
    // 无图片时使用竞足替代
    //NSString *imageName = @"icon_football";
    NSString *imageName = nil;
    
    if (key == nil)
    {
        return imageName;
    }
    
    // 转小写
    NSString *fKey = key;
    fKey = [fKey lowercaseString];
    
    NSString *tKey = @"FootballMatchWinner";
    
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"FootballHandicapMatchWinner";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"FootballTotalGoals";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"FootballMatchScore";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"FootballHalfTimeFullTime";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"FootballMultiMarket";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"SclFootballAutoCombine";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"SclFootballAutoMulti";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    // 竞彩足球－冠亚军
    tKey = @"FootballCup";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"BasketballMatchWinner";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_basketball";
        return imageName;
    }
    
    tKey = @"BasketballHandicapMatchWinner";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_basketball";
        return imageName;
    }
    
    tKey = @"BasketballScoreDifference";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_basketball";
        return imageName;
    }
    
    tKey = @"BasketballTotalOverUnder";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_basketball";
        return imageName;
    }
    
    tKey = @"BasketballMultiMarket";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_basketball";
        return imageName;
    }
    
    tKey = @"Toto9";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_toto9";
        return imageName;
    }
    
    tKey = @"Toto14";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_toto14";
        return imageName;
    }
    
    tKey = @"Toto4";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"Toto6";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_football";
        return imageName;
    }
    
    tKey = @"SuperLotto";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_superlotto";
        
        return imageName;
    }
    
    tKey = @"SevenStar";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_seven_star";
        return imageName;
    }
    
    tKey = @"ElevenInFive";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon.png";
        return imageName;
    }
    
    tKey = @"P3";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_p3";
        return imageName;
    }
    
    tKey = @"P5";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_p5";
        return imageName;
    }
    
    tKey = @"ShuangSeQiu";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_ssq";
        return imageName;
    }
    
    tKey = @"3D";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey])
    {
        imageName = @"icon_lottery_3d";
        return imageName;
    }
    
#warning TODO:待更新图片...
    
    
    return imageName;
}

+ (NSString *)titleNameFromKey:(NSString *)key
{
    NSString *imageName = @"-";
    
    NSString *fKey = key;
    fKey = [fKey lowercaseString];
    
    NSString *tKey = @"FootballMatchWinner";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩足球-胜平负";
        return imageName;
    }
    
    tKey = @"FootballHandicapMatchWinner";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩足球-让球胜平负";
        return imageName;
    }
    
    tKey = @"FootballTotalGoals";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩足球-总进球";
        return imageName;
    }
    
    tKey = @"FootballMatchScore";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩足球-比分";
        return imageName;
    }
    
    tKey = @"FootballHalfTimeFullTime";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩足球-半全场";
        return imageName;
    }
    
    tKey = @"FootballMultiMarket";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩足球-混串";
        return imageName;
    }
    
    tKey = @"SclFootballAutoCombine";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩足球-单关配";
        return imageName;
    }
    tKey = @"SclFootballAutoMulti";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩足球-奖金优化";
        return imageName;
    }
    
    tKey = @"BasketballMatchWinner";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩篮球-胜负";
        return imageName;
    }
    
    tKey = @"BasketballHandicapMatchWinner";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩篮球-让分胜负";
        return imageName;
    }
    
    tKey = @"BasketballScoreDifference";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩篮球-胜分差";
        return imageName;
    }
    
    tKey = @"BasketballTotalOverUnder";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩篮球-大小分";
        return imageName;
    }
    
    tKey = @"BasketballMultiMarket";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"竞彩篮球-混串";
        return imageName;
    }
    
    tKey = @"Toto9";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"足彩-任九场";
        return imageName;
    }
    
    tKey = @"Toto14";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"足彩-14场";
        return imageName;
    }
    
    tKey = @"Toto4";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"足彩-进球彩";
        return imageName;
    }
    
    tKey = @"Toto6";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"足彩-半全场";
        return imageName;
    }
    
    tKey = @"SuperLotto";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"体彩-大乐透";
        return imageName;
    }
    
    tKey = @"SevenStar";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"体彩-七星彩";
        return imageName;
    }
    tKey = @"ElevenInFive";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"11选5";
        return imageName;
    }
    tKey = @"P3";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"体彩-排列3";
        return imageName;
    }
    tKey = @"P5";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"体彩-排列5";
        return imageName;
    }
    
    tKey = @"ShuangSeQiu";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"双色球";
        return imageName;
    }
    
    tKey = @"3D";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"福彩-3D";
        return imageName;
    }
    
    tKey = @"充值";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"充值";
        return imageName;
    }
    
    tKey = @"提款";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        imageName = @"提款";
        return imageName;
    }
    
    return imageName;
}

/*
 AdjustmentDeposit	人工充值
 AdjustmentWithdrawal	人工提款
 BonusActivation	彩金生效
 BonusAdjustment	人工派发彩金
 BonusCompleted	彩金领取
 BonusDeactivation	彩金失效
 BonusExpired	彩金过期
 BonusForfeited	放弃彩金
 BonusLost	彩金结束
 Deposit	充值
 DepositBonusMoney	使用彩金充值
 GiveBonus	彩金生效
 CancelWithdrawal	提款审核未通过
 PartialWithdrawalCancel	部分提款审核未通过
 Withdrawal	提款
 Comission	返点
 Unknown	未知
 
 
 
 Bet	投注
 BonusPayout	彩金支付
 BonusPayoutRollback	撤销彩金支付
 Cancel	撤单
 Win	中奖
 Rewards	加奖
 Rollback	撤单
 
 
 */
+ (NSString *)titleNameFromTransactionTypeKey:(NSString *)key
{
    NSString *result = @"未知";
    
    NSString *fKey = key;
    fKey = [fKey lowercaseString];
    
    NSString *tKey = @"";
    tKey = @"AdjustmentDeposit";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"人工充值";
        return result;
    }
    
    tKey = @"AdjustmentWithdrawal";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"人工提款";
        return result;
    }
    
    tKey = @"Bet";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"投注";
        return result;
    }
    
    tKey = @"BonusActivation";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"彩金生效";
        return result;
    }
    
    tKey = @"BonusAdjustment";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"人工派发奖金";
        return result;
    }
    
    tKey = @"BonusCompleted";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"彩金领取";
        return result;
    }
    
    tKey = @"BonusDeactivation";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"彩金失效";
        return result;
    }
    
    tKey = @"BonusExpired";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"彩金过期";
        return result;
    }
    
    tKey = @"BonusForfeited";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"放弃彩金";
        return result;
    }
    
    tKey = @"BonusLost";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"彩金结束";
        return result;
    }
    
    tKey = @"BonusPayout";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"彩金支付";
        return result;
    }
    
    tKey = @"BonusPayoutRollback";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"撤销彩金支付";
        return result;
    }
    
    tKey = @"Cancel";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"撤单";
        return result;
    }
    
    tKey = @"CancelWithdrawal";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"提款审核未通过";
        return result;
    }
    
    tKey = @"Comission";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"返点";
        return result;
    }
    
    tKey = @"Deposit";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"充值";
        return result;
    }
    
    tKey = @"DepositBonusMoney";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"使用彩金充值";
        return result;
    }
    
    tKey = @"GiveBonus";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"彩金生效";
        return result;
    }
    
    tKey = @"PartialWithdrawalCancel";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"部分提款审核未通过";
        return result;
    }
    
    tKey = @"Rewards";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"加奖";
        return result;
    }
    tKey = @"Rollback";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"撤单";
        return result;
    }
    
    tKey = @"Unknown";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"未知";
        return result;
    }
    
    tKey = @"Win";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"中奖";
        return result;
    }
    
    tKey = @"Withdrawal";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = @"提款";
        return result;
    }
    
    return result;
}

/*
 AdjustmentDeposit	人工充值
 Deposit	充值
 BonusAdjustment	人工派发彩金
 BonusActivation	彩金生效
 BonusCompleted	彩金领取
 DepositBonusMoney	使用彩金充值
 GiveBonus	彩金生效
 
 
 AdjustmentWithdrawal	人工提款
 BonusDeactivation	彩金失效
 BonusExpired	彩金过期
 BonusForfeited	放弃彩金
 BonusLost	彩金结束
 Withdrawal	提款
 
 CancelWithdrawal	提款审核未通过
 PartialWithdrawalCancel	部分提款审核未通过
 
 Comission	返点
 Unknown	未知
 
 /////=======
 
 Bet	投注
 BonusPayout	彩金支付
 BonusPayoutRollback	撤销彩金支付
 Cancel	撤单
 Win	中奖
 Rewards	加奖
 Rollback	撤单
 */
+ (NSString *)iconNameFromTransactionTypeKey:(NSString *)key
{
    NSString *result = @"news_icon_defalult.png";
    
    NSString *fKey = key;
    fKey = [fKey lowercaseString];
    
    NSString *tKey = @"";
    
    NSString *rechargeName = @"recharge.png";//充值
    NSString *withdrawalName = @"withdrawal.png";//提款
    NSString *bunosName = @"bunos.png";
    
    tKey = @"AdjustmentDeposit";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = rechargeName;
        return result;
    }
    
    tKey = @"AdjustmentWithdrawal";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = withdrawalName;
        return result;
    }
    
    tKey = @"Bet";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"投注";
        return result;
    }
    
    tKey = @"BonusActivation";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = bunosName;
        return result;
    }
    
    tKey = @"BonusAdjustment";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = bunosName;
        return result;
    }
    
    tKey = @"BonusCompleted";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = bunosName;
        return result;
    }
    
    tKey = @"BonusDeactivation";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = bunosName;
        return result;
    }
    
    tKey = @"BonusExpired";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = bunosName;
        return result;
    }
    
    tKey = @"BonusForfeited";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = bunosName;
        return result;
    }
    
    tKey = @"BonusLost";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = bunosName;
        return result;
    }
    
    tKey = @"BonusPayout";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"彩金支付";
        result = bunosName;
        return result;
    }
    
    tKey = @"BonusPayoutRollback";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"撤销彩金支付";
        result = bunosName;
        return result;
    }
    
    tKey = @"Cancel";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"撤单";
        return result;
    }
    
    tKey = @"CancelWithdrawal";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = withdrawalName;
        return result;
    }
    
    tKey = @"Comission";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"返点";
        return result;
    }
    
    tKey = @"Deposit";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = rechargeName;
        return result;
    }
    
    tKey = @"DepositBonusMoney";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = rechargeName;
        result = bunosName;
        return result;
    }
    
    tKey = @"GiveBonus";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = rechargeName;
        result = bunosName;
        return result;
    }
    
    tKey = @"PartialWithdrawalCancel";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = withdrawalName;
        return result;
    }
    
    tKey = @"Rewards";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"加奖";
        return result;
    }
    tKey = @"Rollback";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"撤单";
        return result;
    }
    
    tKey = @"Unknown";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"未知";
        return result;
    }
    
    tKey = @"Win";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        //        result = @"中奖";
        return result;
    }
    
    tKey = @"Withdrawal";
    tKey = [tKey lowercaseString];
    if ([fKey isEqualToString:tKey]) {
        result = withdrawalName;
        return result;
    }
    
    return result;
}


@end