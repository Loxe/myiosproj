//
//  HttpDefines.h
//  akucun
//
//  Created by Jarry on 16-6-19.
//  Copyright (c) 2016年 Sucang. All rights reserved.
//

#ifndef __HttpDefines_h__
#define __HttpDefines_h__

#if   AKTEST      // 测试版

#define     kHTTPServer         @"http://api.test.akucun.com"     // 测试
//#define     kHTTPServer         @"http://192.168.120.19:8080"       // 开发
//#define     kHTTPServer         @"http://api.aikucun.com"
//#define     kHTTPServer         @"http://192.168.200.133:8080"

#else

#if DEBUG
/**
 *  测试环境 服务器配置
 */
//#define     kHTTPServer         @"http://api.test.akucun.com"
//#define     kHTTPServer         @"http://192.168.30.90:8080"
#define     kHTTPServer         @"http://api.aikucun.com"

#else
/**
 *  生产环境 服务器配置
 */
#define     kHTTPServer         @"http://api.aikucun.com"

#endif

#endif

/**
 *  APP API 版本号
 */
#define     kClientAPIVersion   @"2.0"

/**
 *  Server API 版本号
 */
#define     kAPIVersion         @"v2.0"

/**
 *  APP ID & Secret
 */
#define     kAPI_AppID          @"28765893"
#define     kAPI_AppSecret      @"54376531e4c941fca68d2adcef7b586e"

/**
 *  HTTP Response Status
 */
#define     HTTP_STATUS_SUCCESS     @"success"
#define     HTTP_STATUS_ERROR       @"error"
#define     HTTP_STATUS_FAIL        @"fail"

#define     kPAGE_SIZE              20

/**
 *  Pay Type
 */
#define     kPayTypeALIPAY      1
#define     kPayTypeWEIXIN      2
#define     kPayTypeYUE         3
#define     kPayTypeUMFAliPay           11      // 联动 支付宝
#define     kPayTypeUMFWXPay            12      // 联动 微信支付
#define     kPayTypeUMFChinaUnionPay    13      // 联动 银联快捷支付

/**
 *  URL define
 */
#define     URL_VIPLEVEL_RULE       FORMAT(@"%@/teaminviterule.do?action=viplevel", kHTTPServer)


/**
 *  API Uri define
 */
#define     API_URI_USER            @"user.do"
#define     API_URI_LIVE            @"live.do"
#define     API_URI_PRODUCT         @"product.do"
#define     API_URI_CART            @"cart.do"
#define     API_URI_ORDER           @"order.do"
#define     API_URI_DELIVER         @"deliver.do"
#define     API_URI_SYSTEM          @"sys.do"
#define     API_URI_MESSAGE         @"msg.do"
#define     API_URI_KEFU            @"kefu.do"
#define     API_URI_AFTERSALE       @"aftersale.do"
#define     API_URI_DISCOVER        @"discover.do"
#define     API_URI_INVITE          @"userinvite.do"
#define     API_URI_TEAM            @"team.do"
#define     API_URI_IDEOS           @"ideos.do"
#define     API_URI_ENTRY           @"entry.do"

// v2.0
#define     ACTION_AUTH_CODE        @"authcode"
#define     ACTION_PHONE_LOGIN      @"phonelogin"
#define     ACTION_THIRD_LOGIN      @"thirdlogin"
#define     ACTION_BIND_PHONE       @"bindphonenum"
#define     ACTION_SUB_LOGIN        @"subuserlogin"

#define     ACTION_USER_ACTIVATE    @"activeupload"
#define     ACTION_USER_GETINFO     @"getinfo"
#define     ACTION_USER_ADDRLIST    @"addrlistnew"          // 新增0407
#define     ACTION_USER_ADDADDR     @"addaddrNewVersion"    // @"addaddr"
#define     ACTION_USER_MODIFYADDR  @"modifyaddrnew"        // 新增0407
#define     ACTION_USER_DEFAULTADDR @"defaultaddr"
#define     ACTION_USER_DELADDR     @"deladdr"
#define     ACTION_USER_UNBIND_SUB  @"removeSubMumber"

#define     ACTION_USER_USECODE     @"usereferralcodeNew"
#define     ACTION_USER_ACTIVECODE  @"activeuser"
#define     ACTION_USER_INVITELIST  @"pagemyreferral"
#define     ACTION_USER_INVITE      @"invite"
#define     ACTION_USER_INVIDETAIL  @"userinviteDetail"
#define     ACTION_USER_TEAMINFO    @"info"
#define     ACTION_USER_TEAMMEMBER  @"member"
#define     ACTION_USER_TEAMDETAIL  @"teamDetail"
#define     ACTION_USER_REFCODELIST @"getAllRefCode"
#define     ACTION_USER_SHARE_CODE  @"shareRefCode"
#define     ACTION_USER_LEVELSTATUS @"finduserlevelstatu"

#define     ACTION_USER_LIVELIST    @"pageAfterAction"  // 用户参与过的活动列表
#define     ACTION_USER_LIVEPRODUCT @"pageLiveProduct"  // 用户某个活动的订单商品
#define     ACTION_USER_SEARCH_PROD @"LiveProductByInfo" // 用户搜索指定活动的订单商品

#define     ACTION_LIVE_TRAILER     @"preparation"      // 活动预告
#define     ACTION_LIVE_LIST        @"todayAction"      // 活动中列表
#define     ACTION_LIVE_PACKAGE     @"cutLiving"        // 切货活动列表
#define     ACTION_LIVE_PRODUCTS    @"getProductAct"    // 同步活动商品
#define     ACTION_LIVE_TRACK_SKU   @"trackSkus"        // 跟踪活动商品SKU
#define     ACTION_LIVE_UPDATE      @"getActById"       // 根据活动id获取活动信息
#define     ACTION_LIVE_LISTALL     @"allactivity"      // 活动列表
#define     ACTION_LIVE_CHECKUPDATE @"isUpdateActivity"

#define     ACTION_CART_LIST        @"getcart"
#define     ACTION_CART_CLEAR       @"outofstock"
#define     ACTION_CART_RECYCLE     @"recyclelist"
#define     ACTION_CART_STATUS      @"saveCartStatus"

#define     ACTION_ORDER_CREATE     @"createnew"        //@"create" 兼容关联账号获取地址
#define     ACTION_ORDER_PAY        @"pay"
#define     ACTION_ORDER_PAYQUERY   @"payquery"
#define     ACTION_ORDER_PAGE       @"page"
#define     ACTION_ORDER_DETAIL     @"detail"
#define     ACTION_ORDER_CANCEL_P   @"cancelProduct"
#define     ACTION_ORDER_IS_CANCEL  @"isCancel"         // 是否可以取消商品
#define     ACTION_ORDER_CANCEL     @"cancelOrder"
#define     ACTION_ORDER_CHANGE     @"changeProduct"
#define     ACTION_ORDER_COUNT      @"statOrder"
#define     ACTION_ORDER_AFTERSALE  @"pageAfterSale"
#define     ACTION_ORDER_BUY        @"directcreatenew"  //@"directcreate"
#define     ACTION_ORDER_TRADE      @"getstand"

#define     ACTION_AFTERSALE_APPLY  @"apply"
#define     ACTION_AFTERSALE_PAGE   @"page"
#define     ACTION_AFTERSALE_TUIHUO @"applymore"
#define     ACTION_AFTERSALE_DETAIL @"queryinfo"
#define     ACTION_AFTERSALE_INFO   @"queryAterSalInfo"
#define     ACTION_AFTERSALE_CANCEL @"userCancel"

#define     ACTION_SYS_REPORT       @"report"
#define     ACTION_SYS_REPORTPUSH   @"reporttuisong"
#define     ACTION_SYS_PAYTYPE      @"getpaytype"

#define     ACTION_IDEOS            @"getLatestIdeosList"

// v1.0
#define     ACTION_WX_LOGIN         @"weixinlogin"
#define     ACTION_SMS_LOGIN        @"register" //@"phonelogin"
#define     ACTION_SMS_CODE         @"authcode"
#define     ACTION_LOGOUT           @"logout"
#define     ACTION_AUTH_ID          @"ifidcardused"
#define     ACTION_AUTH_SMSBank     @"sendSMSBankMoblie"
#define     ACTION_AUTH_USER        @"validuser"
#define     ACTION_MODIFY_USER      @"changeuser"

#define     ACTION_USER_UPDATE      @"update"
#define     ACTION_USER_ACCOUNT     @"account"
#define     ACTION_ACCOUNT_DETAIL   @"page"

#define     ACTION_USER_VIPBUY      @"memberbuy"
#define     ACTION_USER_VIPLIST     @"getpurchases"
#define     ACTION_USER_VIPPURCHASE @"memberpurchase"
#define     ACTION_USER_GETDELTAS   @"getdeltas"
#define     ACTION_USER_BUYDELTA    @"buydelta"
#define     ACTION_USER_INVITECODE  @"getreferralcode"

#define     ACTION_TRACK_PRODUCTS   @"trackProducts"
#define     ACTION_TRACK_COMMENTS   @"trackComments"

#define     ACTION_SYNC_PRODUCTS    @"syncProducts"
#define     ACTION_SYNC_COMMENTS    @"syncComments"

#define     ACTION_PRODUCT_BUY      @"buy"
#define     ACTION_CANCEL_BUY       @"cancelBuy"
#define     ACTION_PRODUCT_FORWARD  @"forward"
#define     ACTION_FORWARD_LIST     @"forwardlist"
#define     ACTION_PRODUCT_COMMENT  @"comment"
#define     ACTION_COMMENT_CANCEL   @"cancelComment"
#define     ACTION_PRODUCT_REMARK   @"remark"
#define     ACTION_SKU_GET          @"getsku"
#define     ACTION_SKU_UPDATE       @"updatesku"

#define     ACTION_PRODUCT_FOLLOW   @"follow"
#define     ACTION_FOLLOW_LIST      @"followlist"

#define     ACTION_PRODUCT_LACK     @"reportlack"
#define     ACTION_PRODUCT_SCAN     @"reportscan"
#define     ACTION_BARCODE_SEARCH   @"barcodesearch"


#define     ACTION_DELIVER_LIST     @"page"
#define     ACTION_DELIVER_DETAIL   @"detail"
#define     ACTION_DELIVER_APPLY    @"apply"
#define     ACTION_DELIVER_ADDR     @"modifyaddrunused" //@"modifyaddr"
#define     ACTION_DELIVER_TRACE    @"trace"
#define     ACTION_DELIVER_ADORDERS @"getadorderid"
#define     ACTION_DELIVER_PRODUCTS @"getorderdetail"
#define     ACTION_DELIVER_SEARCH   @"searchdeliverproduct"

#define     ACTION_MESSAGE_LIST     @"page"
#define     ACTION_MESSAGE_READ     @"readMsg"
#define     ACTION_MESSAGE_READALL  @"readAllMsg"


#define     ACTION_KEFU_CHECK       @"check"
#define     ACTION_KEFU_PUSH        @"push"
#define     ACTION_KEFU_PULL        @"pull"
#define     ACTION_KEFU_REFRESH     @"refresh"
#define     ACTION_KEFU_RECEIPT     @"receipt"


#define     ACTION_DISCOVER_LIST    @"pagelistbytype"
#define     ACTION_DISCOVER_CHECK   @"checkupdate"
#define     ACTION_DISCOVER_COMMENT @"comment"
#define     ACTION_DISCOVER_UPLOAD  @"upload"
#define     ACTION_DISCOVER_UPAuth  @"uploadauth"
#define     ACTION_DISCOVER_UPNew   @"uploadnew"
#define     ACTION_DISCOVER_VIDEO   @"getpayinfo"

/**
 *  API JSON Key Define
 */
#define     HTTP_KEY_DATA           @"data"
#define     HTTP_KEY_STATUS         @"status"
#define     HTTP_KEY_STATE          @"state"
#define     HTTP_KEY_MSG            @"message"
#define     HTTP_KEY_CODE           @"code"

#define     HTTP_KEY_APPID          @"appid"
#define     HTTP_KEY_SECRET         @"secret"
#define     HTTP_KEY_NONCESTR       @"noncestr"
#define     HTTP_KEY_TIMESTAMP      @"timestamp"
#define     HTTP_KEY_URL            @"url"
#define     HTTP_KEY_SIG            @"sig"
#define     HTTP_KEY_ACTION         @"action"


#define     HTTP_KEY_TOKEN          @"token"
#define     HTTP_KEY_USERNAME       @"name"
#define     HTTP_KEY_MOBILE         @"mobile"


/**
 *  错误CODE码定义
 */
#define     ERR_SECRET_ERROR        40001       //
#define     ERR_SIG_ERROR           40002       //
#define     ERR_USER_INVALID        40003       //
#define     ERR_TOKEN_EXPIRED       40005       // Token失效

#define     ERR_VIP_DISABLED        40043       // VIP才能下单

#define     ERR_SOLD_OUT            60018       // 卖光了
#define     ERR_NOT_FORWARD         60032       // 需转发才能下单
#define     ERR_NOT_PAYED           60037       // 有未支付订单 提示先支付

#define     ERR_DELIVER_INVALID     60077       // 发货单已失效


/**
 *  推送消息类型定义
 */
typedef NS_ENUM(NSInteger, eMessageAction)
{
    MSG_ACTION_ALERT_MSG        = 2 ,           // 弹框提示
    MSG_ACTION_LIVE_MSG         = 11 ,          // 活动通知
    
    MSG_ACTION_INVITECODE_USED  = 18 ,          // 邀请码被使用通知
    MSG_ACTION_REWARD_INFO      = 20 ,          // 奖励发放通知

    MSG_ACTION_APP_UPGRADE      = 100 ,         // 版本更新通知
    
    MSG_ACTION_SYNC_LIVE        = 101 ,         // 同步活动商品指令
    MSG_ACTION_PRODUCT_OFF      = 102 ,         // 活动商品下架指令
    MSG_ACTION_INVALID_PICTURE  = 103 ,         // 商品图片失效指令
    MSG_ACTION_UPDATE_LIVE      = 104 ,         // 刷新活动信息指令
    MSG_ACTION_UPDATE_USERINFO  = 105 ,         // 刷新用户信息指令
};

#endif
