//
//  AFAppNetAPIClient.m
//  TextXcode
//
//  Created by zm on 2016/10/24.
//  Copyright © 2016年 zmMac. All rights reserved.
//

#import "AFAppNetAPIClient.h"
#import <CommonCrypto/CommonDigest.h>
#import "ZZCacheMeteData.h"
@implementation AFAppNetAPIClient
+ (instancetype)shareClient{
    static AFAppNetAPIClient * shareClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareClient = [[AFAppNetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://ag.chengyiapp.com/mobile"]];

    });
    return shareClient;
}

- (void)Get:(NSString *)URLString
 parameters:(NSDictionary *)parameters
  cacheTime:(NSInteger)time
completionHandler:(void(^)(id responseObject, NSError * error))completionHandler{
    NSString *path = [self cacheBasePath];
    NSString *cacheMetadataFileName = [NSString stringWithFormat:@"%@.metadata", [self cacheFileNameWithMethord:@"GET" URL:URLString parameters:parameters]];
    NSString * cacheMeteaFilePath = [path stringByAppendingPathComponent:cacheMetadataFileName];
    
    NSString *cacheFileName = [self cacheFileNameWithMethord:@"GET" URL:URLString parameters:parameters];
    NSString * cacheFilePath = [path stringByAppendingPathComponent:cacheFileName];
    
    if (time > 0) {
        ZZCacheMeteData * cacheMeteData = [self loadCacheMeteDataWithPath:cacheMeteaFilePath];
        if (cacheMeteData) {
            NSTimeInterval timeInterval = -[cacheMeteData.creationDate timeIntervalSinceNow];
            if (timeInterval < time) {
                NSData *data = [self loadCacheDataWithPath:cacheFilePath];
                if (data) {
                   NSDictionary * dic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    completionHandler(dic ,nil);
                    return;
                }

            }
        }
    }
    
    [[AFAppNetAPIClient shareClient] GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        completionHandler(responseObject, nil);
        if (time > 0) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
                ZZCacheMeteData * cacheMeteData = [[ZZCacheMeteData alloc] init];
                cacheMeteData.creationDate = [NSDate date];
                [NSKeyedArchiver archiveRootObject:cacheMeteData toFile:cacheMeteaFilePath];
                if (responseObject) {
                    NSData * data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                   BOOL success =  [data writeToFile:cacheFilePath atomically:YES];
                    if (success) {
                        NSLog(@"s");
                    }else{
                        NSLog(@"n");
                    }
                }
            });
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completionHandler(nil, error);
    }];
}

- (void)createDirectoryIfNeed:(NSString *)path{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        if (!isDir) {
            [fileManager removeItemAtPath:path error:nil];
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
}

- (NSString * )cacheBasePath{
    NSString * libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString * path = [libraryPath stringByAppendingPathComponent:@"ZZCacheRequest"];
    [self createDirectoryIfNeed:path];
    return path;
}

- (NSString *)cacheFileNameWithMethord:(NSString *)methord
                                   URL:(NSString *)URL
                            parameters:(NSDictionary *)parameters

{
    NSString * baseURL = [AFAppNetAPIClient shareClient].baseURL.path;
    NSString * requsetInfo = [NSString stringWithFormat:@"Methord:%@ Host:%@ Url:%@ Parameters:%@",methord, baseURL,URL,parameters];
    NSString * cacheFileName = [AFAppNetAPIClient md5StringFromString:requsetInfo];
    return cacheFileName;
}
+ (NSString *)md5StringFromString:(NSString *)string {
    NSParameterAssert(string != nil && [string length] > 0);
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}
- (ZZCacheMeteData *)loadCacheMeteDataWithPath:(NSString *)path{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
       return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }else{
        return nil;
    }
}
- (NSData *)loadCacheDataWithPath:(NSString *)path{
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSData * data = [NSData dataWithContentsOfFile:path];
        return data;
    }else{
        return nil;
    }
}
@end
