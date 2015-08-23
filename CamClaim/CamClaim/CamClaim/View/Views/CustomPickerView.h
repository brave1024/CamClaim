//
//  CustomPickerView.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/23.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 设置委托
@protocol CustomPickerViewDelegate <NSObject>

@optional
- (void)valuechange:(NSDate *)mydate;

@end


@interface CustomPickerView : UIControl <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *kengdiepicker;
    NSDate *minimumDate;
    NSDate *maximumDate;
    NSDate *date;
    NSArray *month;
    NSMutableArray *year;
    NSInteger thismonth, thisyear;
}

@property(nonatomic, retain) UIPickerView *kengdiepicker;
@property(nonatomic, retain) NSDate *minimumDate;
@property(nonatomic, retain) NSDate *maximumDate;
@property(nonatomic, retain) NSDate *date;
@property(nonatomic, retain) NSArray *month;
@property(nonatomic, retain) NSMutableArray *year;
@property(nonatomic, assign)id<CustomPickerViewDelegate> delegate;

- (id)MyInit;
- (void)setdate:(NSDate *)mydate;

@end


