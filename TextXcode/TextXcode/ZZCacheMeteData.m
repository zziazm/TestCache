//
//  ZZCacheMeteData.m
//  TextXcode
//
//  Created by zm on 2016/10/24.
//  Copyright © 2016年 zmMac. All rights reserved.
//

#import "ZZCacheMeteData.h"

@implementation ZZCacheMeteData
+ (BOOL)supportsSecureCoding{
    return YES;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_creationDate forKey:@"creationDate"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init] ) {
        _creationDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:@"creationDate"];
    }
    return self;
}

@end
