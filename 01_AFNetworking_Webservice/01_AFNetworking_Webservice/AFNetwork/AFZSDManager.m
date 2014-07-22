//
//  AFZSDManager.m
//  01_AFNetworking_Webservice
//
//  Created by Happy on 14-7-22.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import "AFZSDManager.h"

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


@end
