//
//  BindingViewController.m
//  CamClaim
//
//  Created by 夏志勇 on 15/9/16.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "BindingViewController.h"
#import "BindingCell.h"
#import <ShareSDK/ShareSDK.h>

@interface BindingViewController () <UITableViewDataSource, UITableViewDelegate, BindingCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *arrayList;

@end

@implementation BindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.lblTitle.text = @"Binding";
    
    self.navView.lblTitle.hidden = NO;
    self.navView.imgLogo.hidden = YES;
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
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

// 返回
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark -

- (NSMutableArray *)arrayList
{
    if (_arrayList == nil)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"BindingList" ofType:@"plist"];
        _arrayList = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    }
    
    return _arrayList;
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"settingCell";
    BindingCell *cell = (BindingCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [BindingCell cellFromNib];
        cell.delegate = self;
    }
    
    NSDictionary *dic = self.arrayList[indexPath.row];
    [cell configWithData:dic];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BindingCell *cell = (BindingCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self userBindingAction:cell];
    
//    NSDictionary *dic = self.arrayList[indexPath.row];
//    NSString *strSelector = dic[@"selectorForJump"];
//    if (strSelector != nil && strSelector.length > 0)
//    {
//        //SEL selector = NSSelectorFromString(strSelector);
//        //[self performSelector:selector withObject:nil];
//        
//        // 消除警告: iOS PerformSelector may cause a leak because its selector is unknown
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [self performSelector:NSSelectorFromString(strSelector) withObject:nil];
//#pragma clang diagnostic pop
//    }
//    else
//    {
//        //
//    }
}


#pragma mark - BindingCellDelegate

// 用户绑定or解绑
// 解绑需弹框让用户确认...
- (void)userBindingAction:(id)cell
{
    BindingCell *myCell = (BindingCell *)cell;
    NSIndexPath *indexpath = [self.tableview indexPathForCell:myCell];
    
    NSDictionary *dic = self.arrayList[indexpath.row];
    
    UserManager *userManager = [UserManager sharedInstance];
    NSString *key = dic[@"cellid"];
    
    // 判断指定第三方平台是否已绑定
    if ([key isEqualToString:@"facebook"] == YES)
    {
        if (userManager.userInfo.facebook_open_id != nil && userManager.userInfo.facebook_open_id.length > 0)
        {
            // 已绑定
            NSLog(@"facebook已绑定,需解绑");
            
        }
        else
        {
            // 未绑定
            NSLog(@"facebook未绑定,需绑定");
            
            [self jointLoginByFacebook];
        }
    }
    else if ([key isEqualToString:@"wechat"] == YES)
    {
        if (userManager.userInfo.open_id != nil && userManager.userInfo.open_id.length > 0)
        {
            // 已绑定
            NSLog(@"wechat已绑定,需解绑");
            
        }
        else
        {
            // 未绑定
            NSLog(@"wechat未绑定,需绑定");
            
            [self jointLoginByWechat];
        }
    }
    else if ([key isEqualToString:@"linkedin"] == YES)
    {
        if (userManager.userInfo.linkeid_open_id != nil && userManager.userInfo.linkeid_open_id.length > 0)
        {
            // 已绑定
            NSLog(@"linkedin已绑定,需解绑");
            
        }
        else
        {
            // 未绑定
            NSLog(@"linkedin未绑定,需绑定");
            
            [self jointLoginByLinkedIn];
        }
    }
}


#pragma mark - Third Part Login

- (void)jointLoginByWechat
{
    [ShareSDK getUserInfoWithType:ShareTypeWeixiTimeline
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSString *uId = [userInfo uid];
                                   NSString *uName = [userInfo nickname];
                                   NSString *uIcon = [userInfo profileImage];
                                   
                                   // userId:o3af9jrHFLTdL7XEoMND_lO-1ZdM, userName:夏志勇, userIcon:http://wx.qlogo.cn/mmopen/ajNVdqHZLLBGYibwThTiaBuicKdf8QxYywlQACMXn7ymiaahtp3SCGAIFicDZyXzicSGAvJhkTFNIKX0M1BuFErjcJBw/0
                                   NSLog(@"userId:%@, userName:%@, userIcon:%@", uId, uName, uIcon);
                                   
                                   // 后台根据userId来判断当前用户是否已注册(or 已授权)
                                   // 1. 若已注册（存在当前用户id）,则直接登录（返回个人信息）
                                   // 2. 若未注册（不存在当前用户id）,则后台随机生成一个账号密码,并返回个人信息
                                   [self beginJointLogin:uId withIcon:uIcon withType:0];
                               }
                               
                           }];
}

- (void)jointLoginByFacebook
{
    [ShareSDK getUserInfoWithType:ShareTypeFacebook
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSString *uId = [userInfo uid];
                                   NSString *uName = [userInfo nickname];
                                   NSString *uIcon = [userInfo profileImage];
                                   
                                   // userId:139894183016041, userName:夏志勇, userIcon:https://fbcdn-profile-a.akamaihd.net/hprofile-ak-xfp1/v/t1.0-1/p50x50/11863357_139877969684329_5840938970745603927_n.jpg?oh=0546cfe6f7c19535ee8d5eec4ff114d0&oe=5641F15F&__gda__=1448199481_eaec8f5408485f0d481bf1119df93941
                                   NSLog(@"userId:%@, userName:%@, userIcon:%@", uId, uName, uIcon);
                                   
                                   // 后台根据userId来判断当前用户是否已注册(or 已授权)
                                   // 1. 若已注册（存在当前用户id）,则直接登录（返回个人信息）
                                   // 2. 若未注册（不存在当前用户id）,则后台随机生成一个账号密码,并返回个人信息
                                   [self beginJointLogin:uId withIcon:uIcon withType:1];
                               }
                               
                           }];
}

- (void)jointLoginByLinkedIn
{
    [ShareSDK getUserInfoWithType:ShareTypeLinkedIn
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result)
                               {
                                   NSString *uId = [userInfo uid];
                                   NSString *uName = [userInfo nickname];
                                   NSString *uIcon = [userInfo profileImage];
                                   
                                   // userId:lo8tPh01Id, userName:夏志勇, userIcon:https://media.licdn.com/mpr/mprx/0_PumCn_vbpLkiDPcSvs4CZ_UbpKNCDG9Tven2P9hbJA4ie-LSyj4CZ6cbUFclItX8Ke4Cg5NFKnF_m6UjV0wYYBvIznFGm6TSp0wTvn86OB-mkrsAKmjfzGmcvij-F69yvyfm-kLNssC
                                   NSLog(@"userId:%@, userName:%@, userIcon:%@", uId, uName, uIcon);
                                   
                                   // 后台根据userId来判断当前用户是否已注册(or 已授权)
                                   // 1. 若已注册（存在当前用户id）,则直接登录（返回个人信息）
                                   // 2. 若未注册（不存在当前用户id）,则后台随机生成一个账号密码,并返回个人信息
                                   [self beginJointLogin:uId withIcon:uIcon withType:2];
                               }
                               
                           }];
}

// 将当前指定第三方平台与用户账号进行绑定...
- (void)beginJointLogin:(NSString *)userId withIcon:(NSString *)icon withType:(int)type
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    [InterfaceManager userAccountBind:userId pic:icon withType:type completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
             
                /*
                {
                    "data": {
                        "bossstatus": 0,
                        "city": "武汉",
                        "company": "酷控科技",
                        "createtime": "2015/09/11 12:33:01",
                        "department": "无线研发部",
                        "email": "110381582@qq.com",
                        "facebook_open_id": null,
                        "id": 54,
                        "img": "http://wx.qlogo.cn/mmopen/ajNVdqHZLLBGYibwThTiaBuicKdf8QxYywlQACMXn7ymiaZgT0VtVGjNpkX35WDNNwBIib5e1eXgk3icLofBV4ibnQl4Q/0",
                        "linkeid_open_id": null,
                        "name": "terry",
                        "nickname": "Terry",
                        "open_id": "o3af9jrHFLTdL7XEoMND_lO-1ZdM",
                        "phone": "18507103285",
                        "pwd": "d93a5def7511da3d0f2d171d9c344e91",
                        "realname": "夏志勇",
                        "type": 1,
                        "zhiwei": "经理"
                    },
                    "message": "更新成功",
                    "status": 1,
                    "total": 0
                }
                */
                
                /*
                {
                    "data": {
                        "bossstatus": 0,
                        "city": "武汉",
                        "company": "酷控科技",
                        "createtime": "2015/09/11 12:33:01",
                        "department": "无线研发部",
                        "email": "110381582@qq.com",
                        "facebook_open_id": null,
                        "id": 54,
                        "img": "https://media.licdn.com/mpr/mprx/0_PumCn_vbpLkiDPcSvs4CZ_UbpKNCDG9Tven2P9hbJA4ie-LSyj4CZ6cbUFclItX8Ke4Cg5NFKnF_m6UjV0wYYBvIznFGm6TSp0wTvn86OB-mkrsAKmjfzGmcvij-F69yvyfm-kLNssC",
                        "linkeid_open_id": "gU_DLkrric",
                        "name": "terry",
                        "nickname": "Terry",
                        "open_id": "o3af9jrHFLTdL7XEoMND_lO-1ZdM",
                        "phone": "18507103285",
                        "pwd": "d93a5def7511da3d0f2d171d9c344e91",
                        "realname": "夏志勇",
                        "type": 1,
                        "zhiwei": "经理"
                    },
                    "message": "更新成功",
                    "status": 1,
                    "total": 0
                }
                */
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"绑定成功");
                    [self toast:@"绑定成功"];
                    
                    UserInfoModel *userInfo = response.data;
                    NSLog(@"data:%@", userInfo);
                    
                    // 更新第三方平台openid
                    UserManager *userManager = [UserManager sharedInstance];
                    //userManager.userInfo = userInfo;
                    userManager.userInfo.open_id = userInfo.open_id;
                    userManager.userInfo.facebook_open_id = userInfo.facebook_open_id;
                    userManager.userInfo.linkeid_open_id = userInfo.linkeid_open_id;
                    
                    [self.tableview reloadData];
                }
                else
                {
                    NSLog(@"绑定失败");
                    [self toast:@"绑定失败"];
                }
            }
        }
        else
        {
            if (message != nil && message.length > 0)
            {
                [self toast:message];
            }
            else
            {
                [self toast:@"绑定失败"];
            }
        }
        
    }];
}


@end
