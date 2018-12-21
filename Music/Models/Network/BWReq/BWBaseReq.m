//
//  BWBaseReq.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWBaseReq.h"

@implementation BWBaseReq

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (NSURL *)url
{
    return nil;
}

- (NSMutableDictionary *)getRequestParametersDictionary
{
    NSMutableDictionary *JSONDict = [NSMutableDictionary dictionary];
    
    return JSONDict;
}
- (BOOL)isSecurityPolicy
{
    return YES;
}
-(BOOL)isCancel
{
    return YES;
}

@end
