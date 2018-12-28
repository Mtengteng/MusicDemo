//
//  MAddViewController.h
//  Music
//
//  Created by 马腾 on 2018/12/27.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DownloadModel;

typedef void(^addModelBlock)(DownloadModel *model);

@interface MAddViewController : UIViewController
@property (nonatomic, copy) addModelBlock addBlock;

@end

NS_ASSUME_NONNULL_END
