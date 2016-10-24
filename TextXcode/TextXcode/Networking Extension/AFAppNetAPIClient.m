//
//  AFAppNetAPIClient.m
//  TextXcode
//
//  Created by zm on 2016/10/24.
//  Copyright © 2016年 zmMac. All rights reserved.
//

#import "AFAppNetAPIClient.h"

@implementation AFAppNetAPIClient
+ (instancetype)shareClient{
    static AFAppNetAPIClient * shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareClient = [[AFAppNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];

    });
    return shareClient;
}

- (void)Get:(NSString *)URLString
 parameters:(NSDictionary *)parameters
completionHandler:(void(^)(id responseObject, NSError * error))completionHandler{
    
    [[AFAppNetAPIClient shareClient] GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        completionHandler(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionHandler(nil, error);
    }];
}


@end
