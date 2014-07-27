//
//  AFZSDManager.h
//  01_AFNetworking_Webservice
//
//  Created by Happy on 14-7-22.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@class ServiceResult;
@interface AFZSDManager : AFHTTPRequestOperationManager

/**
 *  singleton
 *
 *  @return AFZSDManager singleton
 */
+ (AFZSDManager *)sharedInstance;

/**
 *  post a webservice request
 *
 *  @param methodName  webservice request
 *  @param paramsArray parameters
 *  @param success     success callback
 *  @param failure     failure callback
 */
- (void)postRequest:(NSString *)methodName
         parameters:(NSArray *)paramsArray
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postWebserviceRequest:(NSString *)methodName
                   parameters:(NSArray *)paramsArray
                      success:(void(^)(ServiceResult* result))success
                      failure:(void(^)(NSError *error,NSDictionary *userInfo))failure;

/**
 *  cancel a webservice request
 *
 *  @param methodName webservice request
 *
 *  @return cancel result
 */
- (BOOL)cancelWebserviceRequest:(NSString*)methodName;

@end
