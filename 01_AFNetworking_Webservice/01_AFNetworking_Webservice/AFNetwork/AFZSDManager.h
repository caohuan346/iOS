//
//  AFZSDManager.h
//  01_AFNetworking_Webservice
//
//  Created by Happy on 14-7-22.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface AFZSDManager : AFHTTPRequestOperationManager

+ (AFZSDManager *)sharedInstance;

@end
