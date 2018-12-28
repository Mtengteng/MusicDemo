//
//  MAddViewController.m
//  Music
//
//  Created by 马腾 on 2018/12/27.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#import "MAddViewController.h"
#import "DownloadModel.h"

@interface MAddViewController ()
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *urlField;


@end

@implementation MAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增";
    self.view.backgroundColor = [UIColor whiteColor];

    
    _nameField = [[UITextField alloc] init];
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.placeholder = @"请输入歌曲名称...";
    _nameField.text = @"生僻字";
    [self.view addSubview:_nameField];
    
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(20);
        make.right.equalTo(self.view).with.offset(-20);
        make.top.equalTo(self.view).with.offset(120);
        make.height.equalTo(@44);

    }];
    
    _urlField = [[UITextField alloc] init];
    _urlField.placeholder = @"请输入下载地址...";
    _urlField.text = @"http://streamoc.music.tc.qq.com/M500001KxFBr3ZrMIk.mp3?guid=1473129920&vkey=C333428E1481CA8D7C9FAE218DAC72C69625F63338A2251EA159CBA02E43D3AC64DB94C95ECBE12491411C19466D8FBB189AD93F87FB1B38&uin=0&fromtag=8";
    
    [self.view addSubview:_urlField];
    
    [_urlField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom).with.offset(20);
        make.left.equalTo(_nameField);
        make.right.equalTo(_nameField);
        make.height.equalTo(@44);
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"Add" forState:UIControlStateNormal];
    [sureBtn setTitleColor:BWColor(92, 164, 236, 1) forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(addData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_urlField.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
    }];
}
- (void)addData:(id)sender
{
    NSInteger x = arc4random() % 10000;
    
    DownloadModel *model = [[DownloadModel alloc] init];
    model.name = _nameField.text;
    model.downloadId = [NSString stringWithFormat:@"download_%ld",x];
    model.urlStr = _urlField.text;
    model.downloadState = downloadState_begin;
    model.progress = 0.0;
    
    if ([[MCoreDataManager shareInstances] insertDBWithModel:model]) {
//        _nameField.text = @"";
//        _urlField.text = @"";
    }

}
@end
