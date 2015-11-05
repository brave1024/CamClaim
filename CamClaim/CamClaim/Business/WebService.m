//
//  InterfaceManager.m
//  CamClaim
//
//  Created by Xia Zhiyong on 15-8-5.
//  Copyright (c) 2014年 kufa88. All rights reserved.
//

#import "WebService.h"
#import "CKHttpClient.h"

@implementation WebService


#pragma mark - 发起GET请求

/*
// GET Request
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
[manager GET:@"http://example.com/resources.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
}];
*/

// Get
+ (void)startGetRequest:(NSString *)action
                   body:(NSDictionary *)body
            returnClass:(Class)returnClass
                success:(RequestSuccessBlock)sblock
                failure:(RequestFailureBlock)fblock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // 拼接请求url
    NSString *pathUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, action];
    LogDebug(@"...>>>...requestUrl:%@\n", pathUrl);
    LogDebug(@"...>>>...requestData:%@\n", body);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[pathUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        LogDebug(@"\n-----------------------------------\n...<statusCode:%ld>...<responseString:> \n%@\n----------------------------", (long)operation.response.statusCode, operation.responseString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // 请求正常,返回有数据时,还需要检查状态码...
        if (operation.response.statusCode != 200 && operation.response.statusCode != 201)
        {
            NSError *err = nil;
            ResponseErrorModel *errorModel = [[ResponseErrorModel alloc] initWithData:operation.responseData error:&err];
            // 回调
            fblock(operation, nil, errorModel);
            return;
        }
        
        // json解析
        NSError *error;
        ResponseModel *responseObj = [[ResponseModel alloc] init];
        responseObj.status = 1;
        responseObj.message = @"请求成功";
        //responseObj.data = [[returnClass alloc] initWithString:operation.responseString error:&error];
        if (returnClass != nil)
        {
            responseObj.data = [[returnClass alloc] initWithDictionary:responseObject error:&error];
        }
        else
        {
            responseObj.data = responseObject;
        }
        
        // 回调
        sblock(operation, responseObj);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LogDebug(@"Error: %@", error);
        LogDebug(@"...<statusCode:%ld>...<responseString:%@>\n", (long)operation.response.statusCode, operation.responseString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // json解析
        NSError *err = nil;
        ResponseErrorModel *errorModel = [[ResponseErrorModel alloc] initWithData:operation.responseData error:&err];
        
        // 回调
        fblock(operation, error, errorModel);
    }];
    
    /*
    CKHttpClient *httpClient = [CKHttpClient defaultHttpClient];
    [httpClient GET:pathUrl parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
          LogDebug(@"\n-----------------------------------\n...<statusCode:%ld>...<responseString:> \n%@\n----------------------------", (long)operation.response.statusCode, operation.responseString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // 请求正常,返回有数据时,还需要检查状态码...
        if (operation.response.statusCode != 200 && operation.response.statusCode != 201)
        {
            NSError *err = nil;
            ResponseErrorModel *errorModel = [[ResponseErrorModel alloc] initWithData:operation.responseData error:&err];
            // 回调
            fblock(operation, nil, errorModel);
            return;
        }
        
        // json解析
        NSError *error;
        ResponseModel *responseObj = [[ResponseModel alloc] init];
        responseObj.status = 1;
        responseObj.message = @"请求成功";
        //responseObj.data = [[returnClass alloc] initWithString:operation.responseString error:&error];
        if (returnClass != nil)
        {
            responseObj.data = [[returnClass alloc] initWithDictionary:responseObject error:&error];
        }
        else
        {
            responseObj.data = responseObject;
        }
        // 回调
        sblock(operation, responseObj);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        LogDebug(@"Error: %@", error);
        LogDebug(@"...<statusCode:%ld>...<responseString:%@>\n", (long)operation.response.statusCode, operation.responseString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // json解析
        NSError *err = nil;
        ResponseErrorModel *errorModel = [[ResponseErrorModel alloc] initWithData:operation.responseData error:&err];
        // 回调
        fblock(operation, error, errorModel);
    }];
    */
}


#pragma mark - 发起POST请求

/*
// POST Request
AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
NSDictionary *parameters = @{@"foo": @"bar"};
[manager POST:@"http://example.com/resources.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
}];
*/

// Post
+ (void)startPostRequest:(NSString *)action
                    body:(NSDictionary *)body
             returnClass:(Class)returnClass
                 success:(RequestSuccessBlock)sblock
                 failure:(RequestFailureBlock)fblock
{
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    // 拼接请求url
    NSString *pathUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, action];
    LogDebug(@"...>>>...requestUrl:%@\n", pathUrl);
    LogDebug(@"\nrequest body start ----------------\
          \n%@\n\
          request body end ----------------\n", [body convertToJsonString]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; // 设置相应内容类型
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager POST:[pathUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSLog(@"JSON: %@", responseObject);
        LogDebug(@"\n-----------------------------------\n...<statusCode:%ld>...<responseString:> \n%@\n----------------------------", (long)operation.response.statusCode, operation.responseString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // 请求正常,返回有数据时,还需要检查状态码...
        // 正常情况下不会走此逻辑...若返回状态码为500,则直接走请求失败逻辑...
        if (operation.response.statusCode != 200 && operation.response.statusCode != 201)
        {
            NSError *err = nil;
            ResponseErrorModel *errorModel = [[ResponseErrorModel alloc] initWithData:operation.responseData error:&err];
            // 回调...<并不为网络原因>
            fblock(operation, nil, errorModel);
            return;
        }
        
        // 全部数据...~!@
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        // json解析
        NSError *error;
        ResponseModel *responseObj = [[ResponseModel alloc] init];
        //responseObj.status = 1;
        //responseObj.message = @"请求成功";
        //responseObj.data = [[returnClass alloc] initWithString:operation.responseString error:&error];
        responseObj.status = [dic[@"status"] intValue];
        responseObj.total = [dic[@"total"] intValue];
        responseObj.message = dic[@"message"];
        
        id data = dic[@"data"];
        if ([data isKindOfClass:[NSArray class]] == YES)
        {
            // 数组
            responseObj.data = (NSArray *)data;
        }
        else if ([data isKindOfClass:[NSString class]] == YES)
        {
            // 字符串
            responseObj.data = (NSString *)data;
        }
        else if ([data isKindOfClass:[NSDictionary class]] == YES)
        {
            // 字典
            // 最终数据...~!@
            NSDictionary *dicData = dic[@"data"];
            
            if (returnClass != nil)
            {
                // 解析过程加try catch...
                @try {
                    //responseObj.data = [[returnClass alloc] initWithDictionary:responseObject error:&error];
                    responseObj.data = [[returnClass alloc] initWithDictionary:dicData error:&error];
                }
                @catch (NSException *exception) {
                    LogDebug(@"exception:%@", [exception description]);
                    //responseObj.data = nil;
                    responseObj.data = dicData;
                }
                @finally {
                    //
                }
            }
            else
            {
                //responseObj.data = responseObject;
                responseObj.data = dicData;
            }
        }
        
        // 并不是所有的data都是字典...~!@
//        // 最终数据...~!@
//        NSDictionary *dicData = dic[@"data"];
//        
//        if (returnClass != nil)
//        {
//            // 解析过程加try catch...
//            @try {
//                //responseObj.data = [[returnClass alloc] initWithDictionary:responseObject error:&error];
//                responseObj.data = [[returnClass alloc] initWithDictionary:dicData error:&error];
//            }
//            @catch (NSException *exception) {
//                LogDebug(@"exception:%@", [exception description]);
//                //responseObj.data = nil;
//                responseObj.data = dicData;
//            }
//            @finally {
//                //
//            }
//        }
//        else
//        {
//            //responseObj.data = responseObject;
//            responseObj.data = dicData;
//        }
        
        // 回调
        sblock(operation, responseObj);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //LogDebug(@"Error: %@", error);
        // 1. 网络断开 ...<statusCode:0>...<responseString:(null)>
        // 2. statusCode:500 responseString:<{"ErrorCode":"6011811","Message":"第1次登录错误"}>
        LogDebug(@"...<statusCode:%ld>...<responseString:%@>", (long)operation.response.statusCode, operation.responseString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // json解析
        NSError *err = nil;
        ResponseErrorModel *errorModel = [[ResponseErrorModel alloc] initWithData:operation.responseData error:&err];
        
        // 回调
        // 1. 若是网络断开,则errorModel为空;
        // 2. 若是500,则不为空
        fblock(operation, error, errorModel);
        
    }];
    
    /*
    CKHttpClient *httpClient = [CKHttpClient defaultHttpClient];
    [httpClient POST:pathUrl parameters:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        LogDebug(@"\n-----------------------------------\n...<statusCode:%ld>...<responseString:> \n%@\n----------------------------", (long)operation.response.statusCode, operation.responseString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // 请求正常,返回有数据时,还需要检查状态码...
        // 正常情况下不会走此逻辑...若返回状态码为500,则直接走请求失败逻辑...
        if (operation.response.statusCode != 200 && operation.response.statusCode != 201)
        {
            NSError *err = nil;
            ResponseErrorModel *errorModel = [[ResponseErrorModel alloc] initWithData:operation.responseData error:&err];
            // 回调...<并不为网络原因>
            fblock(operation, nil, errorModel);
            return;
        }
        
        // json解析
        NSError *error;
        ResponseModel *responseObj = [[ResponseModel alloc] init];
        responseObj.status = 1;
        responseObj.message = @"请求成功";
        //responseObj.data = [[returnClass alloc] initWithString:operation.responseString error:&error];
        if (returnClass != nil)
        {
            // 解析过程加try catch...
            @try {
                responseObj.data = [[returnClass alloc] initWithDictionary:responseObject error:&error];
            }
            @catch (NSException *exception) {
                LogDebug(@"exception:%@", [exception description]);
                responseObj.data = nil;
            }
            @finally {
                //
            }
        }
        else
        {
            responseObj.data = responseObject;
        }
        // 回调
        sblock(operation, responseObj);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //LogDebug(@"Error: %@", error);
        // 1. 网络断开 ...<statusCode:0>...<responseString:(null)>
        // 2. statusCode:500 responseString:<{"ErrorCode":"6011811","Message":"第1次登录错误"}>
        LogDebug(@"...<statusCode:%ld>...<responseString:%@>", (long)operation.response.statusCode, operation.responseString);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        // json解析
        NSError *err = nil;
        ResponseErrorModel *errorModel = [[ResponseErrorModel alloc] initWithData:operation.responseData error:&err];
        
        // 回调
        // 1. 若是网络断开,则errorModel为空;
        // 2. 若是500,则不为空
        fblock(operation, error, errorModel);
    }];
    */
}


#pragma mark - 发起Upload请求

/*
// Creating an Upload Task for a Multi-Part Request, with Progress
NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://example.com/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image.jpg"] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
} error:nil];

AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
NSProgress *progress = nil;

NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
        NSLog(@"Error: %@", error);
    } else {
        NSLog(@"%@ %@", response, responseObject);
    }
}];

[uploadTask resume];
*/

// upload file
// 未测试...
+ (void)startRequestForUpload:(NSString *)action
                         body:(NSDictionary *)body
                     filePath:(NSString *)path      // 本地待上传的文件路径
                  returnClass:(Class)returnClass
                      success:(RequestSuccessBlock)sblock
                      failure:(RequestFailureBlock)fblock
{
    // 拼接请求url
    NSString *pathUrl = [NSString stringWithFormat:@"%@%@", kBaseUrl, action];
    LogDebug(@"...>>>...requestUrl:%@\n", pathUrl);
    LogDebug(@"...>>>...requestData:%@\n", body);
    
//    CKHttpClient *httpClient = [CKHttpClient defaultHttpClient];
//    [httpClient defaultValueForHeader:@"Accept"];
//    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
//    
//    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:pathUrl parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //NSData *audioData = [NSData dataWithContentsOfFile:path];
//        //[formData appendPartWithFileData:audioData name:@"fileData" fileName:[path lastPathComponent] mimeType:@"audio/speex"];
//        
//        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
//        [formData appendPartWithFileData:[NSData dataWithContentsOfFile:path] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg"];
//    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:pathUrl]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 请求成功
        NSLog(@"%@ %@", operation.responseString, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 请求失败
        NSLog(@"Error: %@", error);
        
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        LogInfo(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    //call start on your request operation
    [operation start];
    
    /*
    // For iOS7
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:pathUrl parameters:body constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"file://path/to/image1.jpg"] name:@"file" fileName:@"filename1.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
        }
    }];
    
    [uploadTask resume];
    */
}


#pragma mark - 发起Download请求

/*
// Creating a Download Task
NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

NSURL *URL = [NSURL URLWithString:@"http://example.com/download.zip"];
NSURLRequest *request = [NSURLRequest requestWithURL:URL];

NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
} completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
    NSLog(@"File downloaded to: %@", filePath);
}];
[downloadTask resume];
*/

// download file
+ (void)startRequestForDownload:(NSString *)remotePath
                   withSavePath:(NSString *)localPath
                        success:(RequestSuccessBlock)sblock
                        failure:(RequestFailureBlock)fblock
{
    // 针对iOS6
    
    // 先进行一次utf-8编码转换,再删除url中所有的空格...<在线参数配置中经常容易写错>
    //remotePath = [remotePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    remotePath = [remotePath stringByReplacingOccurrencesOfString:@" " withString:@""]; // %20
    
    NSURL *url = [NSURL URLWithString:remotePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperation *reqOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // 临时下载的文件路径
    NSString *filePathTemp = [NSString stringWithFormat:@"%@.temp", localPath];
    // 避免同时下载数据到同一个文件
    int count = 1;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    while ([fileManager fileExistsAtPath:filePathTemp] == YES)
    {
        filePathTemp = [NSString stringWithFormat:@"%@.temp_%d", localPath, count];
        count++;
    }
    
    //NSLog(@"localPath:%@", localPath);
    //NSLog(@"filePathTemp:%@", filePathTemp);
    
    reqOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePathTemp append:NO];
    
    [reqOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         LogDebug(@"...>>>...Successfully downloaded file to %@\n", localPath);
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
         NSFileManager *fileManager = [NSFileManager defaultManager];
         NSError *err = nil;
         if ([fileManager fileExistsAtPath:filePathTemp] == YES)
         {
             if ([fileManager fileExistsAtPath:localPath] == YES)
             {
                 // 先删除原文件
                 [fileManager removeItemAtPath:localPath error:&err];
             }
             
             // 再替换
             [fileManager moveItemAtPath:filePathTemp toPath:localPath error:&err];
         }
         
         ResponseModel *responseObj = [[ResponseModel alloc] init];
         responseObj.status = 1;
         responseObj.message = @"请求成功";
         responseObj.data = localPath;   // 保存的本地路径
        
         sblock(nil, responseObj);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         NSFileManager *fileManager = [NSFileManager defaultManager];
         NSError *err = nil;
         if ([fileManager fileExistsAtPath:filePathTemp])
         {
             [fileManager removeItemAtPath:filePathTemp error:&err];
         }
         
         LogDebug(@"Error: %@", error);
         
         fblock(nil, error, nil);
         
     }];
    
    [reqOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
     {
         // 下载进度
         CGFloat progress = (float)totalBytesRead / totalBytesExpectedToRead;
         // 下载完成...该方法会在下载完成后立即执行
         if (progress == 1.0)
         {
             LogDebug(@"下载完成...");
         }
     }];
    
    [reqOperation start];
    
    /*
    if (__CUR_IOS_VERSION >= __IPHONE_7_0)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:remotePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            // doc文件夹下
            //NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
            //NSURL *imgPath = [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
            
            //NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            //NSURL *imgPath = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            
            // 自建的文件夹下
            NSURL *imgPath = [NSURL fileURLWithPath:localPath isDirectory:NO];
            LogDebug(@"图片下载后的保存路径:%@", imgPath);
            return imgPath;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (error != nil) {
                NSLog(@"Error: %@", error);
                fblock(nil, error, nil);
            } else {
                NSLog(@"File downloaded to: %@", filePath);
                
                ResponseModel *responseObj = [[ResponseModel alloc] init];
                responseObj.status = 1;
                responseObj.message = @"请求成功";
                responseObj.data = localPath;   // 保存的本地路径
                sblock(nil, responseObj);
            }
        }];
        
        [downloadTask resume];
    }
    else
    {
        NSURL *URL = [NSURL URLWithString:remotePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        AFHTTPRequestOperation *reqOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        NSString *filePathTemp = [NSString stringWithFormat:@"%@.temp",localPath];   //临时下载的文件路径
        // 避免同时下载数据到同一个文件
        int count = 1;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        while ([fileManager fileExistsAtPath:filePathTemp]) {
            filePathTemp = [NSString stringWithFormat:@"%@.temp_%d", localPath, count];
            count ++;
        }
        reqOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePathTemp append:NO];
        [reqOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             LogDebug(@"...>>>...Successfully downloaded file to %@\n", localPath);
             NSFileManager *fileManager = [NSFileManager defaultManager];
             NSError *err = nil;
             if ([fileManager fileExistsAtPath:filePathTemp]) {
                 if ([fileManager fileExistsAtPath:localPath]) {
                     [fileManager removeItemAtPath:localPath error:&err];
                 }
                 [fileManager moveItemAtPath:filePathTemp toPath:localPath error:&err];
             }
             
             ResponseModel *responseObj = [[ResponseModel alloc] init];
             responseObj.status = 1;
             responseObj.message = @"请求成功";
             responseObj.data = localPath;   // 保存的本地路径
             sblock(nil, responseObj);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSFileManager *fileManager = [NSFileManager defaultManager];
             NSError *err = nil;
             if ([fileManager fileExistsAtPath:filePathTemp]) {
                 [fileManager removeItemAtPath:filePathTemp error:&err];
             }
             LogDebug(@"Error: %@", error);
             fblock(nil, error, nil);
         }];
        
        [reqOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
         {
             //下载进度
             CGFloat progress = (float)totalBytesRead / totalBytesExpectedToRead;
             //下载完成...该方法会在下载完成后立即执行
             if (progress == 1.0) {
                 LogDebug(@"下载完成...");
             }
         }];
        [reqOperation start];
    }
    */
}


@end
