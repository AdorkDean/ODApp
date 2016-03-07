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
NSString * const ODFindJobUrl = @"http://www.myjob500.com/user/extloginpf";


/** 统一的URL */
#ifdef DEBUG
NSString * const ODBaseURL = @"http://woquapi.test.odong.com/1.0/";
NSString * const ODURL = @"http://woquapi.test.odong.com";
#else
NSString * const ODBaseURL = @"http://woquapi.odong.com/1.0/";
NSString * const ODURL = @"http://woquapi.odong.com";
#endif

NSString * const ODUrlUserLogin1 = @"user/login1";
NSString * const ODUrlUserRegist = @"user/register";
NSString * const ODUrlUserChange = @"user/change";
NSString * const ODUrlUserInfo = @"user/info";
NSString * const ODUrlUserCodeSend = @"user/verify/code/send";
NSString * const ODUrlUserChangePasswd = @"user/change/passwd";


NSString * const ODUrlActivityList = @"store/activity/list";
NSString * const ODUrlActivityDetail = @"store/apply/detail2";
NSString * const ODUrlActivityApply = @"store/activity/apply";
NSString * const ODUrlStoreTime = @"store/timeline1";
NSString * const ODUrlConfirmOrder = @"store/confirm/order";
NSString * const ODUrlCreateOrder = @"store/create/order";
NSString * const ODUrlMyApplyActivity = @"store/apply/my";



NSString * const ODUrlCityList = @"other/city/list";
NSString * const ODUrlHomeFound = @"other/home";
NSString * const ODUrlShareCallBack = @"other/share/callback";
NSString * const ODUrlLoveAdd = @"other/love/add";
NSString * const ODUrlLoveDelete = @"other/love/del";
NSString * const ODUrlStoreDetail = @"other/store/detail";



NSString * const ODUrlPersonalReleaseTask = @"swap/list";


// 以后要改
#ifdef DEBUG

NSString * const ODPersonReleaseTaskDeleteUrl = @"http://woquapi.test.odong.com/1.0/swap/del";

NSString * const kBazaarUnlimitTaskUrl = @"http://woquapi.test.odong.com/1.0/task/list";
NSString * const kBazaarReleaseTaskUrl = @"http://woquapi.test.odong.com/1.0/task/task/add";
NSString * const kBazaarTaskDetailUrl = @"http://woquapi.test.odong.com/1.0/task/detail";
NSString * const kBazaarTaskDelegateUrl = @"http://woquapi.test.odong.com/1.0/task/accept";
NSString * const kBazaarAcceptTaskUrl = @"http://woquapi.test.odong.com/1.0/task/apply";
NSString * const kBazaarReleaseRewardUrl = @"http://woquapi.test.odong.com/1.0/other/config/info";
NSString * const kBazaarTaskReceiveCompleteUrl = @"http://woquapi.test.odong.com/1.0/task/delivery";
NSString * const kBazaarTaskInitiateCompleteUrl = @"http://woquapi.test.odong.com/1.0/task/confirm";
NSString * const kBazaarExchangeSkillUrl = @"http://woquapi.test.odong.com/1.0/swap/list";
NSString * const kBazaarExchangeSkillDetailUrl = @"http://woquapi.test.odong.com/1.0/swap/info";
NSString * const kBazaarReleaseSkillTimeUrl = @"http://woquapi.test.odong.com/1.0/swap/schedule";
NSString * const kBazaarExchangeSkillDetailLoveUrl = @"http://woquapi.test.odong.com/1.0/other/love/add";
NSString * const kBazaarExchangeSkillDetailNotLoveUrl = @"http://woquapi.test.odong.com/1.0/other/love/del";
NSString * const kBazaarReleaseSkillUrl = @"http://woquapi.test.odong.com/1.0/swap/create";
NSString * const kBazaarEditSkillUrl = @"http://woquapi.test.odong.com/1.0/swap/edit";

NSString * const kCommunityReleaseBbsUrl = @"http://woquapi.test.odong.com/1.0/bbs/create";
NSString * const kCommunityBbsDetailUrl = @"http://woquapi.test.odong.com/1.0/bbs/view";
NSString * const kCommunityBbsSearchUrl = @"http://woquapi.test.odong.com/1.0/bbs/search";
NSString * const kCommunityBbsReplyListUrl = @"http://woquapi.test.odong.com/1.0/bbs/reply/list";
NSString * const kCommunityBbsReplyUrl = @"http://woquapi.test.odong.com/1.0/bbs/reply";
NSString * const kCommunityBbsLatestUrl = @"http://woquapi.test.odong.com/1.0/bbs/list";

NSString * const kPushImageUrl = @"http://woquapi.test.odong.com/1.0/other/base64/upload";
NSString * const kDeleteReplyUrl = @"http://woquapi.test.odong.com/1.0/bbs/del";

NSString * const kHomeFoundListUrl = @"http://woquapi.test.odong.com/1.0/bbs/list";

NSString * const ODStoreListUrl = @"http://woquapi.test.odong.com/1.0/other/store/list";
NSString * const ODStoreDetailUrl = @"http://woquapi.test.odong.com/1.0/other/store/detail";


NSString * const ODHomeChangeSkillUrl = @"http://woquapi.test.odong.com/1.0/other/home";
NSString * const ODReleaseDrawbackUrl = @"http://woquapi.test.odong.com/1.0/swap/order/cancel";

NSString * const ODRefuseDrawbackUrl = @"http://woquapi.test.odong.com/1.0/swap/reject/refund";
NSString * const ODReceiveDrawbackUrl = @"http://woquapi.test.odong.com/1.0/swap/confirm/refund";


NSString * const kMyOrderRecordUrl = @"http://woquapi.test.odong.com/1.0/store/orders";
NSString * const kMyOrderDetailUrl = @"http://woquapi.test.odong.com/1.0/store/info/order";

NSString * const kCancelMyOrderUrl = @"http://woquapi.test.odong.com/1.0/store/cancel/order";
NSString * const kSaveAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/add";
NSString * const kGetAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/list";
NSString * const kDeleteAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/del";

NSString * const kGetServecTimeUrl = @"http://woquapi.test.odong.com/1.0/swap/service/time";

NSString * const kGetOrderUrl = @"http://woquapi.test.odong.com/1.0/swap/order";


NSString * const kGetLikeListUrl = @"http://woquapi.test.odong.com/1.0/swap/love/list";
NSString * const kGetMyOrderListUrl = @"http://woquapi.test.odong.com/1.0/swap/order/list";
NSString * const kOrderDetailUrl = @"http://woquapi.test.odong.com/1.0/swap/order/info";
NSString * const kDelateOrderUrl = @"http://woquapi.test.odong.com/1.0/swap/order/cancel";

NSString * const kGetImageDataUrl = @"http://woquapi.test.odong.com/1.0/other/base64/upload";
NSString * const kGetTaskUrl = @"http://woquapi.test.odong.com/1.0/task/list";
NSString * const kDelateTaskUrl = @"http://woquapi.test.odong.com/1.0/bbs/del";
NSString * const kGetCommentUrl = @"http://woquapi.test.odong.com/1.0/user/comment/list";
NSString * const kGetApplyListUrl = @"http://woquapi.test.odong.com/1.0/store/apply/users";
NSString * const kGiveOpinionUrl = @"http://woquapi.test.odong.com/1.0/other/feedback";
NSString * const kCollectionUrl = @"http://woquapi.test.odong.com/1.0/user/love/list";

NSString * const kGetPayInformationUrl = @"http://woquapi.test.odong.com/1.0/pay/weixin/trade/number";
NSString * const kBalanceUrl = @"http://woquapi.test.odong.com/1.0/user/withdraw/cash";

NSString * const kBalanceListUrl = @"http://woquapi.test.odong.com/1.0/user/cash/list";
NSString * const kMySellListUrl = @"http://woquapi.test.odong.com/1.0/swap/seller/order/list";
NSString * const kDeliveryUrl = @"http://woquapi.test.odong.com/1.0/swap/confirm/delivery";
NSString * const kFinshOrderUrl = @"http://woquapi.test.odong.com/1.0/swap/finish";
NSString * const kEvalueUrl = @"http://woquapi.test.odong.com/1.0/swap/order/reason";
NSString * const kPayBackUrl = @"http://woquapi.test.odong.com/1.0/pay/weixin/callback/sync";






#else


NSString * const ODPersonReleaseTaskDeleteUrl = @"http://woquapi.odong.com/1.0/swap/del";

NSString * const kBazaarUnlimitTaskUrl = @"http://woquapi.odong.com/1.0/task/list";
NSString * const kBazaarReleaseTaskUrl = @"http://woquapi.odong.com/1.0/task/task/add";
NSString * const kBazaarTaskDetailUrl = @"http://woquapi.odong.com/1.0/task/detail";
NSString * const kBazaarTaskDelegateUrl = @"http://woquapi.odong.com/1.0/task/accept";
NSString * const kBazaarAcceptTaskUrl = @"http://woquapi.odong.com/1.0/task/apply";
NSString * const kBazaarReleaseRewardUrl = @"http://woquapi.odong.com/1.0/other/config/info";
NSString * const kBazaarTaskReceiveCompleteUrl = @"http://woquapi.odong.com/1.0/task/delivery";
NSString * const kBazaarTaskInitiateCompleteUrl = @"http://woquapi.odong.com/1.0/task/confirm";
NSString * const kBazaarExchangeSkillUrl = @"http://woquapi.odong.com/1.0/swap/list";
NSString * const kBazaarExchangeSkillDetailUrl = @"http://woquapi.odong.com/1.0/swap/info";
NSString * const kBazaarReleaseSkillTimeUrl = @"http://woquapi.odong.com/1.0/swap/schedule";
NSString * const kBazaarExchangeSkillDetailLoveUrl = @"http://woquapi.odong.com/1.0/other/love/add";
NSString * const kBazaarExchangeSkillDetailNotLoveUrl = @"http://woquapi.odong.com/1.0/other/love/del";
NSString * const kBazaarReleaseSkillUrl = @"http://woquapi.odong.com/1.0/swap/create";
NSString * const kBazaarEditSkillUrl = @"http://woquapi.odong.com/1.0/swap/edit";

NSString * const kCommunityReleaseBbsUrl = @"http://woquapi.odong.com/1.0/bbs/create";
NSString * const kCommunityBbsDetailUrl = @"http://woquapi.odong.com/1.0/bbs/view";
NSString * const kCommunityBbsSearchUrl = @"http://woquapi.odong.com/1.0/bbs/search";
NSString * const kCommunityBbsReplyListUrl = @"http://woquapi.odong.com/1.0/bbs/reply/list";
NSString * const kCommunityBbsReplyUrl = @"http://woquapi.odong.com/1.0/bbs/reply";
NSString * const kCommunityBbsLatestUrl = @"http://woquapi.odong.com/1.0/bbs/list";

NSString * const kPushImageUrl = @"http://woquapi.odong.com/1.0/other/base64/upload";
NSString * const kDeleteReplyUrl = @"http://woquapi.odong.com/1.0/bbs/del";

NSString * const kHomeFoundListUrl = @"http://woquapi.odong.com/1.0/bbs/list";

NSString * const ODStoreListUrl = @"http://woquapi.odong.com/1.0/other/store/list";


NSString * const ODHomeChangeSkillUrl = @"http://woquapi.odong.com/1.0/other/home";
NSString * const ODReleaseDrawbackUrl = @"http://woquapi.odong.com/1.0/swap/order/cancel";

NSString * const ODRefuseDrawbackUrl = @"http://woquapi.odong.com/1.0/swap/reject/refund";
NSString * const ODReceiveDrawbackUrl = @"http://woquapi.odong.com/1.0/swap/confirm/refund";


NSString * const kMyOrderRecordUrl = @"http://woquapi.odong.com/1.0/store/orders";
NSString * const kMyOrderDetailUrl = @"http://woquapi.odong.com/1.0/store/info/order";

NSString * const kCancelMyOrderUrl = @"http://woquapi.odong.com/1.0/store/cancel/order";
NSString * const kSaveAddressUrl = @"http://woquapi.odong.com/1.0/user/address/add";
NSString * const kGetAddressUrl = @"http://woquapi.odong.com/1.0/user/address/list";
NSString * const kDeleteAddressUrl = @"http://woquapi.odong.com/1.0/user/address/del";

NSString * const kGetServecTimeUrl = @"http://woquapi.odong.com/1.0/swap/service/time";

NSString * const kGetOrderUrl = @"http://woquapi.odong.com/1.0/swap/order";


NSString * const kGetLikeListUrl = @"http://woquapi.odong.com/1.0/swap/love/list";
NSString * const kGetMyOrderListUrl = @"http://woquapi.odong.com/1.0/swap/order/list";
NSString * const kOrderDetailUrl = @"http://woquapi.odong.com/1.0/swap/order/info";
NSString * const kDelateOrderUrl = @"http://woquapi.odong.com/1.0/swap/order/cancel";

NSString * const kGetImageDataUrl = @"http://woquapi.odong.com/1.0/other/base64/upload";
NSString * const kGetTopicUrl = @"http://woquapi.odong.com/1.0/bbs/list";
NSString * const kDelateTaskUrl = @"http://woquapi.odong.com/1.0/bbs/del";
NSString * const kGetCommentUrl = @"http://woquapi.odong.com/1.0/user/comment/list";
NSString * const kGetApplyListUrl = @"http://woquapi.odong.com/1.0/store/apply/users";
NSString * const kGiveOpinionUrl = @"http://woquapi.odong.com/1.0/other/feedback";
NSString * const kCollectionUrl = @"http://woquapi.odong.com/1.0/user/love/list";

NSString * const kGetPayInformationUrl = @"http://woquapi.odong.com/1.0/pay/weixin/trade/number";
NSString * const kBalanceUrl = @"http://woquapi.odong.com/1.0/user/withdraw/cash";

NSString * const kBalanceListUrl = @"http://woquapi.odong.com/1.0/user/cash/list";
NSString * const kMySellListUrl = @"http://woquapi.odong.com/1.0/swap/seller/order/list";
NSString * const kDeliveryUrl = @"http://woquapi.odong.com/1.0/swap/confirm/delivery";
NSString * const kFinshOrderUrl = @"http://woquapi.odong.com/1.0/swap/finish";
NSString * const kEvalueUrl = @"http://woquapi.odong.com/1.0/swap/order/reason";
NSString * const kPayBackUrl = @"http://woquapi.odong.com/1.0/pay/weixin/callback/sync";
NSString * const ODStoreDetailUrl = @"http://woquapi.odong.com/1.0/other/store/detail";

#endif