//
//  RYNetworkConst.h
//  RYNetworking
//
//  Created by Ryeagler on 2017/11/23.
//  Copyright © 2018年 Ryeagler. All rights reserved.
//

#ifndef RYNetworkConst_h
#define RYNetworkConst_h

typedef NS_ENUM(NSUInteger, RYNetworkRequestMethod) {
    RYNetworkRequestMethodGET,
    RYNetworkRequestMethodPOST,
    RYNetworkRequestMethodHEAD,
    RYNetworkRequestMethodPUT,
    RYNetworkRequestMethodDELETE,
    RYNetworkRequestMethodPATCH
};

typedef NS_ENUM(NSUInteger, RYNetworkRequestSerializerType) {
    RYNetworkRequestSerializerTypeHTTP         = 0,    //!< "Content-Type" is "application/x-www-form-urlencoded"
    RYNetworkRequestSerializerTypeJSON         = 1,    //!< "Content-Type" is "application/json"
    RYNetworkRequestSerializerTypePlist        = 2,    //!< "Content-Type" is "application/plist"
};

typedef NS_ENUM(NSUInteger, RYNetworkResponseSerializerType) {
    RYNetworkResponseSerializerTypeHTTP        = 0,
    RYNetworkResponseSerializerTypeJSON        = 1,
    RYNetworkResponseSerializerTypePlist       = 2,
    RYNetworkResponseSerializerTypeXMLParser   = 3,
};

typedef NS_ENUM(NSUInteger, RYNetworkRequestType) {
    RYNetworkRequestTypeNormal                 = 0,
    RYNetworkRequestTypeUpload                 = 1,
    RYNetworkRequestTypeDownload               = 2,
};

typedef NS_ENUM(NSUInteger, RYNetworkReachabilityStatus) {
    RYNetworkReachabilityStatusUnknown          = -1,
    RYNetworkReachabilityStatusNotReachable     = 0,
    RYNetworkReachabilityStatusReachableViaWWAN = 1,
    RYNetworkReachabilityStatusReachableViaWiFi = 2,
};

typedef NS_ENUM(NSUInteger, RYSSLPinningMode) {
    RYSSLPinningModeNone = 0,
    RYSSLPinningModeCertificate = 2,
};


#endif /* RYNetworkConst_h */
