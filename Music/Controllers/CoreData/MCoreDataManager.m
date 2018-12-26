//
//  MCoreDataManager.m
//  Music
//
//  Created by 马腾 on 2018/12/26.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import "MCoreDataManager.h"
#import "AppDelegate.h"

@interface MCoreDataManager()
@property (nonatomic, strong) NSPersistentContainer * container;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation MCoreDataManager

- (instancetype)init
{
    if (self = [super init]) {
         AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _container = appDelegate.persistentContainer;
        _context = _container.viewContext;
    }
    return self;
}

@end
