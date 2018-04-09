//
//  umfPaySdkIphone.h
//  umfPaySdkIphone
//
//  Created by zhaoyingxin on 17/1/6.
//  Copyright © 2017年 UMF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum UMFPayResult {
    kUMFPayResultSuccess = 0,   // 支付成功
    kUMFPayResultCancel = 1,    // 取消支付
    kUMFPayResultError = 2,     // 支付失败
    kUMFPayResultFinished = 3,  // 支付完成,商户需要自己查单
} UMFPayResult;

typedef enum UMFPayType {
    kUMFChinaUnionPay = 0,  // H5支付
    kUMFApplePay = 1,       // applePay支付
    kUMFWXPay = 2,          // 微信支付
    kUMFAlipay = 3,         // 支付宝
    kUMFNoCanUsePay = 9,    // 没有可用的支付方式
} UMFPayType;
@protocol umfPaySdkDelegate <NSObject>

@required

/**
 * wxResultCode 微信支付返回的状态码,其他支付方式用不到
 */
- (void)paymentEnd:(UMFPayResult)resultCode withPayType:(UMFPayType)payType wxResultCode:(int)wxCode;

@end

@interface umfPaySdkIphone : NSObject

@property (nonatomic, assign) id<umfPaySdkDelegate> sdkDelegate;

+(instancetype)sharedUmfManager;

/*! @brief 处理Apple Pay注册的merchantId
 *  需要在每次启动第三方应用程序时调用。
 */
- (void)umfRegisterMerchant:(NSString *)merchantId;


/*! @brief 商户后台向联动支付后台下支付订单,这里传入联动返回的支付订单号和商户编号初始化SDK支付能力
 * @param orderInfoDic 传入订单参数
 *
 * NOTICE : 联动支付SDK会展示 [微信支付/Apple Pay/银行卡支付] 支付类型列表
 */
- (void)initializePayment:(NSDictionary *)orderInfoDic;


/*! @brief 商户后台向联动支付后台下支付订单,这里传入联动返回的支付订单号和商户编号初始化SDK支付能力
 * @param orderInfoDic 传入订单参数
 *
 * NOTICE : 直接触发ApplePay,联动支付SDK不会展示支付类型列表
 */
- (void)initializeApplePayment:(NSDictionary *)orderInfoDic
            withViewController:(UIViewController *)viewController;


/*! @brief 商户后台向联动支付后台下支付订单,这里传入联动返回的支付订单号和商户编号初始化SDK支付能力
 * @param orderInfoDic 传入订单参数
 *
 * NOTICE : 直接触发H5页面支付,联动支付SDK不会展示 微信支付 ApplePay 支付类型列表
 */
- (void)initializeWebPayment:(NSDictionary *)orderInfoDic
                       navVC:(UINavigationController *)navVC;

//-------------------------------------------------------------------------
// 微信支付
//-------------------------------------------------------------------------

/*! @brief WXApi成员函数的封装，向微信终端程序注册第三方应用。
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现。
 * @see registerApp
 * @param appid 微信开发者ID
 * @param appdesc 应用附加信息，长度不超过1024字节
 * @return 成功返回YES，失败返回NO。
 */
//- (BOOL)umfRegisterApp:(NSString *)appid withDescription:(NSString *)appdesc;
- (BOOL)umfRegisterApp:(NSString *)appid;

/*! @brief 处理微信通过URL启动App时传递的数据
 * 需在 application:openURL:sourceApplication:annotation:
 * 或者application:handleOpenURL中调用。
 * @param url 微信启动第三方应用时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
- (BOOL)umfHandleOpenUrl:(NSURL *)url;


/*! @brief 商户后台向联动支付后台下支付订单,这里传入联动返回的支付订单号和商户编号初始化SDK支付能力
 * @param orderInfoDic 传入订单参数
 *
 * NOTICE : 直接触发微信支付,联动支付SDK不会展示支付类型列表
 */
- (void)initializeWeiXinPayment:(NSDictionary *)orderInfoDic;


/*! @brief 微信支付结果查询接口
 *
 */
-(void)wxPaymentEnd;

- (BOOL)isSupportWXPay;
- (void)wxPayOrder:(NSDictionary *)orderInfo;
- (void)weixinPayOrder:(NSDictionary *)elements;

//-------------------------------------------------------------------------
// 支付宝
//-------------------------------------------------------------------------
- (void)initializeAlipayPayment:(NSDictionary *)orderInfoDic;
- (void)alipaymentEnd;
@end
