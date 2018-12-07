//
//  AppDelegate.h
//  Music
//
//  Created by 马腾 on 2018/12/7.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

