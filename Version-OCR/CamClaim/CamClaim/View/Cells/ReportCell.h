//
//  ReportCell.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/18.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  报表列表cell

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *lblDate;
@property (nonatomic, weak) IBOutlet UILabel *lblTime;
@property (nonatomic, weak) IBOutlet UILabel *lblType;
@property (nonatomic, weak) IBOutlet UILabel *lblReimbursement; // 退还、补偿、报销
@property (nonatomic, weak) IBOutlet UILabel *lblIncome;        //
@property (nonatomic, weak) IBOutlet UILabel *lblBalance;       //

@end
