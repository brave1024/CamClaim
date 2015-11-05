//
//  CKHttpClient.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15-8-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "CKHttpClient.h"

static dispatch_once_t onceToken;
static CKHttpClient *_sharedClient = nil;

@implementation CKHttpClient


+ (instancetype)defaultHttpClient
{
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[CKHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
//        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    LogDebug(@"3G网络已连接");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    LogDebug(@"WiFi网络已连接");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    LogDebug(@"网络连接失败");
                    break;
                    
                default:
                    break;
            }
        }];
        
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    // json
//    // 发送json数据
//    _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
//    // 响应json数据
//    _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 非json <默认配置>
//    _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
//    _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];

//    [_sharedClient.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
//    [_sharedClient.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
//    _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    return _sharedClient;
}


#pragma mark -

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters
{
    NSParameterAssert(method);
    
    if (!path) {
        path = @"";
    }
    
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.baseURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:method];
    
    return request;
}

//
- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method
                                     path:(NSString *)path
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    NSString *pathToBeMatched = [[[self requestWithMethod:(method ?: @"GET") path:path parameters:nil] URL] path];
#pragma clang diagnostic pop
    
    for (NSOperation *operation in [self.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
#if 0
        BOOL hasMatchingMethod = !method || [method isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        
        if (hasMatchingMethod && hasMatchingPath) {
            [operation cancel];
        }
#else
        // 判断接口名是否相同
        NSString *path = [[[(AFHTTPRequestOperation *)operation request] URL] path];
        if ([pathToBeMatched isEqualToString:path]) {
            LogDebug(@"path %@",path);
            [operation cancel];
            break;
        }
#endif
    }
}

- (void)cancelRequest:(NSString *)action
{
    NSString *pathUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, action];
    [[CKHttpClient defaultHttpClient] cancelAllHTTPOperationsWithMethod:@"GET" path:pathUrl];
    [[CKHttpClient defaultHttpClient] cancelAllHTTPOperationsWithMethod:@"POST" path:pathUrl];
}

- (void)cancelAllRequest
{
    [[CKHttpClient defaultHttpClient].operationQueue cancelAllOperations];
}


@end
