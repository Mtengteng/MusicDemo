//
//  DownModel+CoreDataProperties.m
//  
//
//  Created by 马腾 on 2018/12/26.
//
//

#import "DownModel+CoreDataProperties.h"
#import "DownloadModel.h"

@implementation DownModel (CoreDataProperties)

+ (NSFetchRequest<DownModel *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"DownModel"];
}

@dynamic downloadId;
@dynamic downloadState;
@dynamic filePath;
@dynamic name;
@dynamic progress;
@dynamic urlStr;

- (DownloadModel *)downloadModel
{
    DownloadModel *model = [[DownloadModel alloc] init];
    model.name = self.name;
    model.urlStr = self.urlStr;
    model.progress = self.progress;
    model.downloadState = self.downloadState;
    model.downloadId = self.downloadId;
    return model;
}

@end
