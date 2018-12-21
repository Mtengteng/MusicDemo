//
//  BWNetManager.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWNetManager.h"
#import "BWBaseReq.h"
#import "BWBaseResp.h"


@interface BWNetManager()

-(NSString *)replaceClassName:(id)reqClass;

@end

@implementation BWNetManager

+ (BWNetManager *)sharedInstances
{
    static BWNetManager *netManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netManager = [[BWNetManager alloc] init];
    });
    return netManager;
}

- (void)sendRequest:(BWBaseReq *)request
                withSucessed:(void (^)(BWBaseReq *, BWBaseResp *))success
                failure:(void (^)(BWBaseReq *, NSError *))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@",request.url];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval = request.timeOut !=0 ? request.timeOut : 15;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //网络请求安全策略
    if (request.isSecurityPolicy) {
        AFSecurityPolicy *securityPolicy;
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.allowInvalidCertificates = false;
        securityPolicy.validatesDomainName = YES;
        manager.securityPolicy = securityPolicy;
    } else {
        manager.securityPolicy.allowInvalidCertificates = true;
        manager.securityPolicy.validatesDomainName = false;
    }
    
    __block long netState;
    //监听网络状态
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);

        netState = status;
    }];
    [manager.reachabilityManager startMonitoring];
    
    NSLog(@"\nRequest url : %@\nRequest body : %@",[request.url absoluteString],request.getRequestParametersDictionary);
    
    [manager POST:urlString parameters:[request getRequestParametersDictionary] progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (request.isCancel) {
            return;
        }
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingMutableLeaves error:nil];
        BWBaseResp *response = [[NSClassFromString([self replaceClassName:request]) alloc] initWithJSONDictionary:json];
        
        if (ResponseCode_Success == response.errorCode) {
            
            NSLog(@"\nRequestURL : %@\nResponseCode : %d\nResponseMsg : %@\nResponseBody : %@",request.url.absoluteString,response.errorCode,response.errorMessage,json);
            
            success(request,response);
            
        }else{
            
            if (response.errorMessage != nil) {
                NSError * error = [NSError errorWithDomain:response.errorMessage code:response.errorCode userInfo:nil];
                
                NSLog(@"ERROR!!\n  \nRequestURL : %@\nResponseCode : %d\nResponseMsg : %@\nResponseBody : %@",request.url.absoluteString,response.errorCode,response.errorMessage,json);
                
                failure(request,error);
            }
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        AFNetworkReachabilityStatusUnknown          = -1,
        //        AFNetworkReachabilityStatusNotReachable     = 0,
        //        AFNetworkReachabilityStatusReachableViaWWAN = 1,
        //        AFNetworkReachabilityStatusReachableViaWiFi = 2,
        
        if (netState == -1 || netState == 0) {
            NSError * netError = [NSError errorWithDomain:@"当前网络不可用，请检查后再试" code:-1 userInfo:nil];
            failure(request,netError);

        }else{
            NSError * netError = [NSError errorWithDomain:@"服务器连接失败，请检查后再试" code:-1 userInfo:nil];

            failure(request,netError);

        }

    }];
}
/*
- (void)downloadRequest:(BWDownloadRequest *)request progress:(void (^)(float progress, NSString *taskId))progressBlock completionHandler:(void (^)(BWBaseResp *, NSURL *, NSError *))completionBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    设置网络请求序列化对象
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:@"test" forHTTPHeaderField:@"requestHeader"];
    requestSerializer.timeoutInterval = 60;
    requestSerializer.stringEncoding = NSUTF8StringEncoding;
    设置返回数据序列化对象
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = responseSerializer;
    //网络请求安全策略
//    if (true) {
//        AFSecurityPolicy *securityPolicy;
//        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
//        securityPolicy.allowInvalidCertificates = false;
//        securityPolicy.validatesDomainName = YES;
//        manager.securityPolicy = securityPolicy;
//    } else {
//        manager.securityPolicy.allowInvalidCertificates = true;
//        manager.securityPolicy.validatesDomainName = false;
//    }
    //是否允许请求重定向
//    if (true) {
//        [manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request) {
//            if (response) {
//                return nil;
//            }
//            return request;
//        }];
//    }
    //监听网络状态
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"%ld",(long)status);
    }];
    [manager.reachabilityManager startMonitoring];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress){
        
        NSLog(@"下载进度:%lld",downloadProgress.completedUnitCount);
        
        progressBlock(downloadProgress.completedUnitCount,[NSString stringWithFormat:@"%ld",downloadTask.taskIdentifier]);
        
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        NSLog(@"fileURL:%@",[fileURL absoluteString]);
        return fileURL;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        NSLog(@"File downloaded to: %@", filePath);
        
        completionBlock(response,filePath,error);
    }];
    [downloadTask resume];
    
}
*/

-(NSString *)replaceClassName:(id)reqClass
{
    NSString * reqStr = NSStringFromClass([reqClass class]);
    NSString * string1 = reqStr;
    NSString * string2 = @"Req";
    NSRange range = [string1 rangeOfString:string2];
    NSString *respStr = nil;
    if (range.location != NSNotFound) {
        NSString *str = [string1 substringToIndex:range.location];
        respStr = [NSString stringWithFormat:@"%@Resp",str];
    }
    return respStr;
    
}

@end
