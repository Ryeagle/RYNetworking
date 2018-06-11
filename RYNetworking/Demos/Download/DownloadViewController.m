//
//  DownloadViewController.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/30.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "DownloadViewController.h"
#import "RYHttpClient.h"
#import "RYNetworkConfig.h"

@interface DownloadViewController ()
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *customDownloadButton;
@property (nonatomic, strong) UIButton *cancelDefaultButotn;
@property (nonatomic, strong) UIButton *cancelCustomButotn;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) RYNetworkRequest *downloadRequest;
@property (nonatomic, strong) RYNetworkRequest *customDownloadRequest;
@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.downloadButton];
    [self.view addSubview:self.customDownloadButton];
    [self.view addSubview:self.cancelDefaultButotn];
    [self.view addSubview:self.cancelCustomButotn];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.progressView];
    
    self.downloadButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    self.customDownloadButton.frame = CGRectMake(0, 54, [UIScreen mainScreen].bounds.size.width, 44);
    self.cancelDefaultButotn.frame = CGRectMake(0, 54 * 2, [UIScreen mainScreen].bounds.size.width, 44);
    self.cancelCustomButotn.frame = CGRectMake(0, 54 * 3, [UIScreen mainScreen].bounds.size.width, 44);
    self.imageView.frame = CGRectMake(0, 54 * 4, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9.0 / 16.0);
    self.progressView.frame = CGRectMake(0, 54 * 4, CGRectGetWidth(self.imageView.frame), CGRectGetHeight(self.imageView.frame));
}

- (void)disableButtons {
    self.downloadButton.enabled = NO;
    self.customDownloadButton.enabled = NO;
    self.progressView.hidden = NO;
}

- (void)resetButtons {
    self.downloadButton.enabled = YES;
    self.customDownloadButton.enabled = YES;
    self.progressView.hidden = YES;
}

#pragma mark - Actions

- (void)downloadAction:(UIButton *)button {
    [self disableButtons];
    [RYNetworkConfig sharedInstance].baseUrl = @"http://img.chongzhong.com";
    __weak typeof(self) weakSelf = self;
    self.downloadRequest = [RYHttpClient DownLoad:@"2017/11/4/2-1509790915-369.jpg"
        downloadSavePath:[NSString stringWithFormat:@"%@/PLhXaWvTpUveqqkSBx6_zWfP84KlGbPNvv", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]]
        parameters:@{} headers:@{} onProcess:^(NSProgress * _Nonnull progress) {
            weakSelf.progressView.progress = @(progress.completedUnitCount).floatValue / @(progress.totalUnitCount).floatValue;
            NSLog(@"progress:%f", weakSelf.progressView.progress);
    } completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        [weakSelf resetButtons];
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@""];
        } else {
            NSURL *filePath = response.responseObject;
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                weakSelf.imageView.image = image;
            }
        }
    }];
}

- (void)customDownloadAction:(UIButton *)button {
    [self disableButtons];
    
    __weak typeof(self) weakSelf = self;
    self.customDownloadRequest = [RYHttpClient sendRequest:^(RYNetworkRequest * _Nonnull request) {
        request.urlStr = @"http://img.chongzhong.com/2017/11/4/2-1509790915-369.jpg";
        request.downloadSavePath = [NSString stringWithFormat:@"%@/PLhXaWvTpUveqqkSBx6_zWfP84KlGbPNvv", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
        request.type = RYNetworkRequestTypeDownload;
        request.requestSerializerType = RYNetworkRequestSerializerTypeJSON;
        request.responeseSerializerType = RYNetworkResponseSerializerTypeJSON;
    } onProcess:^(NSProgress * _Nonnull progress) {
        weakSelf.progressView.progress = @(progress.completedUnitCount).floatValue / @(progress.totalUnitCount).floatValue;
    } completionHandler:^(RYNetworkResponse * _Nonnull response, RYNetworkError * _Nonnull error) {
        [weakSelf resetButtons];
        if (error) {
            [AlertHelper showMessage:error.titleForError title:@""];
        } else {
            NSURL *filePath = response.responseObject;
            NSData *data = [NSData dataWithContentsOfURL:filePath];
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                weakSelf.imageView.image = image;
            }
        }
    }];
}

- (void)cancelDefaultUploadRequest:(UIButton *)button {
    [RYHttpClient cancelRequest:self.downloadRequest];
}

- (void)cancelCustomUploadRequest:(UIButton *)button {
    [RYHttpClient cancelRequest:self.customDownloadRequest];
}

#pragma mark - Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithRed:10/225.0 green:179/225.0 blue:244/225.0 alpha:1];
    }
    
    return _imageView;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [[UIButton alloc] init];
        _downloadButton.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        [_downloadButton setTitle:@"Default Config Download" forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1] forState:UIControlStateHighlighted];
        [_downloadButton setTitleColor:[UIColor colorWithRed:10/225.0 green:179/225.0 blue:244/225.0 alpha:1] forState:UIControlStateNormal];
        [_downloadButton setTitleColor:[UIColor colorWithRed:159/225.0 green:159/225.0 blue:159/225.0 alpha:1] forState:UIControlStateDisabled];
        [_downloadButton.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC" size:18]];
        [_downloadButton addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _downloadButton;
}

- (UIButton *)customDownloadButton {
    if (!_customDownloadButton) {
        _customDownloadButton = [[UIButton alloc] init];
        _customDownloadButton.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        [_customDownloadButton setTitle:@"Custom Config Download" forState:UIControlStateNormal];
        [_customDownloadButton setTitleColor:[UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1] forState:UIControlStateHighlighted];
        [_customDownloadButton setTitleColor:[UIColor colorWithRed:10/225.0 green:179/225.0 blue:244/225.0 alpha:1] forState:UIControlStateNormal];
        [_customDownloadButton setTitleColor:[UIColor colorWithRed:159/225.0 green:159/225.0 blue:159/225.0 alpha:1] forState:UIControlStateDisabled];
        [_customDownloadButton.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC" size:18]];
        [_customDownloadButton addTarget:self action:@selector(customDownloadAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _customDownloadButton;
}

- (UIButton *)cancelDefaultButotn {
    if (!_cancelDefaultButotn) {
        _cancelDefaultButotn = [[UIButton alloc] init];
        _cancelDefaultButotn.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
        [_cancelDefaultButotn setTitle:@"Cancel Default Download" forState:UIControlStateNormal];
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
        [_cancelCustomButotn setTitle:@"Cancel Custom Download" forState:UIControlStateNormal];
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
