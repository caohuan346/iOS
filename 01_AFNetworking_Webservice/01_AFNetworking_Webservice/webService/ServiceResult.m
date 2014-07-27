//
//  ServiceResult.m
//  ZOSENDA
//
//  Created by hc on 14-7-17.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import "ServiceResult.h"

@implementation ServiceResult

-(id)initWithResultManger:(AFHTTPRequestOperationManager *)requestManager request:(AFHTTPRequestOperation *)request{
    if (self = [super init]) {
        if (request) {
            //nameSpace
            NSString *soapAction = [requestManager.requestSerializer HTTPRequestHeaders][@"SOAPAction"];
            NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
            if(range.location!=NSNotFound){
                int pos=range.location;
                self.nameSpace=[soapAction substringWithRange:NSMakeRange(0, pos+1)];
            }
            
            //xmlString
            NSString *temp=[request responseString];
            NSError *error=[request error];
            if (error) {
                temp=@"";
            }
            self.xmlString = temp;
            
            //userInfo
            self.userInfo=[request userInfo];
        }

        //mothodName
        if (requestManager) {
            int len=[self.nameSpace length];
            NSString *soapAction = [requestManager.requestSerializer HTTPRequestHeaders][@"SOAPAction"];
            if(len>0){
                self.methodName = [soapAction stringByReplacingCharactersInRange:NSMakeRange(0,len) withString:@""];
            }
        }
        
        //xmlnsAttr
        self.xmlnsAttr = [NSString stringWithFormat:@"xmlns=\"%@\"", self.nameSpace];
        
        self.request = request;
        self.requestManager = requestManager;
        XmlParseHelper *_helper=[[[XmlParseHelper alloc] initWithData:self.xmlString] autorelease];
        self.xmlParse=_helper;
        self.xmlValue=[_helper soapMessageResultXml:self.methodName];
    }
    
    return self;
}

@end
