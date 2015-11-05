//
//  RecordTypeViewController.h
//  CamClaim
//
//  Created by 夏志勇 on 15/9/8.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//  发票分类显示界面

#import <UIKit/UIKit.h>

// 只取前4种状态
typedef NS_ENUM(NSInteger, typeClaimRecord) {
    typeClaimRecordPending = 0,     // 待定
    typeClaimRecordApproving,       // 审核中
    typeClaimRecordApproved,        // 审核通过
    typeClaimRecordRejected,        // 被拒
    typeClaimRecordCancel,          // 取消
    typeClaimRecordOther = -1       // 其它
};

@interface RecordTypeViewController : BaseViewController

@property typeClaimRecord claimType;

@end
