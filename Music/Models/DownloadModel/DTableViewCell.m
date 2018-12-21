//
//  DTableViewCell.m
//  Music
//
//  Created by 马腾 on 2018/12/21.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import "DTableViewCell.h"
#import "DownloadModel.h"

@interface DTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIProgressView *proView;
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) DownloadModel *downloadModel;


@end

@implementation DTableViewCell

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _titleLabel;
}
- (UIProgressView *)proView
{
    if (!_proView) {
        _proView = [[UIProgressView alloc] init];
        _proView.tintColor = [UIColor blueColor];
    }
    return _proView;
}
- (UIButton *)downloadBtn
{
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         [_downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBtn;
}
- (void)layoutSubviews{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@100);
    }];
    
    [self.contentView addSubview:self.proView];
    [self.proView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@120);
        make.right.equalTo(@-120);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.downloadBtn];
    [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).with.offset(-20);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
}
- (void)downloadAction:(UIButton *)button
{
 
    _downloadActionBlock(_downloadModel,button);
    
}

- (void)setDownloadModel:(DownloadModel *)model
{
    self.titleLabel.text = model.name;
    [self.proView setProgress:model.progress];

    _downloadModel = model;
    
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
    [self.downloadBtn setImage:img forState:UIControlStateNormal];
}
- (void)updateProgress:(float)progress
{
    [self.proView setProgress:progress];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
