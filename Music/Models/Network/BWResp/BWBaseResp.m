//
//  BWBaseResp.m
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import "BWBaseResp.h"

@implementation BWBaseResp
@synthesize errorCode = _errorCode, errorMessage = _errorMessage;

- (id)initWithJSONDictionary: (NSDictionary*)jsonDic
{
    if (self = [super init])
    {        
//        _errorMessage = [jsonDic safeObjectForKey:@"message"];
//        _result = [jsonDic safeObjectForKey:@"result"];
//        if ([jsonDic safeObjectForKey:@"success"]){
//            _success = [[jsonDic safeObjectForKey:@"success"] boolValue];
//        }
    }
    return self;
}
@end
