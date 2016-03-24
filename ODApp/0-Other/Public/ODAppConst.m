#import <UIKit/UIKit.h>

#pragma mark - UI相关常量
/** TabBar的高度 */
CGFloat const ODTabBarHeight = 55;
CGFloat const ODNavigationHeight = 64;
CGFloat const ODLeftMargin = 17.5;
CGFloat const ODTopY = 0;
CGFloat const ODNavigationTextFont = 17;

/** 欧动集市自定义导航栏高度 */
CGFloat const ODBazaaeExchangeNavHeight = 40;

/** 欧动集市cell的间隙 */
CGFloat const ODBazaaeExchangeCellMargin = 6;

/** 获取验证码时间 */
NSTimeInterval const getVerificationCodeTime = 60;

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

/** 订单列表刷新 */
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





/** 刷新任务发布及回复*/
NSString * const ODNotificationRefreshTask =  @"ODNotificationRefreshTask";

#pragma mark - 请求URL接口
/** 网页接口 */
NSString * const ODWebUrlFindJob = @"http://www.myjob500.com/user/extloginpf";
NSString * const ODWebUrlExpect = @"http://h5.odong.com/woqu/expect";

NSString * const ODWebUrlMapSearch = @"http://h5.odong.com/map/search";

/** 统一的URL */
#ifdef DEBUG
NSString * const ODBaseURL = @"http://woquapi.test.odong.com/1.0";
#else
NSString * const ODBaseURL = @"http://woquapi.odong.com/1.0";
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
NSString * const ODUrlUserAddressAdd = @"user/address/add";




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
NSString * const ODUrlOtherConfigInfo = @"other/config/info";



/** task */
NSString * const ODUrlTaskList = @"task/list";
NSString * const ODUrlTaskTaskAdd = @"task/task/add";
NSString * const ODUrlTaskDetail = @"task/detail";
NSString * const ODUrlTaskApply = @"task/apply"; //接受任务
NSString * const ODurlTaskAccept = @"task/accept";
NSString * const ODurlTaskDelivery = @"task/delivery";
NSString * const ODUrlTaskConfirm = @"task/confirm";



/** bbs */
NSString * const ODUrlBbsList = @"bbs/list";
NSString * const ODUrlBbsDel = @"bbs/del";
NSString * const ODUrlBbsReply = @"bbs/reply";
NSString * const ODUrlBbsSearch = @"bbs/search";
NSString * const ODUrlBbsCreate = @"bbs/create";
NSString * const ODUrlBbsReplyList = @"bbs/reply/list";
NSString * const ODUrlBbsView = @"bbs/view";



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
NSString * const ODUrlSwapCreate = @"swap/create";
NSString * const ODUrlSwapEdit = @"swap/edit";
NSString * const ODUrlSwapInfo = @"swap/info";
NSString * const ODUrlSwapConfirmDelivery = @"swap/confirm/delivery";
NSString * const ODUrlSwapFinish = @"swap/finish";
NSString * const ODUrlSwapOrderReason = @"swap/order/reason";
NSString * const ODUrlSwapSchedule = @"swap/schedule";

/** pay */
NSString * const ODUrlPayWeixinTradeNumber = @"pay/weixin/trade/number";
NSString * const ODUrlPayWeixinCallbackSync = @"pay/weixin/callback/sync";

