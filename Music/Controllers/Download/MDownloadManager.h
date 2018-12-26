//
//  MDownloadManager.h
//  Music
//
//  Created by 马腾 on 2018/12/21.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^downloadProgressBlock)(DownloadModel *model);
typedef void(^downloadFinishedBlock)(DownloadModel *model);
typedef void(^downloadFailedBlock)(DownloadModel *model);

@interface MDownloadManager : NSObject
@property (nonatomic, strong) NSMutableArray *downloadIngList;
@property (nonatomic, strong) NSMutableArray *downloadFinishList;
@property (nonatomic, copy) downloadProgressBlock downloadPro;
@property (nonatomic, copy) downloadFailedBlock downloadFailed;
@property (nonatomic, copy) downloadFinishedBlock downloadFinised;


+ (MDownloadManager *)shareInstances;

- (void)addDownloadQueueWithDownloadModel:(DownloadModel *)model;

- (void)downloadPause:(DownloadModel *)model;

- (void)downloadResume:(DownloadModel *)model;


@end

NS_ASSUME_NONNULL_END
