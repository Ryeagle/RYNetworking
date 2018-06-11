//
//  RYNetworkResponse.m
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#import "RYNetworkResponse.h"
#import "RYNetworkTool.h"
#import "RYNetworkError.h"

@interface RYNetworkResponse()
@property (nonatomic, assign, readwrite) NSInteger statusCode;
@property (nonatomic, strong, readwrite) NSDictionary *allHeaderFields;
@property (nonatomic, strong, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) id responseObject;
@property (nonatomic, strong, readwrite) NSDictionary *responseJSONObject;
@property (nonatomic, strong, readwrite) NSString *responseString;

@end

@implementation RYNetworkResponse


#pragma mark - Public Methods

+ (RYNetworkResponse *)responseWithURLResponse:(NSURLResponse *)response resonseOjbect:(id)responseObject responseType:(RYNetworkResponseSerializerType)responseType responseSerializer:(AFHTTPResponseSerializer *)responseSerializer validationError:(NSError * _Nullable __autoreleasing *)validationError {
    RYNetworkResponse *RYResponse = [[RYNetworkResponse alloc] init];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    RYResponse.statusCode = httpResponse.statusCode;
    RYResponse.allHeaderFields = httpResponse.allHeaderFields;
    RYResponse.responseObject = responseObject;
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        RYResponse.responseData = responseObject;
        RYResponse.responseString =  [[NSString alloc] initWithData:responseObject encoding:[RYNetworkTool stringEncodingWithEncodingName:httpResponse.textEncodingName]];

        switch (responseType) {
            case RYNetworkResponseSerializerTypeHTTP:
                break;
            case RYNetworkResponseSerializerTypeJSON:
            {
                AFJSONResponseSerializer *jsonResponseSerializer  = (AFJSONResponseSerializer *)responseSerializer;
                responseObject = [jsonResponseSerializer responseObjectForResponse:response data:responseObject error:validationError];
                RYResponse.responseJSONObject = responseObject;
            }
                break;
            case RYNetworkResponseSerializerTypePlist:
            {
                AFJSONResponseSerializer *plistResponseSerializer  = (AFJSONResponseSerializer *)responseSerializer;
                RYResponse.responseObject = [plistResponseSerializer responseObjectForResponse:response data:responseObject error:validationError];
            }
                break;
            case RYNetworkResponseSerializerTypeXMLParser:
            {
                AFJSONResponseSerializer *xmlResponseSerializer  = (AFJSONResponseSerializer *)responseSerializer;
                RYResponse.responseObject = [xmlResponseSerializer responseObjectForResponse:response data:responseObject error:validationError];
            }
                break;
            default:
                break;
        }
    }
    
    if (*validationError) {
        return RYResponse;
    } else if ([RYResponse validateResponseWithError:validationError]) {
        return RYResponse;
    }
    

    return RYResponse;
}


#pragma mark - Private Methods

- (BOOL)validateResponseWithError:(NSError * _Nullable __autoreleasing *)error {
    BOOL result = [self validateResponseStatus];
    
    if (!result) {
        if (error) {
            *error = [NSError errorWithDomain:RYNetworkErrorHTTPErrorDomain code:self.statusCode userInfo:@{NSLocalizedDescriptionKey : @""}];
        }
        return result;
    }
    
    return NO;
}

- (BOOL)validateResponseStatus {
    return (self.statusCode >= 200 && self.statusCode < 299);
}


@end
