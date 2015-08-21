//
//  RecordViewController.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15/8/18.
//  Copyright (c) 2015年 kufa88. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordCell.h"
#import "ClaimList.h"
#import "SubmitClaimViewController.h"

@interface RecordViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableview;
@property (nonatomic, weak) IBOutlet UIButton *btnNew;
@property (nonatomic, weak) IBOutlet UIButton *btnSearch;
@property (nonatomic, weak) IBOutlet UIButton *btnFill;

@property (nonatomic, weak) IBOutlet UIView *viewFunction;
@property (nonatomic, weak) IBOutlet UIView *viewFill;

@property (nonatomic, strong) NSMutableArray *arrayClaim;
@property (nonatomic, strong) AllClaimStatus *allClaimStatus;

- (IBAction)btnTouchAction:(id)sender;

@end

@implementation RecordViewController

#define kTag 100

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.viewContent.backgroundColor = [UIColor colorWithRed:(CGFloat)236/255 green:(CGFloat)237/255 blue:(CGFloat)239/255 alpha:1];
    
    //self.title = @"记录";
    
    self.navView.lblTitle.hidden = YES;
    self.navView.imgLogo.hidden = NO;
    
    // 当前导航栏左侧图标替换
    [self.navView.btnBack setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
    
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.backgroundView = nil;
    
    UIImage *imgBtn = [UIImage imageNamed:@"btn_bg_submit"];
    imgBtn = [imgBtn resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    UIImage *imgBtn_ = [UIImage imageNamed:@"btn_bg_submit_press"];
    imgBtn_ = [imgBtn_ resizableImageWithCapInsets:UIEdgeInsetsMake(18, 48, 18, 48)];
    
    [self.btnFill setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [self.btnFill setBackgroundImage:imgBtn_ forState:UIControlStateHighlighted];
    
    [self.btnFill setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnFill setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    self.viewFunction.backgroundColor = [UIColor colorWithRed:(CGFloat)245/255 green:(CGFloat)247/255 blue:(CGFloat)249/255 alpha:1];
    UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, 49, kScreenWidth, 1)];
    viewLine.backgroundColor = [UIColor colorWithRed:(CGFloat)217/255 green:(CGFloat)218/255 blue:(CGFloat)219/255 alpha:1];
    [self.viewFunction addSubview:viewLine];
    
    //self.viewFill.backgroundColor = [UIColor colorWithRed:(CGFloat)87/255 green:(CGFloat)129/255 blue:(CGFloat)254/255 alpha:1];
    
    [self initViewWithAutoLayout];
    
    [self settingLanguage];
    
    // 请求数据
    [self requestClaimList];
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

// 查看or隐藏菜单栏
- (void)backAction
{
    [self.viewDeckController toggleLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        // 点击按钮隐藏菜单栏后的动画
        [self.viewDeckController previewBounceView:IIViewDeckLeftSide toDistance:20.0f duration:0.6f numberOfBounces:2 dampingFactor:0.40f callDelegate:YES completion:^(IIViewDeckController *controller, BOOL success) {
            
        }];
    }];
}

// 
- (void)moreAction
{
    //
    
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


#pragma mark - Request

- (void)requestClaimList
{
    [MRProgressOverlayView showOverlayAddedTo:self.viewContent title:kLoading mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
    
    NSString *strMonth = [NSString stringWithFormat:@"%@/%@", @"2015", @"07"];
    
    [InterfaceManager getUserClaimByMonth:strMonth completion:^(BOOL isSucceed, NSString *message, id data) {
        
        [MRProgressOverlayView dismissOverlayForView:self.viewContent animated:YES];
        
        if (isSucceed == YES)
        {
            if (data != nil)
            {
                NSLog(@"response:%@", data);
                
                /*
                {
                    "data": [
                             {
                                 "canmoney": "0",
                                 "forusername": "lili",
                                 "gmoney": "0",
                                 "id": 0,
                                 "jd": null,
                                 "jiyu": "0",
                                 "location": "沙田",
                                 "message": null,
                                 "pfile": null,
                                 "status": null,
                                 "typeid": "餐飲費",
                                 "useinfo": "eat",
                                 "userid": 0,
                                 "usetime": "2015/07",
                                 "wd": null
                             },
                             {
                                 "canmoney": "0",
                                 "forusername": "lili",
                                 "gmoney": "0",
                                 "id": 0,
                                 "jd": null,
                                 "jiyu": "0",
                                 "location": "沙田",
                                 "message": null,
                                 "pfile": null,
                                 "status": null,
                                 "typeid": "餐飲費",
                                 "useinfo": "using eat",
                                 "userid": 0,
                                 "usetime": "2015/07",
                                 "wd": null
                             },
                             {
                                 "canmoney": "0",
                                 "forusername": "asdasd",
                                 "gmoney": "0",
                                 "id": 0,
                                 "jd": null,
                                 "jiyu": "0",
                                 "location": "dasda",
                                 "message": null,
                                 "pfile": null,
                                 "status": null,
                                 "typeid": "交通費",
                                 "useinfo": "dasdas",
                                 "userid": 0,
                                 "usetime": "2015/07",
                                 "wd": null
                             }
                             ],
                    "message": "获取数据成功",
                    "status": 1,
                    "total": 0
                }
                */
                
                ResponseModel *response = (ResponseModel *)data;
                if (response.status == 1)
                {
                    NSLog(@"获取发票记录成功");
                    
                    if (self.arrayClaim == nil)
                    {
                        self.arrayClaim = [[NSMutableArray alloc] init];
                    }
                    else
                    {
                        [self.arrayClaim removeAllObjects];
                    }
                    
                    NSArray *arrayData = response.data;
                    for (NSDictionary *dic in arrayData)
                    {
                        NSError *error = nil;
                        ClaimItem *item = [[ClaimItem alloc] initWithDictionary:dic error:&error];
                        if (item != nil && error == nil)
                        {
                            [self.arrayClaim addObject:item];
                        }
                    }
                    
                    if (self.arrayClaim.count > 0)
                    {
                        // 显示
                        [self.tableview reloadData];
                    }
                    else
                    {
                        NSLog(@"暂无发票记录数据");
                        //[self toast:@"暂无发票记录数据"];
                    }
                }
                else
                {
                    NSLog(@"暂无发票记录数据");
                    //[self toast:@"暂无发票记录数据"];
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
                //[self toast:@"获取发票记录失败"];
            }
        }
        
    }];
}


#pragma mark - BtnTouchAction

- (IBAction)btnTouchAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSInteger tag = btn.tag;
    
    if (tag == kTag)
    {
        // 新记录
        
        
    }
    else if (tag == kTag + 1)
    {
        // 搜索
        
        
    }
    else if (tag == kTag + 2)
    {
        // 填写发票
        
        SubmitClaimViewController *submitVC = [[SubmitClaimViewController alloc] initWithNibName:@"SubmitClaimViewController" bundle:nil];
        [self.navigationController pushViewController:submitVC animated:YES];
    }
    else
    {
        //
    }
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayClaim.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellRecord";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [RecordCell cellFromNib];
    }
    
    ClaimItem *item = self.arrayClaim[indexPath.row];
    [cell configWithData:item];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
}


@end
