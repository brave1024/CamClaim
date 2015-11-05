//
//  AppDelegate.h
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/4.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ABPadLockScreenViewController.h"
#import "ABPadLockScreenSetupViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, ABPadLockScreenViewControllerDelegate, ABPadLockScreenSetupViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navVC;
@property (copy, nonatomic) NSString *thePin;
@property BOOL isLogin; // 判断是否正在登录中  YES-自动登录进行中 NO-自动登录操作完成

@property (copy, nonatomic) NSString *dropboxUserId;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// 设置pincode
- (void)setPinCode;

@end

