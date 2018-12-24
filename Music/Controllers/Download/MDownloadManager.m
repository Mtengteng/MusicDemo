//
//  MDownloadManager.m
//  Music
//
//  Created by 马腾 on 2018/12/21.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import "MDownloadManager.h"
#import "DownloadModel.h"


@interface MDownloadManager()
{
    dispatch_queue_t seQueue;
    dispatch_queue_t conQueue;
}

@end

@implementation MDownloadManager

+ (MDownloadManager *)shareInstances
{
    static MDownloadManager *downloadMan = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downloadMan = [[MDownloadManager alloc] init];
    });
    return downloadMan;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        
//        seQueue = dispatch_queue_create("com.beiwai", DISPATCH_QUEUE_SERIAL);
       
        conQueue = dispatch_queue_create("com.beiwai", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSMutableArray *)downloadIngList
{
    if (!_downloadIngList) {
        _downloadIngList = [[NSMutableArray alloc] init];
    }
    return _downloadIngList;
}
- (NSMutableArray *)downloadFinishList
{
    if (!_downloadFinishList) {
        _downloadFinishList = [[NSMutableArray alloc] init];
    }
    return _downloadFinishList;
}

- (void)addDownloadQueueWithDownloadModel:(DownloadModel *)model
{

    DefineWeakSelf;
   
    dispatch_async(conQueue, ^{
        // 这里放异步执行任务代码
        
        [weakSelf startDownloadWithDownloadModel:model];
    });
    
}

- (void)startDownloadWithDownloadModel:(DownloadModel *)model
{
    [self.downloadIngList addObject:model];
    
    DefineWeakSelf;

    /* 创建网络下载对象 */
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    /* 下载地址 */
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.filePath]];
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString *filePath = [path stringByAppendingPathComponent:model.name];
    
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度：fileName =%@, %.0f％",model.name, downloadProgress.fractionCompleted * 100);
        model.progress = downloadProgress.fractionCompleted;
        model.downloadState = downloadState_start;
        weakSelf.downloadPro(model);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果需要进行UI操作，需要获取主线程进行操作
        });
        /* 设定下载到的位置 */
        model.filePath = [NSURL fileURLWithPath:filePath].absoluteString;
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"下载完成");
        
        [weakSelf.downloadIngList removeObject:model];
        [weakSelf.downloadFinishList addObject:model];
        
        model.downloadState = downloadState_finished;
        
        weakSelf.downloadFinised(model);
        
    }];
    [downloadTask resume];
    

}
@end
