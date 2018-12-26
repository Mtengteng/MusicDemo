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
            model.urlStr = @"https://media.w3.org/2010/05/sintel/trailer.mp4";
            model.progress = 0;
            model.downloadState = downloadState_begin;
            model.downloadId = [NSString stringWithFormat:@"%ld.mp4",i];
            [_dataArray addObject:model];
        }
    }
    return _dataArray;
}
- (instancetype)init
{
    if (self = [super init]) {
        downloadMan = [MDownloadManager shareInstances];
       
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(SCREEN_WIDTH - ADAPTATION_X(20), 0,70, 30);
//    [rightBtn setTitle:@"已完成" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:BWColor(92, 164, 236, 1) forState:UIControlStateNormal];
//    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [rightBtn addTarget:self action:@selector(gotoMyDownload:) forControlEvents:UIControlEventTouchUpInside];
//    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
//
//    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

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
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
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
#pragma mark-
#pragma mark- UITableViewDataSource
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
        
        switch (model.downloadState) {
            case downloadState_begin:
                [button setImage:[UIImage imageNamed:@"tingzhi.png"] forState:UIControlStateNormal];
                [weakSelf downloadAction:indexPath];
                break;
            case downloadState_start:
                [button setImage:[UIImage imageNamed:@"xiazai.png"] forState:UIControlStateNormal];
                
                [self->downloadMan downloadPause:model];
                break;
            case downloadState_pause:
                [button setImage:[UIImage imageNamed:@"tingzhi.png"] forState:UIControlStateNormal];
                
                [self->downloadMan downloadResume:model];
                break;
                
                
            default:
                break;
        }
        
//        if (model.downloadState == downloadState_begin) {
//            [button setImage:[UIImage imageNamed:@"tingzhi.png"] forState:UIControlStateNormal];
//            [weakSelf downloadAction:indexPath];
//        }
//        if (model.downloadState == downloadState_start) {
//            [button setImage:[UIImage imageNamed:@"xiazai.png"] forState:UIControlStateNormal];
//
//            [self->downloadMan downloadPause:model];
//
//        }
//        if (model.downloadState == downloadState_pause) {
//            [button setImage:[UIImage imageNamed:@"tingzhi.png"] forState:UIControlStateNormal];
//
//            [self->downloadMan downloadResume:model];
//        }
//        if (model.downloadState == downloadState_finished) {
////            [weakSelf downloadPause:indexPath];
//        }
        
       
    }];
    return cell;
    
}
#pragma mark-
#pragma mark- UITableDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}




@end
