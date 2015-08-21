//
//  PGToast.m
//
//
//  Created by Xia Zhiyong on 12-12-21.
//  Copyright (c) 2012年 archermind. All rights reserved.
//

#import "PGToast.h"
#import <QuartzCore/QuartzCore.h>

static PGToast *pgToast = nil;

#define bottomPadding 108    // 50
#define startDisappearSecond 1.5    // toast显示时间
#define disappeartDurationSecond 1.0

const CGFloat pgToastTextPadding     = 5;
const CGFloat pgToastLabelWidth      = 260;
const CGFloat pgToastLabelHeight     = 150;

static int timeCount = 60 * disappeartDurationSecond;

@interface PGToast()

@property (nonatomic, copy) NSString *pgLabelText;
@property (nonatomic, retain) UILabel *pgLabel;

@property (nonatomic, assign) NSTimer *disappearTimer;
@property (nonatomic, assign) NSTimer *disappearingTimer;
@property (nonatomic, assign) int curToastState;       // 0:不显示;1:显示;2:正在消失

- (id)initWithText:(NSString *)text;    
- (void)deviceOrientationChange;

@end

@implementation PGToast

static UIInterfaceOrientation lastOrientation; 

@synthesize pgLabel;
@synthesize pgLabelText;

+ (PGToast *)shareInstant
{
    if (pgToast == nil) {
        pgToast = [[PGToast alloc] init];
        UILabel *lblPg = [[UILabel alloc]initWithFrame:CGRectZero];
        UIFont *font = [UIFont systemFontOfSize:13];
        lblPg.backgroundColor = [UIColor colorWithRed:32.0/255.0 green:33.0/255.0 blue:39.0/255.0 alpha:1.0f];
        //pgLabel.backgroundColor = [UIColor lightGrayColor];
        lblPg.textColor = [UIColor whiteColor];
        //pgLabel.textColor = [UIColor blackColor];
        lblPg.layer.cornerRadius = 5;
        lblPg.layer.borderWidth = 0;
        lblPg.layer.masksToBounds = YES;
        lblPg.numberOfLines = 0;
        lblPg.font = font;
        lblPg.textAlignment = NSTextAlignmentCenter;
        pgToast.pgLabel = lblPg;
//        [lblPg release];
        
        // add by Xia Zhiyong
        // 添加边框
        CALayer *layer = [pgToast.pgLabel layer];
        layer.borderColor = [[UIColor lightGrayColor] CGColor];
        layer.borderWidth = 1.0f;
        // 添加四个边阴影...(不适用于圆角view)
//    pgLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
//    pgLabel.layer.shadowOffset = CGSizeMake(2, 2);
//    pgLabel.layer.shadowOpacity = 0.5;
//    pgLabel.layer.shadowRadius = 2.0;
    }
    return pgToast;
}


- (id)initWithText:(NSString *)text
{

    if (self = [super init])
    {
        self.pgLabelText = text;
         
    }    
    return self;
}

//- (void)dealloc
//{
//
//    [pgLabel release];
//    [pgLabelText release];
//    [_disappearTimer release];
//    [_disappearingTimer release];
//    [super dealloc];
//}

+ (PGToast *)makeToast:(NSString *)text
{
    PGToast *pgToast = [PGToast shareInstant];
    pgToast.pgLabelText = text;
    return pgToast;
}

- (void)show
{
    if([self.pgLabelText isEqualToString:@""])
    {
        return;
    }
    
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize textSize = multilineTextSize(pgLabelText, font, CGSizeMake(pgToastLabelWidth, pgToastLabelHeight));
//    [pgLabelText sizeWithFont:font constrainedToSize:CGSizeMake(pgToastLabelWidth, pgToastLabelHeight)];
    [pgLabel setFrame:CGRectMake(0, 0, textSize.width + 2 * pgToastTextPadding, textSize.height + 2 * pgToastTextPadding)];

    pgLabel.text = self.pgLabelText;
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    if(self.pgLabel.superview != nil )
    {
        if (self.pgLabel.superview != window) {
            [self.pgLabel removeFromSuperview];
            [window addSubview:self.pgLabel];
        }
    } else {
        [window addSubview:self.pgLabel];
    }
    
    if (_curToastState == 2) {
        [_disappearingTimer invalidate];
        self.disappearingTimer = nil;
    } else if (_curToastState == 1) {
        [_disappearTimer invalidate];
        self.disappearTimer = nil;
    }
    _curToastState = 0;
    [self.pgLabel setAlpha:1];
    self.disappearTimer = [NSTimer scheduledTimerWithTimeInterval:startDisappearSecond target:self selector:@selector(toastDisappear:) userInfo:nil repeats:NO];
    _curToastState = 1;
    [self deviceOrientationChange];
    
}

- (void)deviceOrientationChange
{
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    //CGPoint point = window.center;
    //NSLog(@"point %f, %f", point.x, point.y);
    CGFloat centerX=0, centerY=0;
    CGFloat windowCenterX = window.center.x;
    CGFloat windowCenterY = window.center.y;
    CGFloat windowWidth = window.frame.size.width;
    CGFloat windowHeight = window.frame.size.height;
    
    UIInterfaceOrientation currentOrient= [UIApplication
                                           sharedApplication].statusBarOrientation;
    
    if (currentOrient == UIInterfaceOrientationLandscapeRight)
    {
        //NSLog(@"right ...");
        CGAffineTransform rotateTransform   = CGAffineTransformMakeRotation(M_PI/2);
        pgLabel.transform = CGAffineTransformConcat(window.transform, rotateTransform);
        centerX = bottomPadding;
        centerY = windowCenterY;
    }
    else if(currentOrient == UIInterfaceOrientationLandscapeLeft)
    {
        //NSLog(@"left ...");
        CGAffineTransform rotateTransform;
        if (lastOrientation == UIInterfaceOrientationPortrait) {
            rotateTransform   = CGAffineTransformMakeRotation(-M_PI/2);
        } else {
            rotateTransform   = CGAffineTransformMakeRotation(M_PI/2);
        }
        
        pgLabel.transform = CGAffineTransformConcat(pgLabel.transform, rotateTransform);
        centerX = windowWidth - bottomPadding;
        centerY = windowCenterY;
        
    }
    else if(currentOrient == UIInterfaceOrientationPortraitUpsideDown)
    {
        //NSLog(@"down ...");
        lastOrientation = currentOrient;
        pgLabel.transform = CGAffineTransformRotate(window.transform, -M_PI);
        
        centerX = windowCenterX;
        centerY = bottomPadding;
        
    }
    else if(currentOrient == UIInterfaceOrientationPortrait)
    {
        //NSLog(@"up ...");
        lastOrientation = currentOrient;
        pgLabel.transform = window.transform;
        centerX = windowCenterX;
        centerY = windowHeight - bottomPadding;
        
    }

    self.pgLabel.center = CGPointMake(centerX, centerY);
}

- (void)toastDisappear:(NSTimer *)timer
{
    [self.disappearTimer invalidate];
    self.disappearTimer = nil;
    timeCount = 60 * disappeartDurationSecond;
    self.disappearingTimer = [NSTimer scheduledTimerWithTimeInterval:1/60.0 target:self selector:@selector(startDisappear:) userInfo:nil repeats:YES];
    _curToastState = 2;
}

- (void)startDisappear:(NSTimer *)timer
{
    if (_curToastState == 0) {
        [self.disappearingTimer invalidate];
        self.disappearingTimer = nil;
        return;
    }
    if (timeCount >= 0)
    {
        [self.pgLabel setAlpha:timeCount/60.0];
        timeCount--;
    }
    else
    {
        [self.pgLabel removeFromSuperview];
        [self.disappearingTimer invalidate];
        self.disappearingTimer = nil;
        _curToastState = 0;
        timeCount = 60 * disappeartDurationSecond;
    }
}

@end
