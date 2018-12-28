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
@property (nonatomic, strong) AFURLSessionManager *manager;
@property (nonatomic, strong) NSMutableArray *task;

- (void)updateDownloadTaskStateWithModel:(DownloadModel *)model;

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
        /* 创建网络下载对象 */
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
//        seQueue = dispatch_queue_create("com.beiwai", DISPATCH_QUEUE_SERIAL);
       
//        conQueue = dispatch_queue_create("com.beiwai", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
- (NSMutableArray *)task
{
    if (!_task) {
        _task = [[NSMutableArray alloc] init];
    }
    return _task;
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

    [self startDownloadWithDownloadModel:model];

}

- (void)startDownloadWithDownloadModel:(DownloadModel *)model
{
    [self.downloadIngList addObject:model];
    
    DefineWeakSelf;
    
    /* 下载地址 */
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:model.urlStr]];
    /* 下载路径 */
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",model.downloadId]];
    
    /* 开始请求下载 */
    NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"下载进度：fileName =%@, %.0f％",model.downloadId, downloadProgress.fractionCompleted * 100);
        model.progress = downloadProgress.fractionCompleted;
//        model.downloadState = downloadState_start;
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
        
        weakSelf.downloadFinised(model);
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObjectsFromArray:weakSelf.task];

        for (NSDictionary *json in array) {
            NSString *dId = [json objectForKey:@"downloadId"];
            if ([dId isEqualToString:model.downloadId]) {
                [weakSelf.task removeObject:json];
            }
        }
        [self updateDownloadTaskStateWithModel:model];

        
        
    }];
    [downloadTask resume];
    
    [self updateDownloadTaskStateWithModel:model];

    
    [self.task addObject:@{@"id":[NSNumber numberWithInteger:downloadTask.taskIdentifier],
                           @"downloadId":model.downloadId
                           }];
    
    

}

- (void)downloadPause:(DownloadModel *)model
{

    NSURLSessionDownloadTask *task = [self findCurrentTaskWithModelId:model.downloadId];
//    model.downloadState = downloadState_pause;
    [task suspend];
    [self updateDownloadTaskStateWithModel:model];

    
}
- (void)downloadResume:(DownloadModel *)model
{
    NSURLSessionDownloadTask *task = [self findCurrentTaskWithModelId:model.downloadId];

    if (task) {
//        model.downloadState = downloadState_start;
        [task resume];
        [self updateDownloadTaskStateWithModel:model];

    }else{

    }
    
}

- (NSURLSessionDownloadTask *)findCurrentTaskWithModelId:(NSString *)downloadId
{
    for (NSDictionary *dic in self.task) {
        NSString *taskDownloadId = [dic objectForKey:@"downloadId"];
        
        if ([downloadId isEqualToString:taskDownloadId]) {
            NSNumber *taskId = [dic objectForKey:@"id"];

            for (NSURLSessionDownloadTask *currentTask in _manager.downloadTasks) {
                if (currentTask.taskIdentifier == taskId.integerValue) {
                    return currentTask;
                }
            }
        }
    }
    
    return nil;
}

- (void)updateDownloadTaskStateWithModel:(DownloadModel *)model
{

    NSURLSessionDownloadTask *downloadTask = [self findCurrentTaskWithModelId:model.downloadId];
    switch (downloadTask.state) {
        case NSURLSessionTaskStateRunning:
            model.downloadState = downloadState_start;
            break;
        case NSURLSessionTaskStateSuspended:
            model.downloadState = downloadState_pause;

            break;
        case NSURLSessionTaskStateCanceling:
            model.downloadState = downloadState_failed;

            break;
        case NSURLSessionTaskStateCompleted:
            model.downloadState = downloadState_finished;
            break;
            
        default:
            model.downloadState = downloadState_wait;
            break;
    }
    
    
}
@end
