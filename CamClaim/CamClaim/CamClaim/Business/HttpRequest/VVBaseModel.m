//
//  VVBaseModel.m
//  VV
//
//  Created by yin pengfei on 14-9-2.
//  Copyright (c) 2014年 yin pengfei. All rights reserved.
//

#import "VVBaseModel.h"
//#import "LeftMenuViewController.h"

@interface VVBaseModel ()

/**
 *  Start Http request
 */
- (void)didStartRequest;

/**
 * Failure Http request
 */
- (void)didFailureRequest;

@end


@implementation VVBaseModel
@synthesize dataDictionary = _dataDictionary;
@synthesize dataArray = _dataArray;
@synthesize delegate;
@synthesize modelTag;

- (void)dealloc
{
    [self destructor];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.modelTag = 0;
    }
    return self;
}

- (void)finishedWithData
{
    @synchronized(self.dataDictionary)
    {
        if ([self.dataDictionary objectForKey:@"status"] &&
            ![[self.dataDictionary objectForKey:@"status"] isEqual:[NSNull null]])
        {
            if ([[self.dataDictionary objectForKey:@"status"] isKindOfClass:[NSNumber class]])
            {
                int status = [[self.dataDictionary objectForKey:@"status"] intValue];
                if (status == 0)
                {
                    NSString *message = [NSString stringWithFormat:@"%@", [self.dataDictionary objectForKey:@"message"]];
                    [self didFinishWrongRequestWithMessage:message];
                    if ([self.delegate respondsToSelector:@selector(modelFinishedWrongRequest:message:)])
                    {
                        [self.delegate modelFinishedWrongRequest:self message:message];
                    }
                }
                else if (status == 1)
                {
                    [self didFinishRightRequest];
                    if ([self.delegate respondsToSelector:@selector(modelFinishedRightRequest:data:)])
                    {
                        [self.delegate modelFinishedRightRequest:self data:[self.dataDictionary objectForKey:@"data"]];
                    }
                }
            }
        }
    }
}

/**
 *  GET Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 */
- (void)getPath:(NSString *)aPath
     parameters:(NSDictionary *)aParamDic
{
    [self getPath:aPath parameters:aParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)postPath:(NSString *)aPath
      parameters:(NSDictionary *)aParamDic
{
    [self postPath:aPath parameters:aParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Success...~!@");
        
        if (responseObject != nil)
        {
            NSLog(@"responseObject:%@", responseObject);
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"])
            {
//                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
//                                                                         bundle: nil];
//                UIViewController *vc =[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
//                [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
//                                                                         withSlideOutAnimation:self.slideOutAnimationEnabled
//                                                                                 andCompletion:nil];
            }
            else
            {
//                NSDictionary *dic = (NSDictionary *) responseObject;
//                //[[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"data"] forKey:@"userinfo"];
//                if ([dic objectForKey:@"data"])
//                {
//                    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                    
//                    // [defaults setObject:[dic objectForKey:@"data"] forKey:@"userinfo"];
//                    NSDictionary *data=[dic objectForKey:@"data"];
//                    NSArray *keys = [data allKeys];
//                    
//                    int length = [keys count];
//                    
//                    for (int i = 0; i < length;i++)
//                    {
//                        id key = [keys objectAtIndex:i];
//                        NSString* skey =key;
//                        
//                        id obj = [data objectForKey:key];
//                        
//                        if([skey isEqualToString:@"id"])
//                        {
//                            [[NSUserDefaults standardUserDefaults] setObject:obj==nil ? @"" : (NSString*)obj forKey:@"userid"];
//                            break;
//                        }
//                        NSLog(@"%@", obj);
//                    }
//                    
//                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
//                                                                             bundle: nil];
//                    UIViewController *vc =[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeViewController"];
//                    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
//                                                                             withSlideOutAnimation:self.slideOutAnimationEnabled
//                                                                                     andCompletion:nil];
//                }
            }
        }
        
    } failuer:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
        NSLog(@"Failed...~!@");
    }];
}


- (void)getPath:(NSString *)aPath
     parameters:(NSDictionary *)aParamDic
        success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
        failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock
{
    [self didStartRequest];
    
    AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
    
    [httpRequestOperationManager GET:[aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:aParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(model:finishedRequestWithData:)])
        {
            [self.delegate model:self finishedRequestWithData:responseObject];
        }
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = (NSDictionary *) responseObject;
            @synchronized(self.dataDictionary)
            {
                [self.dataDictionary removeAllObjects];
                [self.dataDictionary addEntriesFromDictionary:dic];
            }
            
            [self didFinishRequest];
            
            if ([self.delegate respondsToSelector:@selector(modelFinishedRequest:)])
            {
                [self.delegate modelFinishedRequest:self];
            }
            
            [self finishedWithData];
        }
        else
        {
            [self didFailureRequest];
            //数据解析失败，无法解析json数据
            if ([self.delegate respondsToSelector:@selector(model:failureRequestWithType:)])
            {
                [self.delegate model:self failureRequestWithType:VVRequestFailureTypeDataUnparsed];
            }
        }
        
        if (aSuccessBlock)
        {
            aSuccessBlock(operation, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self didFailureRequest];
        
        if ([self.delegate respondsToSelector:@selector(model:failureError:)])
        {
            [self.delegate model:self failureError:error];
        }
        
        if (aFailureBlock)
        {
            aFailureBlock(operation, error);
        }
    }];
}

- (void)            postPath:(NSString *)aPath
                  parameters:(NSDictionary *)aParamDic
   constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))aBodyBlock
                     success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock
{
    [self didStartRequest];
    
    AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
    [httpRequestOperationManager POST:[aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:aParamDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (aBodyBlock)
        {
            aBodyBlock(formData);
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(model:finishedRequestWithData:)])
        {
            [self.delegate model:self finishedRequestWithData:responseObject];
        }
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = (NSDictionary *) responseObject;
            @synchronized(self.dataDictionary)
            {
                [self.dataDictionary removeAllObjects];
                [self.dataDictionary addEntriesFromDictionary:dic];
            }
            
            [self didFinishRequest];
            
            if ([self.delegate respondsToSelector:@selector(modelFinishedRequest:)])
            {
                [self.delegate modelFinishedRequest:self];
            }
            
            [self finishedWithData];
            
        }
        else
        {
            [self didFailureRequest];
            //数据解析失败，无法解析json数据
            if ([self.delegate respondsToSelector:@selector(model:failureRequestWithType:)])
            {
                [self.delegate model:self failureRequestWithType:VVRequestFailureTypeDataUnparsed];
            }
        }
        
        if (aSuccessBlock)
        {
            aSuccessBlock(operation, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self didFailureRequest];
        
        if ([self.delegate respondsToSelector:@selector(model:failureError:)])
        {
            [self.delegate model:self failureError:error];
        }
        
        if (aFailureBlock)
        {
            aFailureBlock(operation, error);
        }
    }];
}

- (void)postPath:(NSString *)aPath
      parameters:(NSDictionary *)aParamDic
         success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
         failuer:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock
{
    [self didStartRequest];
    
    AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
    //httpRequestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
   // httpRequestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [httpRequestOperationManager POST:[aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:aParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(model:finishedRequestWithData:)])
        {
            [self.delegate model:self finishedRequestWithData:responseObject];
        }
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = (NSDictionary *) responseObject;
           // NSArray *keys = [dic allKeys];
            //
            //int length = [keys count];
            //
            //for (int i = 0; i < length;i++){
               
             //   id key = [keys objectAtIndex:i];
               // NSString* skey =key;
                
                //id obj = [dic objectForKey:key];
              //  if([skey compare:(@"userId")])
               // {
                                  //     break;
                //}
            //}
            
            @synchronized(self.dataDictionary)
            {
               [self.dataDictionary removeAllObjects];
                [self.dataDictionary addEntriesFromDictionary:dic];
            }
            
            [self didFinishRequest];
            
            if ([self.delegate respondsToSelector:@selector(modelFinishedRequest:)])
            {
                [self.delegate modelFinishedRequest:self];
            }
            
            [self finishedWithData];
            
        }
        else
        {
            [self didFailureRequest];
            
            //数据解析失败，无法解析json数据
            if ([self.delegate respondsToSelector:@selector(model:failureRequestWithType:)])
            {
                [self.delegate model:self failureRequestWithType:VVRequestFailureTypeDataUnparsed];
            }
        }
        
        if (aSuccessBlock)
        {
            aSuccessBlock(operation, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self didFailureRequest];
        
        if ([self.delegate respondsToSelector:@selector(model:failureError:)])
        {
            [self.delegate model:self failureError:error];
        }
        
        if (aFailureBlock)
        {
            aFailureBlock(operation, error);
        }
    }];
}

- (NSMutableArray *)postSummaryPath:(NSString *)aPath
                  parameters:(NSDictionary *)aParamDic
{
    __block NSMutableArray * result ;
    
    [self postPath:aPath parameters:aParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(responseObject!=nil)
        {
            NSDictionary *dic = (NSDictionary *) responseObject;
            //[[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"data"] forKey:@"userinfo"];
            if ([dic objectForKey:@"status"])
            {
                // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                // [defaults setObject:[dic objectForKey:@"data"] forKey:@"userinfo"];
                
                id obj = [dic objectForKey:@"status"];
                NSString *statuss=(NSString*)obj;
                int intString = [statuss intValue];
                
                if (intString==1)
                {
                    id obj = [dic objectForKey:@"data"];
                     NSArray *keys = obj;
                    result = [NSMutableArray arrayWithCapacity:keys.count];
                    
                    for (int i=0;i<keys.count;i++)
                    {
                        id objs=keys[i];
                        
                        NSArray *objkeys = [objs allKeys];
                        int length = [objkeys count];
                       
                        NSMutableDictionary * resultrow = [NSMutableDictionary dictionaryWithCapacity:7];
                            for (int i = 0; i < length;i++)
                            {
                                    id key = [objkeys objectAtIndex:i];
                                    NSString* skey =key;
                    
                                    // did objd = [objs objectForKey:skey];
                                    if([skey isEqualToString:@"typeid"])
                                        {
                                            [resultrow setObject:[objs objectForKey:@"typeid"] forKey:@"typeid"];
                                        }
                                if([skey isEqualToString:@"canmoney"])//支出
                                {
                                   [resultrow setObject:[objs objectForKey:@"canmoney"] forKey:@"canmoney"];
                                }
                                if([skey isEqualToString:@"gmoney"])//收入
                                {
                                    [resultrow setObject:[objs objectForKey:@"gmoney"] forKey:@"gmoney"];
                                }
                                if([skey isEqualToString:@"location"])//地点
                                {
                                    [resultrow setObject:[objs objectForKey:@"location"] forKey:@"location"];
                                }
                                if([skey isEqualToString:@"userinfo"])//用途
                                {
                                    [resultrow setObject:[objs objectForKey:@"userinfo"] forKey:@"userinfo"];
                                }
                                if([skey isEqualToString:@"usertime"])//时间
                                {
                                    [resultrow setObject:[objs objectForKey:@"usertime"] forKey:@"usertime"];
                                }
                                if([skey isEqualToString:@"forusername"])//入账目标客户
                                {
                                [resultrow setObject:[objs objectForKey:@"forusername"] forKey:@"forusername"];
                                }
                            }
                        
                        [result addObject:resultrow];
                    }
                }
                else
                {
                    //id mess = [dic objectForKey:@"message"];
                    //NSString *message=(NSString*)mess;
                    //[SVProgressHUD showInfoWithStatus:message];
                    
                    result=nil;
                }
            }
        }
        
    } failuer:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    return result;
}

- (NSString *)postRegistPath:(NSString *)aPath
      parameters:(NSDictionary *)aParamDic
{
    __block NSString * result;
    
    [self postRegistPath:aPath parameters:aParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject!=nil)
        {
                NSDictionary *dic = (NSDictionary *) responseObject;
                //[[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"data"] forKey:@"userinfo"];
                if([dic objectForKey:@"status"])
                {
                    // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    
                    // [defaults setObject:[dic objectForKey:@"data"] forKey:@"userinfo"];
                   
                    id obj = [dic objectForKey:@"status"];
                    NSString *statuss=(NSString*)obj;
                    int intString = [statuss intValue];
                    
                    if (intString==1)
                    {
                        id mess = [dic objectForKey:@"message"];
                        NSString *message=(NSString*)mess;
                        //[SVProgressHUD showInfoWithStatus:message];
                        result=message;
                    }
                    else
                    {
                        id mess = [dic objectForKey:@"message"];
                        NSString *message=(NSString*)mess;
                        //[SVProgressHUD showInfoWithStatus:message];
                        result=message;
                    }
                }
        }
        
    } failuer:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
    
    return result;
}

- (void)            postRegistPath:(NSString *)aPath
                  parameters:(NSDictionary *)aParamDic
   constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))aBodyBlock
                     success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock
{
    [self didStartRequest];
    
    AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
    [httpRequestOperationManager POST:[aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:aParamDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (aBodyBlock)
        {
            aBodyBlock(formData);
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(model:finishedRequestWithData:)])
        {
            [self.delegate model:self finishedRequestWithData:responseObject];
        }
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            
            NSDictionary *dic = (NSDictionary *) responseObject;
            @synchronized(self.dataDictionary)
            {
                [self.dataDictionary removeAllObjects];
                [self.dataDictionary addEntriesFromDictionary:dic];
            }
            
            [self didFinishRequest];
            
            if ([self.delegate respondsToSelector:@selector(modelFinishedRequest:)])
            {
                [self.delegate modelFinishedRequest:self];
            }
            
            [self finishedWithData];
            
        }
        else
        {
            [self didFailureRequest];
            
            //数据解析失败，无法解析json数据
            if ([self.delegate respondsToSelector:@selector(model:failureRequestWithType:)])
            {
                [self.delegate model:self failureRequestWithType:VVRequestFailureTypeDataUnparsed];
            }
        }
        
        if (aSuccessBlock)
        {
            aSuccessBlock(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self didFailureRequest];
        
        if ([self.delegate respondsToSelector:@selector(model:failureError:)])
        {
            [self.delegate model:self failureError:error];
        }
        
        if (aFailureBlock)
        {
            aFailureBlock(operation, error);
        }
    }];
}

- (void)postRegistPath:(NSString *)aPath
      parameters:(NSDictionary *)aParamDic
         success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
         failuer:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock
{
    [self didStartRequest];
    
    AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
    //httpRequestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // httpRequestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [httpRequestOperationManager POST:[aPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:aParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([self.delegate respondsToSelector:@selector(model:finishedRequestWithData:)])
        {
            [self.delegate model:self finishedRequestWithData:responseObject];
        }
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = (NSDictionary *) responseObject;
            // NSArray *keys = [dic allKeys];
            //
            //int length = [keys count];
            //
            //for (int i = 0; i < length;i++){
            
            //   id key = [keys objectAtIndex:i];
            // NSString* skey =key;
            
            //id obj = [dic objectForKey:key];
            //  if([skey compare:(@"userId")])
            // {
            //     break;
            //}
            //}
            
            @synchronized(self.dataDictionary)
            {
                [self.dataDictionary removeAllObjects];
                [self.dataDictionary addEntriesFromDictionary:dic];
            }
            
            [self didFinishRequest];
            
            if ([self.delegate respondsToSelector:@selector(modelFinishedRequest:)])
            {
                [self.delegate modelFinishedRequest:self];
            }
            
            [self finishedWithData];
        }
        else
        {
            [self didFailureRequest];
            //数据解析失败，无法解析json数据
            if ([self.delegate respondsToSelector:@selector(model:failureRequestWithType:)])
            {
                [self.delegate model:self failureRequestWithType:VVRequestFailureTypeDataUnparsed];
            }
        }
        
        if (aSuccessBlock)
        {
            aSuccessBlock(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self didFailureRequest];
        
        if ([self.delegate respondsToSelector:@selector(model:failureError:)])
        {
            [self.delegate model:self failureError:error];
        }
        
        if (aFailureBlock)
        {
            aFailureBlock(operation, error);
        }
    }];
}

- (NSString *)postOcrPath:(NSString *)aPath
                  parameters:(NSDictionary *)aParamDic
{
    __block NSString * result ;
    
    [self postPath:aPath parameters:aParamDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject!=nil)
        {
            NSDictionary *dic = (NSDictionary *) responseObject;
            //[[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"data"] forKey:@"userinfo"];
            if ([dic objectForKey:@"status"])
            {
                // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                // [defaults setObject:[dic objectForKey:@"data"] forKey:@"userinfo"];
                
                id obj = [dic objectForKey:@"status"];
                NSString *statuss=(NSString*)obj;
                int intString = [statuss intValue];
                if (intString==1)
                {
                    id mess = [dic objectForKey:@"message"];
                    NSString *message=(NSString*)mess;
                    //[SVProgressHUD showInfoWithStatus:message];
                    result=message;
                }
                else
                {
                    id mess = [dic objectForKey:@"message"];
                    NSString *message=(NSString*)mess;
                    //[SVProgressHUD showInfoWithStatus:message];
                    result=message;
                }
            }
        }
        
    } failuer:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
    
    return result;
}

- (void)didStartRequest
{
    if ([self.delegate respondsToSelector:@selector(modelStartRequest:)])
    {
        [self.delegate modelStartRequest:self];
    }
    
    //[SVProgressHUD show];
}

- (void)didFinishRequest
{
//    [SVProgressHUD dismiss];
}

- (void)didFailureRequest
{
    if ([self.delegate respondsToSelector:@selector(modelFailureRequest:)])
    {
        [self.delegate modelFailureRequest:self];
    }
    
    //[SVProgressHUD dismiss];
}

- (void)didFinishRightRequest
{
    //[SVProgressHUD dismiss];
}

- (void)didFinishWrongRequestWithMessage:(NSString *)aMessage
{
    //[SVProgressHUD showErrorWithStatus:aMessage];
//    [SVProgressHUD dismiss];
}


#pragma mark - 
#pragma mark - propertyMethods

- (NSMutableDictionary *)dataDictionary
{
    if (!_dataDictionary)
    {
        _dataDictionary = [[NSMutableDictionary alloc] init];
    }
    return _dataDictionary;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)destructor
{
    self.dataDictionary = nil;
    self.dataArray = nil;
}

+ (void)cancelRequest
{
    AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
    [httpRequestOperationManager.operationQueue cancelAllOperations];
}

+ (void)cleanupCookies
{
//    AFHTTPRequestOperationManager *httpRequestOperationManager = [AFHTTPRequestOperationManager manager];
//    httpRequestOperationManager.requestSerializer
//    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray *cookies = [cookieStorage cookies];
//    for (id cookie in cookies)
//    {
//        NSLog(@"cookie = %@", cookie);
//    }
    
//    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:kServerAddress]];NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];[[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefaultsCookie];
//    
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsCookie];if([cookiesdata length]) {    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];    NSHTTPCookie *cookie;    for (cookie in cookies) {        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];    }}

}


@end
