//
//  ServiceResult.m
//  ZOSENDA
//
//  Created by hc on 14-7-17.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFHTTPRequestOperationManager.h"
#import "XmlParseHelper.h"

@interface ServiceResult : NSObject

@property(nonatomic,assign) AFHTTPRequestOperationManager *requestManager;

@property(nonatomic,assign) AFHTTPRequestOperation *request;

@property(nonatomic,retain) NSDictionary *userInfo;

@property(nonatomic,copy) NSString *nameSpace;

@property(nonatomic,copy) NSString *methodName;

@property(nonatomic,copy) NSString *xmlnsAttr;

//xml转换类
@property(nonatomic,retain) XmlParseHelper *xmlParse;

//原始返回的soap字符串
@property(nonatomic,copy) NSString *xmlString;

//调用webservice方法里面的值
@property(nonatomic,copy) NSString *xmlValue;

-(id)initWithResultManger:(AFHTTPRequestOperationManager *)requestManager request:(AFHTTPRequestOperation *)request;

@end
