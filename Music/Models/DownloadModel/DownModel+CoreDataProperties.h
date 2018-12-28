//
//  DownModel+CoreDataProperties.h
//  
//
//  Created by 马腾 on 2018/12/26.
//
//

#import "DownModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN
@class DownloadModel;

@interface DownModel (CoreDataProperties)

+ (NSFetchRequest<DownModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *downloadId;
@property (nonatomic) int64_t downloadState;
@property (nullable, nonatomic, copy) NSString *filePath;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) float progress;
@property (nullable, nonatomic, copy) NSString *urlStr;

- (DownloadModel *)downloadModel;


@end

NS_ASSUME_NONNULL_END
