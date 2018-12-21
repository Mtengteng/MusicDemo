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
    static NSString *cellId = @"cellId";
    
    DownloadModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    for (id v in cell.contentView.subviews)
        [v removeFromSuperview];
    
    UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBtn.tag = 1000+indexPath.row;
    //        [downloadBtn setImage:[UIImage imageNamed:@"xiazai.png"] forState:UIControlStateNormal];
    [downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:downloadBtn];
    
    [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView.mas_right).with.offset(-20);
        make.centerY.equalTo(cell.contentView);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    UIProgressView *proView = [[UIProgressView alloc] init];
    proView.tag = 2000+indexPath.row;
    proView.tintColor = [UIColor greenColor];
    [proView setProgress:model.progress];
    [cell.contentView addSubview:proView];
    
    [proView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@90);
        make.right.equalTo(@-90);
        make.centerY.equalTo(cell.contentView);
        
    }];
    
    
    UIImage *img;
    switch (model.downloadState) {
        case downloadState_begin:
            img = [UIImage imageNamed:@"xiazai.png"];
            break;
        case downloadState_start:
            img = [UIImage imageNamed:@"tingzhi.png"];
            break;
        case downloadState_pause:
            img = [UIImage imageNamed:@"xiazai.png"];

            break;
        case downloadState_failed:
            img = [UIImage imageNamed:@"shibai.png"];

            break;
        case downloadState_finished:
            img = [UIImage imageNamed:@"bofang.png"];

            break;
        default:
            img = [UIImage imageNamed:@"ic_pending.png"];

            break;
    }
    [downloadBtn setImage:img forState:UIControlStateNormal];
    cell.textLabel.text = model.name;

    return cell;
    
}

- (void)downloadAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [button setImage:[UIImage imageNamed:@"tingzhi.png"] forState:UIControlStateNormal];

    DefineWeakSelf;
    
    [downloadMan addDownloadQueueWithDownloadModel:[self.dataArray objectAtIndex:button.tag - 1000]];
    
    downloadMan.downloadPro = ^(DownloadModel *model) {
        
        for (NSInteger i = 0; i<weakSelf.dataArray.count;i++) {
            DownloadModel *allModel = weakSelf.dataArray[i];
            
            if ([allModel.name isEqualToString:model.name]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIProgressView *pro = (UIProgressView *)[weakSelf.tableView viewWithTag:i+2000];
                    [pro setProgress:model.progress];
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
