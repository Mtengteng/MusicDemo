//
//  MCoreDataManager.m
//  Music
//
//  Created by 马腾 on 2018/12/26.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import "MCoreDataManager.h"
#import "AppDelegate.h"
#import "DownModel+CoreDataClass.h"
#import "DownloadModel.h"

@interface MCoreDataManager()
@property (nonatomic, strong) NSPersistentContainer * container;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableArray *dataArray;

- (DownModel *)queryOneDownloadId:(NSString *)downloadId;

@end

@implementation MCoreDataManager

+ (MCoreDataManager *)shareInstances
{
    static MCoreDataManager *coreManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreManager = [[MCoreDataManager alloc] init];
    });
    return coreManager;

}

- (instancetype)init
{
    if (self = [super init]) {
         AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _container = appDelegate.persistentContainer;
        _context = _container.viewContext;
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)insertDBWithModel:(DownloadModel *)model
{
    DownModel *esModel = [self queryOneDownloadId:model.downloadId];
    if (esModel) {
        NSLog(@"downloadId已经存在!");
        return NO;
    }
    DownModel *coreModel = [NSEntityDescription  insertNewObjectForEntityForName:@"DownModel"  inManagedObjectContext:_context];
    
    [model assignDownModelInfo:&coreModel];
    
    //   3.保存插入的数据
    NSError *error = nil;
    if ([_context save:&error]) {
        NSLog(@"数据插入到数据库成功");
        return YES;
    }else{
        NSLog(@"数据插入到数据库失败");
        return NO;
        
    }
    return NO;

}
- (BOOL)updateDBWithModel:(DownloadModel *)model
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DownModel"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"downloadId = %@",model.downloadId];
    request.predicate = pre;
    
    DownModel *coreModel = [NSEntityDescription  insertNewObjectForEntityForName:@"DownModel"  inManagedObjectContext:_context];
    [model assignDownModelInfo:&coreModel];
    
    //   3.保存插入的数据
    NSError *error = nil;
    if ([_context save:&error]) {
        NSLog(@"数据更新到数据库成功");
        return YES;
    }else{
        NSLog(@"数据更新到数据库失败");
        return NO;
        
    }
    return NO;

}
- (BOOL)deleteDBWithModel:(DownloadModel *)model
{
    DownModel * downloadInfo = [self queryOneDownloadId:model.downloadId];
    if (nil == downloadInfo) {
        NSLog(@"Can't find downloadInfo %@ ",model.downloadId);
        return NO;
    }
    [_context deleteObject:downloadInfo];
    NSError * error = nil;
    
    [_context save:&error];
    
    if (error!=nil) {
        NSLog(@"Error : save context error %@",[error userInfo]);
        return NO;
    }
    return YES;
}
- (BOOL)deleteAll
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DownModel"];
    NSArray *array = [_context executeFetchRequest:request error:nil];
    
    for (DownModel *model in array) {
        [_context deleteObject:model];
    }
    NSError * error = nil;
    
    [_context save:&error];
    
    if (error!=nil) {
        NSLog(@"Error : save context error %@",[error userInfo]);
        return NO;
    }
    return YES;
}
- (DownModel *)queryOneDownloadId:(NSString *)downloadId
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DownModel"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"downloadId = %@",downloadId];
    request.predicate = pre;
    
    NSError * error = nil;
    NSArray * array = [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"query readingInfo %@ error : %@",downloadId, error);
        return nil;
    }
    if (0==[array count]) {
        return nil;
    }
    if ([array count]!=1) {
        NSLog(@"Error : there are %ld readingInfos with bookId : %@",[array count],downloadId);
    }
    DownModel * downloadInfo = [array firstObject];
    return downloadInfo;
    
}
- (NSArray *)queryAllDownloadModel
{
    [_dataArray removeAllObjects];
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DownModel"];
    //查询条件
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"downloadState = 0"];
//    request.predicate = pre;
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    // 每页显示多少条数据
    //request.fetchLimit = 6;
    
    //发送查询请求
    NSArray *array = [[_context executeFetchRequest:request error:nil] copy];
    
    for (DownModel *model in array) {
        DownloadModel *downloadModel = [model downloadModel];
        [_dataArray addObject:downloadModel];
    }
    return _dataArray;
}

@end
