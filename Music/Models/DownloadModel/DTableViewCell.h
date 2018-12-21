//
//  DTableViewCell.h
//  Music
//
//  Created by 马腾 on 2018/12/21.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class DownloadModel;

typedef void(^downloadBtnBlock)(DownloadModel *model,UIButton *button);

@interface DTableViewCell : UITableViewCell
@property (nonatomic, strong) downloadBtnBlock downloadActionBlock;

- (void)setDownloadModel:(DownloadModel *)model;

- (void)updateProgress:(float)progress;

@end

NS_ASSUME_NONNULL_END
