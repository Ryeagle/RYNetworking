//
//  UploadController.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/29.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "UploadController.h"
#import "RYHttpClient.h"

@interface UploadController ()
@property (nonatomic, strong) UIButton *uploadbutton;
@property (nonatomic, strong) UIButton *customUploadButton;
@property (nonatomic, strong) UIButton *cancelDefaultButotn;
@property (nonatomic, strong) UIButton *cancelCustomButotn;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) RYNetworkRequest *uploadRequest;
@property (nonatomic, strong) RYNetworkRequest *customuploadRequest;
@end

@implementation UploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.uploadbutton];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.customUploadButton];
    [self.view addSubview:self.cancelDefaultButotn];
    [self.view addSubview:self.cancelCustomButotn];

    self.progressView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10);
    self.uploadbutton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80);
    self.customUploadButton.frame = CGRectMake(0, 90, [UIScreen mainScreen].bounds.size.width, 80);
    self.cancelDefaultButotn.frame = CGRectMake(0, 90 + 90, [UIScreen mainScreen].bounds.size.width, 80);
    self.cancelCustomButotn.frame = CGRectMake(0, 90 + 90 + 90, [UIScreen mainScreen].bounds.size.width, 80);
}

- (void)dealloc {
    NSLog(@"🍑%@ is Dealloced.", [self class]);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [RYHttpClient cancelRequest:self.uploadRequest];
    [RYHttpClient cancelRequest:self.customuploadRequest];
}

- (void)resetUploadButtons {
    self.progressView.progress = 0.f;
    self.uploadbutton.enabled = YES;
    self.customUploadButton.enabled = YES;
}

#pragma mark - Actions

- (void)uploadAction:(UIButton *)button {
    self.uploadbutton.enabled = NO;
    self.customUploadButton.enabled = NO;
    self.progressView.progress = 0.f;
    __weak typeof(self) weakSelf = self;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iPhone.jpg" ofType:@""];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    RYUploadFormData *formdata = [RYUploadFormData formDataWithName:@"iPhone.jpg" fileData:data];
    
    self.uploadRequest =  [RYHttpClient Upload:@"post" parameters:@{} headers:@{} dataArray:@[formdata] onProcess:^(NSProgress * _Nonnull progress) {
        weakSelf.progressView.progress =  @(progress.completedUnitCount).floatValue / @(progress.totalUnitCount).floatValue;;
        NSLog(@"progress:%f", weakSelf.progressView.progress);
    } completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        weakSelf.uploadbutton.enabled = YES;
        weakSelf.customUploadButton.enabled = YES;
        weakSelf.progressView.progress = 0.f;
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            [AlertHelper showMessage:[NSString stringWithFormat:@"%@", response.allHeaderFields] title:@"Response"];
        }
    }];
}

- (void)customUploadAction:(UIButton *)button {
    self.uploadbutton.enabled = NO;
    self.customUploadButton.enabled = NO;
    self.progressView.progress = 0.f;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"iPhone.jpg" ofType:@""];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSData *data = [NSData dataWithContentsOfURL:url];

    __weak typeof(self) weakSelf = self;
    self.customuploadRequest = [RYHttpClient sendRequest:^(RYNetworkRequest * _Nonnull request) {
        request.urlStr = @"https://httpbin.org/post";
        request.type = RYNetworkRequestTypeUpload;
        request.timeoutInterval = 10;
        [request addFormDataWithName:@"screenshot" fileData:data];
    } onProcess:^(NSProgress * _Nonnull progress) {
        weakSelf.progressView.progress =  @(progress.completedUnitCount).floatValue / @(progress.totalUnitCount).floatValue;
        NSLog(@"progress:%f", weakSelf.progressView.progress);
    } completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        weakSelf.uploadbutton.enabled = YES;
        weakSelf.customUploadButton.enabled = YES;
        weakSelf.progressView.progress = 0.f;
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@"Error"];
        } else {
            [AlertHelper showMessage:[NSString stringWithFormat:@"%@", response.allHeaderFields] title:@"Response"];
        }
    }];
}

- (void)cancelDefaultUploadRequest:(UIButton *)button {
    [RYHttpClient cancelRequest:self.uploadRequest];
    [self resetUploadButtons];
}

- (void)cancelCustomUploadRequest:(UIButton *)button {
    [RYHttpClient cancelRequest:self.customuploadRequest];
    [self resetUploadButtons];
}

#pragma mark - Accessors

- (UIButton *)uploadbutton {
    if (!_uploadbutton) {
        _uploadbutton = [[UIButton alloc] init];
        _uploadbutton.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        [_uploadbutton setTitle:@"Default Config Upload" forState:UIControlStateNormal];
        [_uploadbutton setTitleColor:[UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1] forState:UIControlStateHighlighted];
        [_uploadbutton setTitleColor:[UIColor colorWithRed:10/225.0 green:179/225.0 blue:244/225.0 alpha:1] forState:UIControlStateNormal];
        [_uploadbutton setTitleColor:[UIColor colorWithRed:159/225.0 green:159/225.0 blue:159/225.0 alpha:1] forState:UIControlStateDisabled];
        [_uploadbutton.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC" size:18]];
        [_uploadbutton addTarget:self action:@selector(uploadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _uploadbutton;
}

- (UIButton *)customUploadButton {
    if (!_customUploadButton) {
        _customUploadButton = [[UIButton alloc] init];
        _customUploadButton.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        [_customUploadButton setTitle:@"Custom Config Upload" forState:UIControlStateNormal];
        [_customUploadButton setTitleColor:[UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1] forState:UIControlStateHighlighted];
        [_customUploadButton setTitleColor:[UIColor colorWithRed:10/225.0 green:179/225.0 blue:244/225.0 alpha:1] forState:UIControlStateNormal];
        [_customUploadButton setTitleColor:[UIColor colorWithRed:159/225.0 green:159/225.0 blue:159/225.0 alpha:1] forState:UIControlStateDisabled];
        [_customUploadButton.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC" size:18]];
        [_customUploadButton addTarget:self action:@selector(customUploadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _customUploadButton;
}

- (UIButton *)cancelDefaultButotn {
    if (!_cancelDefaultButotn) {
        _cancelDefaultButotn = [[UIButton alloc] init];
        _cancelDefaultButotn.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        [_cancelDefaultButotn setTitle:@"Cancel Default Upload" forState:UIControlStateNormal];
        [_cancelDefaultButotn setTitleColor:[UIColor colorWithRed:0.67 green:0.18 blue:0.14 alpha:1] forState:UIControlStateHighlighted];
        [_cancelDefaultButotn setTitleColor:[UIColor colorWithRed:1 green:0.28 blue:0.14 alpha:1] forState:UIControlStateNormal];
        [_cancelDefaultButotn setTitleColor:[UIColor colorWithRed:159/225.0 green:159/225.0 blue:159/225.0 alpha:1] forState:UIControlStateDisabled];
        [_cancelDefaultButotn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC" size:18]];
        [_cancelDefaultButotn addTarget:self action:@selector(cancelDefaultUploadRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelDefaultButotn;
}

- (UIButton *)cancelCustomButotn {
    if (!_cancelCustomButotn) {
        _cancelCustomButotn = [[UIButton alloc] init];
        _cancelCustomButotn.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        [_cancelCustomButotn setTitle:@"Cancel Default Upload" forState:UIControlStateNormal];
        [_cancelCustomButotn setTitleColor:[UIColor colorWithRed:0.67 green:0.18 blue:0.14 alpha:1] forState:UIControlStateHighlighted];
        [_cancelCustomButotn setTitleColor:[UIColor colorWithRed:1 green:0.28 blue:0.14 alpha:1] forState:UIControlStateNormal];
        [_cancelCustomButotn setTitleColor:[UIColor colorWithRed:159/225.0 green:159/225.0 blue:159/225.0 alpha:1] forState:UIControlStateDisabled];
        [_cancelCustomButotn.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC" size:18]];
        [_cancelCustomButotn addTarget:self action:@selector(cancelCustomUploadRequest:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cancelCustomButotn;
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.progressTintColor = [UIColor colorWithRed:10/225.0 green:179/225.0 blue:244/225.0 alpha:1];
        _progressView.trackTintColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        _progressView.progress = 0.f;
    }
    
    return _progressView;
}

@end
