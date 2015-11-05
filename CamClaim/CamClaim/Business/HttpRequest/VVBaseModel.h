//
//  VVBaseModel.h
//  VV
//
//  Created by yin pengfei on 14-9-2.
//  Copyright (c) 2014年 yin pengfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import "SVProgressHUD.h"

/**
 *  Request failure types
 */
typedef NS_ENUM(NSUInteger, VVRequestFailureType) {
    VVRequestFailureTypeNone                = 0,
    VVRequestFailureTypeNetworkConnection   = 1,    //网络连接异常
    VVRequestFailureTypeRequestFailed       = 2,    //请求失败
    VVRequestFailureTypeDataUnparsed        = 3,    //数据无法解析
    VVRequestFailureTypeStatusFailed        = 4,    //数据返回失败，状态为0
};

@protocol VVModelDelegate;
@interface VVBaseModel : NSObject
@property (nonatomic, assign) BOOL slideOutAnimationEnabled;

/**
 *  GET Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 */
- (void)getPath:(NSString *)aPath
     parameters:(NSDictionary *)aParamDic;

/**
 *  POST Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 */
- (void)postPath:(NSString *)aPath
      parameters:(NSDictionary *)aParamDic;

/**
 *  Regist POST Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 */
- (NSString *)postRegistPath:(NSString *)aPath
            parameters:(NSDictionary *)aParamDic;

/**
 *  Summary POST Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 */
- (NSMutableArray *)postSummaryPath:(NSString *)aPath
               parameters:(NSDictionary *)aParamDic;

/**
 *  Ocr POST Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 */
- (NSString *)postOcrPath:(NSString *)aPath
                  parameters:(NSDictionary *)aParamDic;

/**
 *  GET Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 *  @param  aSuccessBlock   request success block
 *  @param  aFailureBlock   request failure block
 */
- (void)getPath:(NSString *)aPath
     parameters:(NSDictionary *)aParamDic
        success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
        failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock;

/**
 *  POST Request
 *
 *  @param  aPath           request url path
 *  @param  aBodyBlock      post body block
 *  @param  aParamDic       params
 *  @param  aSuccessBlock   request success block
 *  @param  aFailureBlock   request failure block
 */
- (void)            postPath:(NSString *)aPath
                  parameters:(NSDictionary *)aParamDic
   constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))aBodyBlock
                     success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock;

/**
 *  POST Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 *  @param  aSuccessBlock   request success block
 *  @param  aFailureBlock   request failure block
 */
- (void)postPath:(NSString *)aPath
      parameters:(NSDictionary *)aParamDic
         success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
         failuer:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock;

/**
 *  Regist POST Request
 *
 *  @param  aPath           request url path
 *  @param  aBodyBlock      post body block
 *  @param  aParamDic       params
 *  @param  aSuccessBlock   request success block
 *  @param  aFailureBlock   request failure block
 */
- (void)            postRegistPath:(NSString *)aPath
                  parameters:(NSDictionary *)aParamDic
   constructingBodyWithBlock:(void(^)(id<AFMultipartFormData> formData))aBodyBlock
                     success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
                     failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock;

/**
 * Regist POST Request
 *
 *  @param  aPath           request url path
 *  @param  aParamDic       params
 *  @param  aSuccessBlock   request success block
 *  @param  aFailureBlock   request failure block
 */
- (void)postRegistPath:(NSString *)aPath
      parameters:(NSDictionary *)aParamDic
         success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))aSuccessBlock
         failuer:(void(^)(AFHTTPRequestOperation *operation, NSError *error))aFailureBlock;

/**
 *  Finish Http request
 */
- (void)didFinishRequest;

/**
 *  Finish and returned right data
 */
- (void)didFinishRightRequest;

/**
 *  Finish but returned wrong data
 */
- (void)didFinishWrongRequestWithMessage:(NSString *)aMessage;

/**
 * Destructor like dealloc, for arc [super dealloc] disabled
 */
- (void)destructor;

/**
 *  cancel operations
 */
+ (void)cancelRequest;

/**
 * cleaup cookies
 */
+ (void)cleanupCookies;

@property (nonatomic, strong) NSMutableDictionary *dataDictionary;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) id<VVModelDelegate> delegate;
@property (nonatomic, assign) NSUInteger modelTag;
@end

@protocol VVModelDelegate <NSObject>

@optional

/**
 *  Start request
 *
 *  @param  aModel      VVBaseModel object
 */
- (void)modelStartRequest:(VVBaseModel *)aModel;

/**
 *  Finished request
 *
 *  @param  aModel      VVBaseModel object
 *  @param  aData       response data
 */
- (void)model:(VVBaseModel *)aModel finishedRequestWithData:(id)aData;

/**
 *  Finished request
 *
 *  @param  aModel      VVBaseModel object
 */
- (void)modelFinishedRequest:(VVBaseModel *)aModel;

/**
 *  Finished request and get right returned data
 *
 *  @param  aModel      VVBaseModel object
 */
- (void)modelFinishedRightRequest:(VVBaseModel *)aModel data:(id)aData;

/**
 *  Finished request but get wrong returned data
 *
 *  @param  aModel      VVBaseModel object
 */
- (void)modelFinishedWrongRequest:(VVBaseModel *)aModel message:(NSString *)aMessage;

/**
 *  Failure request
 *
 *  @param  aModel      VVBaseModel object
 */
- (void)modelFailureRequest:(VVBaseModel *)aModel;

/**
 *  Failure request
 *
 *  @param  aModel      VVBaseModel object
 *  @param  aType       failure type
 */
- (void)model:(VVBaseModel *)aModel failureRequestWithType:(VVRequestFailureType)aType;

/**
 *  Failure request
 *  
 *  @param  aModel      VVBaseMode object
 *  @param  anError     NSerror object
 */
- (void)model:(VVBaseModel *)aModel failureError:(NSError *)anError;

@end


/**
- (void)modelStartRequest:(VVBaseModel *)aModel;

- (void)model:(VVBaseModel *)aModel finishedRequestWithData:(id)aData;

- (void)modelFinishedRequest:(VVBaseModel *)aModel;

- (void)modelFinishedRightRequest:(VVBaseModel *)aModel data:(id)aData;

- (void)modelFinishedWrongRequest:(VVBaseModel *)aModel message:(NSString *)aMessage;

- (void)modelFailureRequest:(VVBaseModel *)aModel;

- (void)model:(VVBaseModel *)aModel failureRequestWithType:(VVRequestFailureType)aType;

- (void)model:(VVBaseModel *)aModel failureError:(NSError *)anError;
*/