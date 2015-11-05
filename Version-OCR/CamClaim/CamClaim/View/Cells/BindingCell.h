//
//  BindingCell.h
//  CamClaim
//
//  Created by 夏志勇 on 15/9/17.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BindingCellDelegate <NSObject>

- (void)userBindingAction:(id)cell;

@end


@interface BindingCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *imgviewPic;
@property (nonatomic, weak) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UIImageView *imgviewArrow;
@property (nonatomic, weak) IBOutlet UIButton *btnBind;

@property (nonatomic, assign) id<BindingCellDelegate> delegate;

- (IBAction)btnTouchAciton;

@end
