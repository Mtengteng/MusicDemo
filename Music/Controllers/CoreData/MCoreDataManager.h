//
//  MCoreDataManager.h
//  Music
//
//  Created by 马腾 on 2018/12/26.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DownModel;
@class DownloadModel;

NS_ASSUME_NONNULL_BEGIN

@interface MCoreDataManager : NSObject

+ (MCoreDataManager *)shareInstances;

- (BOOL)insertDBWithModel:(DownloadModel *)model;

- (BOOL)updateDBWithModel:(DownloadModel *)model;

- (BOOL)deleteDBWithModel:(DownloadModel *)model;

- (BOOL)deleteAll;

- (NSArray *)queryAllDownloadModel;


@end

NS_ASSUME_NONNULL_END
