//
//  RYHttpClient.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RYNetworkManager.h"
#import "RYBatchRequest.h"
#import "RYChainRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RYHttpClientRequestBlock)(RYNetworkRequest * _Nonnull request);
typedef void(^RYHttpClientBacthRequestBlock)(RYBatchRequest * _Nonnull batchRequest);
typedef void(^RYHttpClientChainRequestBlock)(RYChainRequest * _Nonnull chainRequest);

@interface RYHttpClient : NSObject

@property (nonatomic, assign) NSInteger reachabilityStatus;

+ (RYNetworkRequest *)defaultConfigRequest;

+ (void)configDefaultRequest:(RYNetworkRequest *)request;

+ (void)cancelRequest:(RYNetworkRequest *)request;

+ (void)cancelBathRequest:(RYBatchRequest *)batchRequest;

+ (void)cancelChainRequest:(RYChainRequest *)chainRequest;

#pragma mark - Custom Config

+ (RYNetworkRequest *)sendRequest:(RYHttpClientRequestBlock _Nonnull)requestBlock
    completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYNetworkRequest *)sendRequest:(RYHttpClientRequestBlock _Nonnull)requestBlock
                    onProcess:(RYNetworkProgressBlock)progressBlock
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYBatchRequest *)sendBatchRequest:(RYHttpClientBacthRequestBlock)batchRequestBlock
                   completionHandler:(RYBatchRequestCompletionHandler)completionHandler;

+ (RYChainRequest *)sendChainRequest:(RYHttpClientChainRequestBlock)chainRequestBlock
                   completionHandler:(RYChainRequestCompletionHandler)completionHandler;

#pragma mark - Default Config

+ (RYNetworkRequest *)GET:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           headers:(NSDictionary *)headers
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYNetworkRequest *)POST:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           headers:(NSDictionary *)headers
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYNetworkRequest *)HEAD:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           headers:(NSDictionary *)headers
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYNetworkRequest *)DELETE:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           headers:(NSDictionary *)headers
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYNetworkRequest *)PUT:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           headers:(NSDictionary *)headers
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYNetworkRequest *)PATCH:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           headers:(NSDictionary *)headers
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYNetworkRequest *)Upload:(NSString *)path
                        parameters:(NSDictionary *)parameters
                           headers:(NSDictionary *)headers
                         dataArray:(NSArray <RYUploadFormData *> *)array
                         onProcess:(RYNetworkProgressBlock)processBlock
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

+ (RYNetworkRequest *)DownLoad:(NSString *)path
                  downloadSavePath:(NSString * _Nonnull)downloadSavePath
                        parameters:(NSDictionary *)parameters
                       headers:(NSDictionary *)headers
                         onProcess:(RYNetworkProgressBlock)processBlock
                 completionHandler:(RYNetworkResponseBlock)completionHandler;

@end

NS_ASSUME_NONNULL_END
