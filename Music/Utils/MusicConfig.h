//
//  MusicConfig.h
//  Music
//
//  Created by 马腾 on 2018/12/7.
//  Copyright © 2018 beiwaionline. All rights reserved.
//

#ifndef MusicConfig_h
#define MusicConfig_h


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define NAV_HEIGHT  64

#define BW_NavBarHeight 44.0

#define BW_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height //状态栏高度
#define BW_TopHeight (BW_StatusBarHeight + BW_NavBarHeight)

#define DefineWeakSelf __weak __typeof(self) weakSelf = self

#define STATUS_BAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125,2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define myBlueColor [UIColor colorWithRed:63.0/255.0 green:111.0/255.0 blue:219.0/255.0 alpha:1.0]
#define lightBlueColor [UIColor colorWithRed:73.0/255.0 green:161.0/255.0 blue:232.0/255.0 alpha:1.0]
#define BWColor(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d]

#define ADAPTATION_X(x) (((x)*[[UIScreen mainScreen] bounds].size.width)/640)

#define ADAPTATION_Y(y) (((y)*(iPhoneX ? [[UIScreen mainScreen] bounds].size.height - 147 : [[UIScreen mainScreen] bounds].size.height))/1134)

#define adaptation_x(x) ((x)*SCREEN_WIDTH/375)

#define adaptation_y(y) (((y)*(iPhoneX ? SCREEN_HEIGHT - 147 : SCREEN_HEIGHT))/667)

#if DEBUG
#define logtrace() NSLog(@"%s():%d ", __func__, __LINE__)
#define logdebug(format, ...) NSLog(@"%s():%d "format, __func__, __LINE__, ##__VA_ARGS__)
#else
#define logdebug(format, ...)
#define logtrace()
#endif

#define loginfo(format, ...) NSLog(@"%s():%d "format, __func__, __LINE__, ##__VA_ARGS__)

#define logerror(format, ...) NSLog(@"%s():%d ERROR "format, __func__, __LINE__, ##__VA_ARGS__)

//判断数组是否为空
#define IS_VALID_ARRAY(array) (array && ![array isEqual:[NSNull null]] && [array isKindOfClass:[NSArray class]] && [array count])
//判断字符串是否为空
#define IS_VALID_STRING(string) (string && ![string isEqual:[NSNull null]] && [string isKindOfClass:[NSString class]] && [string length])

#define kRootView [UIApplication sharedApplication].keyWindow.viewForLastBaselineLayout

//下载视频使用
#define BWDownloadHelper_Document_Path  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define BWDownloadHelper_DownloadDataDocument_Path   [BWDownloadHelper_Document_Path           stringByAppendingPathComponent:@"BWDownloadHelper_DownloadDataDocument_Path"]

#define BWDownloadHelper_DownloadSources_Path  [BWDownloadHelper_Document_Path stringByAppendingPathComponent:@"BWDownloadHelper_downloadSources.data"]

#define BWDownloadHelper_OffLineStyle_Key                @"BWDownloadHelper_OffLineStyle_Key"

#define BWDownloadHelper_OffLine_Key                     @"BWDownloadHelper_OffLine_Key"

#define BWDownloadHelper_Limit                           1024.0

#define BWDownloadHelper_DownloadFinishedSources_Path        [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BWDownloadHelper_DownloadFinishedSources.data"]

#define BWDownloadHelper_DownloadCourseListSources_Path        [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"BWDownloadHelper_DownloadCourseListSources.data"]
//下载PDF使用
#define BWDownloadHelper_DownloadPDFSources_Path [BWDownloadHelper_Document_Path           stringByAppendingPathComponent:@"PDFFiles"]

#define BWDownloadHelper_setPDFSources_Path  [[BWDownloadHelper_Document_Path stringByAppendingPathComponent:@"PDFFiles"] stringByAppendingPathComponent:@"BWDownloadHelper_PDFSources.data"]


#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

//刷新答题页面内容
#define UpdateExamContent @"UpdateExamContent"

//竖屏使用
#define PAdaptation_x(x) ((x)*SCREEN_WIDTH/375)
#define PAaptation_y(y) (((y)*(iPhoneX ? SCREEN_HEIGHT - 147 : SCREEN_HEIGHT))/667)
//横屏使用
#define LAdaptation_x(x) ((x)*(iPhoneX ? SCREEN_WIDTH - 147 : SCREEN_WIDTH)/667)
#define LAdaptation_y(y) ((y)*SCREEN_HEIGHT/375)

//用户信息
#define KEY_UserName      @"userName"
#define KEY_Email         @"email"
#define KEY_Password      @"password"
#define KEY_SessionID     @"sessionId"
#define KEY_UserID        @"userId"
#define KEY_PhoneNum      @"phoneNum"
#define KEY_Name          @"name"
#define KEY_PersonInfo    @"psrsonInfo"
#define KEY_ServerDate    @"serverDate"
#define KEY_Token         @"myToken"
#define KEY_LoginName     @"loginName"
#define KEY_ClientId      @"clientId"
#define KEY_Visitor       @"visitor"
#define KEY_Recharge      @"Recharge"
#define KEY_orgCode       @"orgCode"
#define KEY_uid           @"uid"
#define KEY_isQuickLogin  @"isQuickLogin"
#define KEY_mobile        @"mobile"
#define KEY_nikeName      @"nikeName" //昵称
#define KEY_centerId      @"centerId" //合并的userID

//sina微博
#define Sina_APPID        @"1229426148"
#define Sina_APPSECRET    @"4ba55d5cb646d5615740c1d3772111ea"

//qq
#define QQ_APPID          @"1105139818"
#define QQ_APPSECRET      @"AAtDs06K2E8RHeXA"

//支付宝
#define AliPay_APPID            @"2016012001108580"
#define AliPay_APPSECRET        @"2b0dd38342764deab39c3f94f278d14e"

//微信
#define WX_APPID          @"wx5ac6726194d2d380"
#define WX_APPSECRET      @"b172e8e78ddd194a6854e0468cf0bdbe"
#define PARTNER_KEY       @"2n57USmL3FB1lyxbZfUb4O2GYZr7odRx"

//cc视频
#define DWACCOUNT_APIKEY  @"4kNaGypuakX5p5Z9S1eazCFyI1RpjWVs"
#define DWACCOUNT_USERID  @"A99AFDD6E0061837"

//bugly统计
#define Bugly_APPID       @"f40aab0fb9"
#define Bugly_APPKEY      @"694020b5-e31b-4157-aa75-aba4dab66630"

//驰声科技
#define kAppKey @"1492744084000003"
#define kSecretKey @"709ee8756d8f18d41b151374cb6a5dcb"

//百度统计
#define BaiduAPPKey @"2e829b78bc"

//极光推送
#define JPushAppKey @"3dd330c33fc7139f8fbd87b2"
#endif /* MusicConfig_h */
