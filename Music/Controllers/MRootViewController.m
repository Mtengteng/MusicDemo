//
//  MRootViewController.m
//  Music
//
//  Created by 马腾 on 2018/12/7.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import "MRootViewController.h"
#import "MDownloadManager.h"
#import "DownloadModel.h"
#import "DTableViewCell.h"

@interface MRootViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    dispatch_queue_t queue;
    MDownloadManager *downloadMan;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation MRootViewController

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 50; i++) {
            DownloadModel *model = [[DownloadModel alloc] init];
            model.name = [NSString stringWithFormat:@"%ld.mp4",i];
            model.filePath = @"https://media.w3.org/2010/05/sintel/trailer.mp4";
            model.progress = 0;
            model.downloadState = 0;
            model.downloadId = [NSString stringWithFormat:@"%ld.mp4",i];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    downloadMan = [MDownloadManager shareInstances];

    
    
//    //串型队列
//    dispatch_queue_t queue = dispatch_queue_create("com.beiwai", DISPATCH_QUEUE_SERIAL);
//
//    // 异步执行任务创建方法
//    dispatch_async(queue, ^{
//        // 这里放异步执行任务代码
//
//
//    });
//
//    //并行队列
//    dispatch_queue_t conQueue = dispatch_queue_create("com.beiwai", DISPATCH_QUEUE_CONCURRENT);
//
//    // 异步执行任务创建方法
//    dispatch_async(conQueue, ^{
//        // 这里放异步执行任务代码
//
//
//    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DefineWeakSelf;
    static NSString *cellId = @"cellId";
    
    DownloadModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    DTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[DTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    [cell setDownloadModel:model];
    [cell setDownloadActionBlock:^(DownloadModel * _Nonnull model, UIButton * _Nonnull button) {
        [button setImage:[UIImage imageNamed:@"tingzhi.png"] forState:UIControlStateNormal];
        [weakSelf downloadAction:indexPath];
    }];
    return cell;
    
}

- (void)downloadAction:(NSIndexPath *)indexPath
{

    DefineWeakSelf;
    
    [downloadMan addDownloadQueueWithDownloadModel:[self.dataArray objectAtIndex:indexPath.row]];
    
    downloadMan.downloadPro = ^(DownloadModel *model) {
        
        for (NSInteger i = 0; i<weakSelf.dataArray.count;i++) {
            DownloadModel *allModel = weakSelf.dataArray[i];

            if ([allModel.name isEqualToString:model.name]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *path=[NSIndexPath indexPathForRow:i inSection:0];
                    DTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:path];
                    [cell updateProgress:model.progress];
                });

            }
        }
    };
    downloadMan.downloadFinised = ^(DownloadModel * _Nonnull model) {
        [weakSelf.tableView reloadData];
    };
    downloadMan.downloadFailed = ^(DownloadModel * _Nonnull model) {
        [weakSelf.tableView reloadData];

    };
    
    
}


@end
