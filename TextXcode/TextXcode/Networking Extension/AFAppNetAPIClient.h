//
//  AFAppNetAPIClient.h
//  TextXcode
//
//  Created by zm on 2016/10/24.
//  Copyright © 2016年 zmMac. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFAppNetAPIClient : AFHTTPSessionManager
+ (instancetype)shareClient;
- (void)Get:(NSString *)URLString
 parameters:(NSDictionary *)parameters
  cacheTime:(NSInteger)time
completionHandler:(void(^)(id responseObject, NSError * error))completionHandler;
@end
