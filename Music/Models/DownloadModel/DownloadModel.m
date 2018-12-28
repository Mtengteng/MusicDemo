//
//  DownloadModel.m
//  Music
//
//  Created by 马腾 on 2018/12/21.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import "DownloadModel.h"
#import "DownModel+CoreDataClass.h"

@implementation DownloadModel

- (void)assignDownModelInfo:(DownModel *__autoreleasing *)downModel
{
    DownModel *infoModel = *downModel;
    infoModel.name = _name;
    infoModel.urlStr = _urlStr;
    infoModel.progress = _progress;
    infoModel.downloadState = _downloadState;
    infoModel.downloadId = _downloadId;
}
@end
