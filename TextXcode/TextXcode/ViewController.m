//
//  ViewController.m
//  TextXcode
//
//  Created by zm on 2016/10/24.
//  Copyright © 2016年 zmMac. All rights reserved.
//

#import "ViewController.h"
#import "AFAppNetAPIClient.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AFAppNetAPIClient shareClient] Get:@"mobile/mainPageQuanNew" parameters:@{@"FansNo":@"-1", @"UserType":@"1"} cacheTime:3000 completionHandler:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }else{
            NSLog(@"%@", responseObject);
        }
    }];
//    [[AFAppNetAPIClient shareClient] Get:@"mobile/mainPageQuanNew" parameters:@{@"FansNo":@"-1", @"UserType":@"1"} completionHandler:^(id responseObject, NSError *error) {
//        
//    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
