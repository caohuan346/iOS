//
//  AFZSDManager.m
//  01_AFNetworking_Webservice
//
//  Created by Happy on 14-7-22.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import "AFZSDManager.h"
#import "ServiceArgs.h"

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
        _sharedInstance.responseSerializer.acceptableContentTypes = [_sharedInstance.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        
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
    [self.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"content-type"];
    return self;
}

- (AFHTTPRequestOperation *)POSTMethod:(NSString *)methodName
                      parameters:(NSArray *)paramsArray
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    ServiceArgs *args = [[ServiceArgs alloc] initWithMethodName:methodName soapParamsArray:paramsArray];
    [self requestWithServerArgs:args];
    
    return [self POST:[args serviceURL] parameters:nil success:success failure:failure];
}

- (void)requestWithServerArgs:(ServiceArgs*)args{
    /*
     NSString *msgLength = [NSString stringWithFormat:@"%d", [args.soapMessage length]];
     AFHTTPRequestOperation  *request=[AFHTTPRequestOperation requestWithURL:args.webURL];
     
     //以下对请求信息添加属性前四句是必有的，第五句是soap信息。
     [request addRequestHeader:@"Host" value:[args.webURL host]];
     [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
     [request addRequestHeader:@"Content-Length" value:msgLength];
     [request addRequestHeader:@"SOAPAction" value:[self soapAction:args.serviceNameSpace methodName:args.methodName]];
     [request setRequestMethod:@"POST"];
     
     //设置用户信息
     //[self.httpRequest setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:args.methodName,@"name", nil]];
     
     //传soap信息
     [request appendPostData:[args.soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
     [request setValidatesSecureCertificate:NO];
     [request setTimeOutSeconds:30.0];//表示30秒请求超时
     [request setDefaultResponseEncoding:NSUTF8StringEncoding];
     
     return request;
     */
    
    NSString *msgLength = [NSString stringWithFormat:@"%d", [args.soapMessage length]];
    NSString *soapAction = [self soapAction:args.serviceNameSpace methodName:args.methodName];
    
    [self.requestSerializer setValue:[args.webURL host] forHTTPHeaderField:@"Host"];
    [self.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"content-type"];
    [self.requestSerializer setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [self.requestSerializer setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    
//    self.requestSerializer.
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
