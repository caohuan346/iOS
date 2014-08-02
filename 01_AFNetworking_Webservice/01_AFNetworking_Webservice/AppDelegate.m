//
//  AppDelegate.m
//  01_AFNetworking_Webservice
//
//  Created by hc on 14-7-21.
//  Copyright (c) 2014年 ZOSENDA GROUP. All rights reserved.
//

#import "AppDelegate.h"
#import "AFZSDManager.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "ServiceResult.h"

#define api_news_list @"http://www.oschina.net/action/api/news_list"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
     NSString *URLTmp = @"http://www.coneboy.com";
     NSString *URLTmp1 = [URLTmp stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  //转码成UTF-8  否则可能会出现错误
     URLTmp = URLTmp1;
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: URLTmp]];
     AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
     [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"Success: %@", operation.responseString);
     
     NSString *requestTmp = [NSString stringWithString:operation.responseString];
     NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
     //系统自带JSON解析
     NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Failure: %@", error);
     }];
     [operation start];
     */
    
    //访问帖子
    /*
     NSString *url = [NSString stringWithFormat:@"%@?catalog=%d&pageIndex=%d&pageSize=%d", api_news_list, 1, 1, 20];
     [[AFZSDManager sharedInstance] GET:url parameters
     :nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"%@",operation.responseString);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"fail");
     }];
     */
    
    NSMutableArray *params=[NSMutableArray array];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"13467803712",@"mobileCode", nil]];
    [params addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"userID", nil]];
    
    
//    [[AFZSDManager sharedInstance] postRequest:@"getMobileCodeInfo" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"%@, %@", operation, response);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSString *response = [[NSString alloc] initWithData:(NSData *)[operation responseObject] encoding:NSUTF8StringEncoding];
//        NSLog(@"%@, %@", response, error);
//    }];
    
    
    [[AFZSDManager sharedInstance] postWebserviceRequest:@"getMobileCodeInfo" parameters:params success:^(ServiceResult *result) {
        NSLog(@"%@",result.xmlParse);
        
        NSArray *array=[result.xmlParse soapXmlSelectNodes:@"//xmlns:getMobileCodeInfoResult"];
        NSString *numberInfo = array[0][@"text"];
        NSLog(@"%@",numberInfo);
    } failure:^(NSError *error, NSDictionary *userInfo) {
        NSLog(@"Error: %@", error);
    }];
    
    //[[AFZSDManager sharedInstance] cancelWebserviceRequest:@"getMobileCodeInfo"];
    
    /*
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
     [manager GET:@"http://www.baidu.com" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     NSLog(@"JSON: %@", responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"Error: %@", error);
     }];
     */
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
