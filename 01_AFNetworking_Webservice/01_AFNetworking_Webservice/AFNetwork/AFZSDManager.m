//
//  AFZSDManager.m
//  01_AFNetworking_Webservice
//
//  Created by Happy on 14-7-22.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import "AFZSDManager.h"
#import "ServiceArgs.h"
#import "ServiceResult.h"

//#import "AFXMLRequestOperation.h"

//static NSString * const kAFTwitterAPIBaseURLString = @"http://www.oschina.net/action/api/";
//static NSString * const kAFUrl = @"http://"
//#define kAFUrl @"http://192.168.1.213/action/api/"
//#define kAFUrl @"http://www.oschina.net/action/api/"
#define kAFUrl @"http://www.baidu.com"

@implementation AFZSDManager

+ (AFZSDManager *)sharedInstance {
    static AFZSDManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedInstance = [[AFZSDManager alloc] initWithBaseURL:[NSURL URLWithString:kAFUrl]];
        
        _sharedInstance.responseSerializer = [AFHTTPResponseSerializer serializer];
        //_sharedInstance.responseSerializer.acceptableContentTypes = [_sharedInstance.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        
        //[_sharedInstance.requestSerializer setValue:@"User-Agent" forHTTPHeaderField:@""];
        // [_sharedClient setDefaultHeader:@"User-Agent" value:[NSString stringWithFormat:@"%@/%@", [Tool getOSVersion], [Config Instance].getIOSGuid]];
        
    });
    
    return _sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    //[self registerHTTPOperationClass:[AFXMLRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    
	//[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    //[self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[self.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"content-type"];
    
    return self;
}

-(void)postRequest:(NSString *)methodName
        parameters:(NSArray *)paramsArray
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    ServiceArgs *args = [[ServiceArgs alloc] initWithMethodName:methodName soapParamsArray:paramsArray];
    
    NSString *soapLength = [NSString stringWithFormat:@"%d", [args.soapMessage length]];
    NSString *soapAction = [self soapAction:args.serviceNameSpace methodName:args.methodName];
    
    self.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [self.requestSerializer setValue:[args.webURL host] forHTTPHeaderField:@"Host"];
    [self.requestSerializer setValue:soapLength forHTTPHeaderField:@"Content-Length"];
    //[self.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"content-type"];
    [self.requestSerializer setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[args serviceURL] parameters:nil error:nil];
    [request setHTTPBody:[args.soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    [request setTimeoutInterval:30.0];
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    [self.operationQueue addOperation:operation];
}

- (void)postWebserviceRequest:(NSString *)methodName
                   parameters:(NSArray *)paramsArray
                      success:(void(^)(ServiceResult* result))success
                      failure:(void(^)(NSError *error,NSDictionary *userInfo))failure{
    
    [self postRequest:methodName
           parameters:paramsArray
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  ServiceResult *serviceresult=[[ServiceResult alloc] initWithResultManger:self request:operation];
                  if (success) {
                      success(serviceresult);
                  }
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if (failure) {
                      if ([[operation.error description]  rangeOfString:@"cancelled"].location == NSNotFound  ) {
                          failure(operation.error,operation.userInfo);
                      }
                  }
              }];
}

- (BOOL)cancelWebserviceRequest:(NSString*)methodName {
    NSArray *array=[self.operationQueue operations];
    for (AFHTTPRequestOperation *operation in array) {
        NSString *soapActionInfo = [self.requestSerializer HTTPRequestHeaders][@"SOAPAction"];
        if ([soapActionInfo rangeOfString:methodName].location != NSNotFound) {
            [operation cancel];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - private
- (NSString*)soapAction:(NSString*)namespace methodName:(NSString*)methodName{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/$" options:0 error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:namespace options:0 range:NSMakeRange(0, [namespace length])];
    //NSArray *array=[regex matchesInString:namespace options:0 range:NSMakeRange(0, [namespace length])];
    
    if(numberOfMatches>0){
        return [NSString stringWithFormat:@"%@%@",namespace,methodName];
    }
#warning ---- soapAction generate
    //return [NSString stringWithFormat:@"%@/ZSDServices/%@",[namespace stringByReplacingOccurrencesOfString:@"https:" withString:@"http:"],methodName];
    return [NSString stringWithFormat:@"%@/%@",[namespace stringByReplacingOccurrencesOfString:@"https:" withString:@"http:"],methodName];
}

@end
