#import <UIKit/UIKit.h>

#pragma mark - UI相关常量
/** TabBar的高度 */
CGFloat const ODTabBarHeight = 55;
CGFloat const ODNavigationHeight = 64;
CGFloat const ODLeftMargin = 17.5;
CGFloat const ODTopY = 0;
CGFloat const ODNavigationTextFont = 17;
#pragma mark - 通用的Key
/** 偏好设置保存用户信息 */
NSString * const kUserCache = @"kUserCache";
NSString * const KUserDefaultsOpenId = @"userOpenId";
NSString * const KUserDefaultsAvatar = @"userAvatar";
NSString * const KUserDefaultsMobile = @"userMobile";

/** info.plist中记录的版本号 */
NSString * const kUserDefaultsVersionKey = @"CFBundleShortVersionString";

/** 友盟的apiKey */
NSString * const kGetUMAppkey = @"569dda54e0f55a994f0021cf";

#pragma mark - 通知
/** 显示集市的通知 */
NSString * const ODNotificationShowBazaar = @"ODShowBazaarNotification";

/** 刷新我的话题通知 */
NSString * const ODNotificationMyTaskRefresh = @"ODNotificationMyTaskRefresh";

/**  求帮助的通知 */
NSString * const ODNotificationSearchHelp = @"ODNotificationSearchHelp";

/**  换技能通知 */
NSString * const ODNotificationChangeSkill = @"ODNotificationChangeSkill";

/**  寻圈子的通知 */
NSString * const ODNotificationSearchCircle = @"ODNotificationSearchCircle";

/**  发布任务成功通知 */
NSString * const ODNotificationReleaseTask = @"ODNotificationReleaseTask";

/**  发布技能成功通知 */
NSString * const ODNotificationReleaseSkill = @"ODNotificationReleaseSkill";

/**  编辑成功的通知 */
NSString * const ODNotificationEditSkill = @"ODNotificationEditSkill";

/**  编辑技能创建服务时间试图 */
NSString * const ODNotificationCreateServiceTimeView = @"ODNotificationCreateServiceTimeView";

/**  支付成功通知 */
NSString * const ODNotificationPaySuccess = @"ODNotificationPaySuccess";

/**  支付失败通知 */
NSString * const ODNotificationPayfail = @"ODNotificationPayfail";

/**  取消预约通知 */
NSString * const ODNotificationCancelOrder = @"ODNotificationCancelOrder";

/**  退出成功刷新集市状态 */
NSString * const ODNotificationQuit = @"ODNotificationQuit";

/**  回复成功后刷新 */
NSString * const ODNotificationReplySuccess = @"ODNotificationReplySuccess";

/**  登录成功后的通知 */
NSString * const ODNotificationLoginSuccess = @"ODNotificationLoginSuccess";

/** 定位成功刷新 */
NSString * const ODNotificationLocationSuccessRefresh = @"ODNotificationLocationSuccessRefresh";

/** 订单刷新 */
NSString * const ODNotificationOrderListRefresh = @"ODNotificationOrderListRefresh";

/**  点击收藏的通知 */
NSString * const ODNotificationloveSkill = @"ODNotificationloveSkill";

/** 已购买二级页面通知 */
NSString * const ODNotificationMyOrderSecondRefresh = @"ODNotificationMyOrderSecondRefresh";
/** 已购买三级页面通知 */
NSString * const ODNotificationMyOrderThirdRefresh = @"ODNotificationMyOrderThirdRefresh";
/** 已卖出二级页面通知 */
NSString * const ODNotificationSellOrderSecondRefresh = @"ODNotificationSellOrderSecondRefresh";
/** 已购买三级页面通知 */
NSString * const ODNotificationSellOrderThirdRefresh = @"ODNotificationSellOrderThirdRefresh";


#pragma mark - 请求URL接口
/** 网页接口 */
NSString * const ODWebUrlFindJob = @"http://www.myjob500.com/user/extloginpf";


/** 统一的URL */
#ifdef DEBUG
NSString * const ODBaseURL = @"http://woquapi.test.odong.com/1.0/";
#else
NSString * const ODBaseURL = @"http://woquapi.odong.com/1.0/";
#endif


/** user */
NSString * const ODUrlUserLogin1 = @"user/login1";
NSString * const ODUrlUserRegist = @"user/register";
NSString * const ODUrlUserChange = @"user/change";
NSString * const ODUrlUserInfo = @"user/info";
NSString * const ODUrlUserCodeSend = @"user/verify/code/send";
NSString * const ODUrlUserChangePasswd = @"user/change/passwd";
NSString * const ODUrlUserCommentList = @"user/comment/list";
NSString * const ODUrlUserWithdrawCash = @"user/withdraw/cash";
NSString * const ODUrlUserCashList = @"user/cash/list";
NSString * const ODUrlUserAddressList = @"user/address/list";
NSString * const ODUrlUserAddressDel = @"user/address/del";
NSString * const ODUrlUserAssressAdd = @"user/address/add";
NSString * const ODUrlUserLoveList = @"user/love/list";
NSString * const ODUrlUserBindMoble = @"user/bind/mobile";

/** store */
NSString * const ODUrlStoreActivityList = @"store/activity/list";
NSString * const ODUrlStoreApplyDetail2 = @"store/apply/detail2";
NSString * const ODUrlStoreActivityApply = @"store/activity/apply";
NSString * const ODUrlStoreTimeline1 = @"store/timeline1";
NSString * const ODUrlStoreConfirmOrder = @"store/confirm/order";
NSString * const ODUrlStoreCreateOrder = @"store/create/order";
NSString * const ODUrlStoreApplyMy = @"store/apply/my";
NSString * const ODUrlStoreOrders = @"store/orders";
NSString * const ODUrlStoreInfoOrder = @"store/info/order";
NSString * const ODUrlStoreCancelOrder = @"store/cancel/order";
NSString * const ODUrlStoreApply = @"store/apply";
NSString * const ODUrlStoreApplyUsers = @"store/apply/users";



/** other */
NSString * const ODUrlOtherCityList = @"other/city/list";
NSString * const ODUrlOtherHome = @"other/home";
NSString * const ODUrlOtherShareCallBack = @"other/share/callback";
NSString * const ODUrlOtherLoveAdd = @"other/love/add";
NSString * const ODUrlOtherLoveDelete = @"other/love/del";
NSString * const ODUrlOtherLoveDel = @"other/love/del";
NSString * const ODUrlOtherStoreDetail = @"other/store/detail";
NSString * const ODUrlOtherStoreList = @"other/store/list";
NSString * const ODUrlOtherBase64Upload = @"other/base64/upload";
NSString * const ODUrlOtherFeedback = @"other/feedback";





/** task */
NSString * const ODUrlTaskList = @"task/list";
NSString * const ODUrlTaskTaskAdd = @"task/task/add";
NSString * const ODUrlTaskDetail = @"task/detail";

NSString * const ODUrlBazaarRequestHelp = @"task/list";
NSString * const ODUrlRequestHelpReward = @"other/config/info";
NSString * const ODUrlBazaarReleaseTask = @"task/task/add";
NSString * const ODUrlBazaarExchangeSkill = @"swap/list";
NSString * const ODUrlBazaarSkillDetail = @"swap/info";
NSString * const ODUrlBazaarReleaseSkill = @"swap/create";
NSString * const ODUrlBazaarEditSkill = @"swap/edit";
NSString * const ODUrlSkillCollection = @"user/love/list";
NSString * const ODUrlSkillDetailLove = @"other/love/add";
NSString * const ODUrlSkillDetailNotLove = @"other/love/del";

NSString * const ODUrlCommunityBbsList = @"bbs/list";
NSString * const ODUrlCommunityBbsReply = @"bbs/reply";
NSString * const ODUrlCommunityBbsSearch = @"bbs/search";
NSString * const ODUrlCommunityReleaseBbs = @"bbs/create";





/** bbs */
NSString * const ODUrlBbsList = @"bbs/list";
NSString * const ODUrlBbsDel = @"bbs/del";




/*** swap */
NSString * const ODUrlSwapList = @"swap/list";
NSString * const ODUrlSwapOrder = @"swap/order";
NSString * const ODUrlSwapLoveList = @"swap/love/list";
NSString * const ODUrlSwapOrderList = @"swap/order/list";
NSString * const ODUrlSwapOrderInfo = @"swap/order/info";
NSString * const ODUrlSwapDel = @"swap/del";
NSString * const ODUrlSwapOrderCancel = @"swap/order/cancel";
NSString * const ODUrlSwapRejectRefund = @"swap/reject/refund";
NSString * const ODUrlSwapConfirmRefund = @"swap/confirm/refund";
NSString * const ODUrlSwapSellerOrderList = @"swap/seller/order/list";
NSString * const ODUrlSwapServiceTime = @"swap/service/time";



/** pay */
NSString * const ODUrlPayWeixinTradeNumber = @"pay/weixin/trade/number";
NSString * const ODUrlPayWeixinCallbackSync = @"pay/weixin/callback/sync";

// 以后要改
#ifdef DEBUG

//NSString * const ODPersonReleaseTaskDeleteUrl = @"http://woquapi.test.odong.com/1.0/swap/del";





NSString * const kBazaarTaskDetailUrl = @"http://woquapi.test.odong.com/1.0/task/detail";
//NSString * const kBazaarTaskDetailUrl = @"http://woquapi.test.odong.com/1.0/task/detail";

NSString * const kBazaarTaskDelegateUrl = @"http://woquapi.test.odong.com/1.0/task/accept";
NSString * const kBazaarAcceptTaskUrl = @"http://woquapi.test.odong.com/1.0/task/apply";
NSString * const kBazaarReleaseRewardUrl = @"http://woquapi.test.odong.com/1.0/other/config/info";
NSString * const kBazaarTaskReceiveCompleteUrl = @"http://woquapi.test.odong.com/1.0/task/delivery";
NSString * const kBazaarTaskInitiateCompleteUrl = @"http://woquapi.test.odong.com/1.0/task/confirm";
//NSString * const kBazaarExchangeSkillUrl = @"http://woquapi.test.odong.com/1.0/swap/list";

NSString * const kBazaarExchangeSkillDetailUrl = @"http://woquapi.test.odong.com/1.0/swap/info";
NSString * const kBazaarReleaseSkillTimeUrl = @"http://woquapi.test.odong.com/1.0/swap/schedule";
//NSString * const kBazaarExchangeSkillDetailLoveUrl = @"http://woquapi.test.odong.com/1.0/other/love/add";
//NSString * const kBazaarExchangeSkillDetailNotLoveUrl = @"http://woquapi.test.odong.com/1.0/other/love/del";
NSString * const kBazaarReleaseSkillUrl = @"http://woquapi.test.odong.com/1.0/swap/create";
NSString * const kBazaarEditSkillUrl = @"http://woquapi.test.odong.com/1.0/swap/edit";

//NSString * const kCommunityReleaseBbsUrl = @"http://woquapi.test.odong.com/1.0/bbs/create";
NSString * const kCommunityBbsDetailUrl = @"http://woquapi.test.odong.com/1.0/bbs/view";
//NSString * const kCommunityBbsSearchUrl = @"http://woquapi.test.odong.com/1.0/bbs/search";
NSString * const kCommunityBbsReplyListUrl = @"http://woquapi.test.odong.com/1.0/bbs/reply/list";
NSString * const kCommunityBbsReplyUrl = @"http://woquapi.test.odong.com/1.0/bbs/reply";
NSString * const kCommunityBbsLatestUrl = @"http://woquapi.test.odong.com/1.0/bbs/list";

NSString * const kPushImageUrl = @"http://woquapi.test.odong.com/1.0/other/base64/upload";
NSString * const kDeleteReplyUrl = @"http://woquapi.test.odong.com/1.0/bbs/del";

NSString * const kHomeFoundListUrl = @"http://woquapi.test.odong.com/1.0/bbs/list";



//NSString * const ODHomeChangeSkillUrl = @"http://woquapi.test.odong.com/1.0/other/home";
//NSString * const ODReleaseDrawbackUrl = @"http://woquapi.test.odong.com/1.0/swap/order/cancel";

//NSString * const ODRefuseDrawbackUrl = @"http://woquapi.test.odong.com/1.0/swap/reject/refund";
//NSString * const ODReceiveDrawbackUrl = @"http://woquapi.test.odong.com/1.0/swap/confirm/refund";


//NSString * const kMyOrderRecordUrl = @"http://woquapi.test.odong.com/1.0/store/orders";
//NSString * const kMyOrderDetailUrl = @"http://woquapi.test.odong.com/1.0/store/info/order";

//NSString * const kCancelMyOrderUrl = @"http://woquapi.test.odong.com/1.0/store/cancel/order";
//NSString * const kSaveAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/add";
//NSString * const kDeleteAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/del";

//NSString * const kGetServecTimeUrl = @"http://woquapi.test.odong.com/1.0/swap/service/time";

NSString * const kCollectionUrl = @"http://woquapi.test.odong.com/1.0/user/love/list";
NSString * const kDelateOrderUrl = @"http://woquapi.test.odong.com/1.0/swap/order/cancel";

NSString * const kGetImageDataUrl = @"http://woquapi.test.odong.com/1.0/other/base64/upload";
NSString * const kGetCommentUrl = @"http://woquapi.test.odong.com/1.0/user/comment/list";
NSString * const kGetApplyListUrl = @"http://woquapi.test.odong.com/1.0/store/apply/users";
NSString * const kGiveOpinionUrl = @"http://woquapi.test.odong.com/1.0/other/feedback";

//NSString * const kCollectionUrl = @"http://woquapi.test.odong.com/1.0/user/love/list";

NSString * const kDeliveryUrl = @"http://woquapi.test.odong.com/1.0/swap/confirm/delivery";
NSString * const kFinshOrderUrl = @"http://woquapi.test.odong.com/1.0/swap/finish";
NSString * const kEvalueUrl = @"http://woquapi.test.odong.com/1.0/swap/order/reason";






#else


NSString * const ODPersonReleaseTaskDeleteUrl = @"http://woquapi.odong.com/1.0/swap/del";


NSString * const kBazaarTaskDetailUrl = @"http://woquapi.odong.com/1.0/task/detail";
NSString * const kBazaarTaskDelegateUrl = @"http://woquapi.odong.com/1.0/task/accept";
NSString * const kBazaarAcceptTaskUrl = @"http://woquapi.odong.com/1.0/task/apply";
NSString * const kBazaarReleaseRewardUrl = @"http://woquapi.odong.com/1.0/other/config/info";
NSString * const kBazaarTaskReceiveCompleteUrl = @"http://woquapi.odong.com/1.0/task/delivery";
NSString * const kBazaarTaskInitiateCompleteUrl = @"http://woquapi.odong.com/1.0/task/confirm";

NSString * const kBazaarExchangeSkillDetailUrl = @"http://woquapi.odong.com/1.0/swap/info";
NSString * const kBazaarReleaseSkillTimeUrl = @"http://woquapi.odong.com/1.0/swap/schedule";
NSString * const kBazaarEditSkillUrl = @"http://woquapi.odong.com/1.0/swap/edit";

NSString * const kCommunityBbsDetailUrl = @"http://woquapi.odong.com/1.0/bbs/view";
NSString * const kCommunityBbsReplyListUrl = @"http://woquapi.odong.com/1.0/bbs/reply/list";
NSString * const kCommunityBbsReplyUrl = @"http://woquapi.odong.com/1.0/bbs/reply";
NSString * const kCommunityBbsLatestUrl = @"http://woquapi.odong.com/1.0/bbs/list";

NSString * const kPushImageUrl = @"http://woquapi.odong.com/1.0/other/base64/upload";
NSString * const kDeleteReplyUrl = @"http://woquapi.odong.com/1.0/bbs/del";

NSString * const kHomeFoundListUrl = @"http://woquapi.odong.com/1.0/bbs/list";

NSString * const ODHomeChangeSkillUrl = @"http://woquapi.odong.com/1.0/other/home";
NSString * const ODReleaseDrawbackUrl = @"http://woquapi.odong.com/1.0/swap/order/cancel";

NSString * const ODRefuseDrawbackUrl = @"http://woquapi.odong.com/1.0/swap/reject/refund";
NSString * const ODReceiveDrawbackUrl = @"http://woquapi.odong.com/1.0/swap/confirm/refund";


NSString * const kMyOrderRecordUrl = @"http://woquapi.odong.com/1.0/store/orders";
NSString * const kMyOrderDetailUrl = @"http://woquapi.odong.com/1.0/store/info/order";

NSString * const kCancelMyOrderUrl = @"http://woquapi.odong.com/1.0/store/cancel/order";
NSString * const kSaveAddressUrl = @"http://woquapi.odong.com/1.0/user/address/add";
NSString * const kDeleteAddressUrl = @"http://woquapi.odong.com/1.0/user/address/del";

NSString * const kGetServecTimeUrl = @"http://woquapi.odong.com/1.0/swap/service/time";

NSString * const kGetTopicUrl = @"http://woquapi.odong.com/1.0/bbs/list";
NSString * const kCollectionUrl = @"http://woquapi.odong.com/1.0/user/love/list";
NSString * const kGetCommentUrl = @"http://woquapi.odong.com/1.0/user/comment/list";
NSString * const kGetApplyListUrl = @"http://woquapi.odong.com/1.0/store/apply/users";
NSString * const kGiveOpinionUrl = @"http://woquapi.odong.com/1.0/other/feedback";

//NSString * const kCollectionUrl = @"http://woquapi.odong.com/1.0/user/love/list";

NSString * const kGetPayInformationUrl = @"http://woquapi.odong.com/1.0/pay/weixin/trade/number";
NSString * const kBalanceUrl = @"http://woquapi.odong.com/1.0/user/withdraw/cash";


NSString * const kDeliveryUrl = @"http://woquapi.odong.com/1.0/swap/confirm/delivery";
NSString * const kFinshOrderUrl = @"http://woquapi.odong.com/1.0/swap/finish";
NSString * const kEvalueUrl = @"http://woquapi.odong.com/1.0/swap/order/reason";

#endif