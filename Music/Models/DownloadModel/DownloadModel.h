//
//  DownloadModel.h
//  Music
//
//  Created by 马腾 on 2018/12/21.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum downloadState
{
    downloadState_begin,
    downloadState_start,
    downloadState_pause,
    downloadState_wait,
    downloadState_finished,
    downloadState_failed
    
}downloadState;

@interface DownloadModel : NSObject
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *filePath;
@property (nullable, nonatomic, copy) NSString *downloadId;
@property (nullable, nonatomic, copy) NSString *urlStr;
@property (nonatomic, assign) downloadState downloadState;
@property (nonatomic, assign) float progress;
@end

NS_ASSUME_NONNULL_END
