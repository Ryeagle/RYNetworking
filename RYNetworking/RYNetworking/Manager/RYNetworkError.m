//
//  RYNetworkError.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "RYNetworkError.h"
#import "RYNetworkTool.h"

NSErrorDomain const RYNetworkErrorHTTPErrorDomain = @"com.RYnetworking.networkerror.httperror";


@implementation RYNetworkError

+ (instancetype)bulidNetworkError:(NSError *)error {
    RYNetworkError *networkError = [RYNetworkError errorWithDomain:error.domain code:error.code userInfo:error.userInfo];
    
    return networkError;
}

- (NSString *)titleForError {
    if ([RYNetworkTool sharedInstance].logEnable) {
        return [self debugTitleForError];
    }
    NSString *errorMsg = @"网络错误，请稍后重试";
        return errorMsg;
}

#pragma mark - Debug

- (NSString *)debugTitleForError {
    NSString *errorMsg = @"HTTP错误，请稍后重试";

    if (NSOrderedSame == [self.domain compare:@"NSURLErrorDomain"] ||
        NSOrderedSame == [self.domain compare:AFURLResponseSerializationErrorDomain]) {
        switch (self.code) {
            case -1://NSURLErrorUnknown
                errorMsg = @"无效的URL地址";
                break;
            case -999://NSURLErrorCancelled
                errorMsg = @"请求已经取消";
                break;
            case -1000://NSURLErrorBadURL
                errorMsg = @"无效的URL地址";
                break;
            case -1001://NSURLErrorTimedOut
                errorMsg = @"NSURLErrorTimedOut：超时，稍后再试";
                break;
            case -1002://NSURLErrorUnsupportedURL
                errorMsg = @"不支持的URL地址";
                break;
            case -1003://NSURLErrorCannotFindHost
                errorMsg = @"NSURLErrorCannotFindHost:找不到服务器";
                break;
            case -1004://NSURLErrorCannotConnectToHost
                errorMsg = @"NSURLErrorCannotConnectToHost:连接不上服务器";
                break;
            case -1103://NSURLErrorDataLengthExceedsMaximum
                errorMsg = @"NSURLErrorDataLengthExceedsMaximum:请求数据长度超出最大限度";
                break;
            case -1005://NSURLErrorNetworkConnectionLost
                errorMsg = @"NSURLErrorNetworkConnectionLost:网络连接异常";
                break;
            case -1006://NSURLErrorDNSLookupFailed
                errorMsg = @"DNS查询失败";
                break;
            case -1007://NSURLErrorHTTPTooManyRedirects
                errorMsg = @"HTTP请求重定向";
                break;
            case -1008://NSURLErrorResourceUnavailable
                errorMsg = @"资源不可用";
                break;
            case -1009://NSURLErrorNotConnectedToInternet
                errorMsg = @"无网络连接";
                break;
            case -1010://NSURLErrorRedirectToNonExistentLocation
                errorMsg = @"重定向到不存在的位置";
                break;
            case -1011://NSURLErrorBadServerResponse
                errorMsg = @"服务器响应异常";
                break;
            case -1012://NSURLErrorUserCancelledAuthentication
                errorMsg = @"用户取消授权";
                break;
            case -1013://NSURLErrorUserAuthenticationRequired
                errorMsg = @"需要用户授权";
                break;
            case -1014://NSURLErrorZeroByteResource
                errorMsg = @"零字节资源";
                break;
            case -1015://NSURLErrorCannotDecodeRawData
                errorMsg = @"NSURLErrorCannotDecodeRawData:无法解码原始数据";
                break;
            case -1016://NSURLErrorCannotDecodeContentData
                errorMsg = @"NSURLErrorCannotDecodeContentData:无法解码内容数据";
                break;
            case -1017://NSURLErrorCannotParseResponse
                errorMsg = @"无法解析响应";
                break;
            case -1018://NSURLErrorInternationalRoamingOff
                errorMsg = @"国际漫游关闭";
                break;
            case -1019://NSURLErrorCallIsActive
                errorMsg = @"被叫激活";
                break;
            case -1020://NSURLErrorDataNotAllowed
                errorMsg = @"数据不被允许";
                break;
            case -1021://NSURLErrorRequestBodyStreamExhausted
                errorMsg = @"请求体";
                break;
            case -1100://NSURLErrorFileDoesNotExist
                errorMsg = @"文件不存在";
                break;
            case -1101://NSURLErrorFileIsDirectory
                errorMsg = @"文件是个目录";
                break;
            case -1102://NSURLErrorNoPermissionsToReadFile
                errorMsg = @"无读取文件权限";
                break;
            case -1200://NSURLErrorSecureConnectionFailed
                errorMsg = @"安全连接失败";
                break;
            case -1201://NSURLErrorServerCertificateHasBadDate
                errorMsg = @"服务器证书失效";
                break;
            case -1202://NSURLErrorServerCertificateUntrusted
                errorMsg = @"不被信任的服务器证书";
                break;
            case -1203://NSURLErrorServerCertificateHasUnknownRoot
                errorMsg = @"未知Root的服务器证书";
                break;
            case -1204://NSURLErrorServerCertificateNotYetValid
                errorMsg = @"服务器证书未生效";
                break;
            case -1205://NSURLErrorClientCertificateRejected
                errorMsg = @"客户端证书被拒";
                break;
            case -1206://NSURLErrorClientCertificateRequired
                errorMsg = @"需要客户端证书";
                break;
            case -2000://NSURLErrorCannotLoadFromNetwork
                errorMsg = @"无法从网络获取";
                break;
            case -3000://NSURLErrorCannotCreateFile
                errorMsg = @"无法创建文件";
                break;
            case -3001:// NSURLErrorCannotOpenFile
                errorMsg = @"无法打开文件";
                break;
            case -3002://NSURLErrorCannotCloseFile
                errorMsg = @"无法关闭文件";
                break;
            case -3003://NSURLErrorCannotWriteToFile
                errorMsg = @"无法写入文件";
                break;
            case -3004://NSURLErrorCannotRemoveFile
                errorMsg = @"无法删除文件";
                break;
            case -3005://NSURLErrorCannotMoveFile
                errorMsg = @"无法移动文件";
                break;
            case -3006://NSURLErrorDownloadDecodingFailedMidStream
                errorMsg = @"下载解码数据失败";
                break;
            case -3007://NSURLErrorDownloadDecodingFailedToComplete
                errorMsg = @"下载解码数据失败";
                break;
        }
    } else if (NSOrderedSame == [self.domain compare:RYNetworkErrorHTTPErrorDomain]) {
        switch (self.code) {
            case 400:
                errorMsg = @"400:请求无效";
                break;
            case 401:
                errorMsg = @"401:请求需要验证";
                break;
            case 403:
                errorMsg = @"403:服务器拒绝请求";
                break;
            case 404:
                errorMsg = @"404:找不到服务器";
                break;
            case 405:
                errorMsg = @"405:请求的方法不被允许";
                break;
            case 500:
                errorMsg = @"500:服务器内部错误";
                break;
            case 501:
                errorMsg = @"501:服务器为实现功能";
                break;
            case 502:
                errorMsg = @"502:错误网关";
                break;
            case 503:
                errorMsg = @"503:服务不可用";
                break;
                
            default:
                break;
        }
    }

    return errorMsg;
}
@end
