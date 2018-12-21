//
//  BWBaseResp.h
//  bwclassgoverment
//
//  Created by 马腾 on 2018/1/11.
//  Copyright © 2018年 beiwaionline. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum _ResponseCode
{
    ResponseCode_Success = 0,
    ResponseCode_Faild = 1
    //    ResponseCode_Success = 1,
    //    ResponseCode_DeviceVerifyFailed = 2,
    //    ResponseCode_UserVerifyFailed = 3,
    //    ResponseCode_SessionExpired = 4,
    //    ResponseCode_RequestVerifyFailed = 5,
    //    ResponseCode_ServerFailed = 6,
    //    ResponseCode_ParameterFailed = 7,
    //    ResponseCode_Register_NicknameUsed = 8,
    //    ResponseCode_Register_EmainlUsed = 9,
    //    ResponseCode_RequestAccessFailed = 10,
    //    ResponseCode_Purchase_BookAlreadyPaid = 11,
    //    ResponseCode_SoldOut_Political = 17,
    //    ResponseCode_SoldOut_ContentError = 18,
    //    ResponseCode_SoldOut_Copyright = 19,
    //    ResponseCode_SoldOut = 20
}ResponseCode;

@interface BWBaseResp : NSObject
@property (nonatomic, assign)ResponseCode errorCode;
@property (nonatomic, strong)NSString * errorMessage;
@property (nonatomic, strong)NSString *result;

- (id)initWithJSONDictionary:(NSDictionary*)jsonDic;
@end
