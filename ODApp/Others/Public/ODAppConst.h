#import <UIKit/UIKit.h>


#pragma mark - UI相关常量
/** TabBar的高度 */
UIKIT_EXTERN CGFloat const ODTabBarHeight;
/** 导航控制器的高度 */
UIKIT_EXTERN CGFloat const ODNavigationHeight;
/** 控件的左边间距 */
UIKIT_EXTERN CGFloat const ODLeftMargin;
/** 控制器View的顶部坐标y */
UIKIT_EXTERN CGFloat const ODTopY;
/** 导航栏标题字体大小 */
UIKIT_EXTERN CGFloat const ODNavigationTextFont;

#pragma mark - 通用的Key
/** 偏好设置保存用户信息 */
UIKIT_EXTERN NSString * const kUserCache;
UIKIT_EXTERN NSString * const KUserDefaultsOpenId;

UIKIT_EXTERN NSString * const KUserDefaultsAvatar;

UIKIT_EXTERN NSString * const KUserDefaultsMobile;

/** info.plist中记录的版本号 */
UIKIT_EXTERN NSString * const kUserDefaultsVersionKey;

/** 友盟的apiKey */
UIKIT_EXTERN NSString * const kGetUMAppkey;

#pragma mark - 通知
/** 显示集市的通知 */
UIKIT_EXTERN NSString * const ODNotificationShowBazaar;

/** 刷新我的话题通知 */
UIKIT_EXTERN NSString * const ODNotificationMyTaskRefresh;


/**  求帮助的通知 */
UIKIT_EXTERN NSString * const ODNotificationSearchHelp;

/**  换技能通知 */
UIKIT_EXTERN NSString * const ODNotificationChangeSkill;

/**  发布任务成功通知 */
UIKIT_EXTERN NSString * const ODNotificationCreateServiceTimeView;

/**  发布任务成功通知 */
UIKIT_EXTERN NSString * const ODNotificationReleaseTask;

/**  发布技能成功通知 */
UIKIT_EXTERN NSString * const ODNotificationReleaseSkill;

/**  寻圈子的通知 */
UIKIT_EXTERN NSString * const ODNotificationSearchCircle;

/**  编辑成功的通知 */
UIKIT_EXTERN NSString * const ODNotificationEditSkill;

/**  支付成功通知 */
UIKIT_EXTERN NSString * const ODNotificationPaySuccess;

/**  支付失败通知 */
UIKIT_EXTERN NSString * const ODNotificationPayfail;

/**  支付失败通知 */
UIKIT_EXTERN NSString * const ODNotificationCancelOrder;

/** 定位刷新 */
UIKIT_EXTERN NSString * const ODNotificationLocationSuccessRefresh;

/** 订单刷新 */
UIKIT_EXTERN NSString * const ODNotificationOrderListRefresh;

/**  退出成功刷新集市状态 */
UIKIT_EXTERN NSString * const ODNotificationQuit;

/**  回复成功后刷新 */
UIKIT_EXTERN NSString * const ODNotificationReplySuccess;

/**  登录成功后的通知 */
UIKIT_EXTERN NSString * const ODNotificationLoginSuccess;

/** 已购买二级页面通知 */
UIKIT_EXTERN NSString * const ODNotificationMyOrderSecondRefresh;
/** 已购买三级页面通知 */
UIKIT_EXTERN NSString * const ODNotificationMyOrderThirdRefresh;
/** 已卖出二级页面通知 */
UIKIT_EXTERN NSString * const ODNotificationSellOrderSecondRefresh;
/** 已购买三级页面通知 */
UIKIT_EXTERN NSString * const ODNotificationSellOrderThirdRefresh;

/**  点击收藏的通知 */
UIKIT_EXTERN NSString * const ODNotificationloveSkill;


#pragma mark - 请求URL接口
/** 统一的URL */
UIKIT_EXTERN NSString * const ODBaseURL;
UIKIT_EXTERN NSString * const ODURL;

UIKIT_EXTERN NSString * const ODUrlOtherLoveAdd;
UIKIT_EXTERN NSString * const ODUrlOtherLoveDelete;
UIKIT_EXTERN NSString * const ODUrlMyApplyActivity;
UIKIT_EXTERN NSString * const ODUrlHomeFound;
UIKIT_EXTERN NSString * const ODUrlActivityList;
UIKIT_EXTERN NSString * const ODUrlActivityDetail;
UIKIT_EXTERN NSString * const ODUrlActivityApply;
UIKIT_EXTERN NSString * const ODUrlOtherCityList;
UIKIT_EXTERN NSString * const ODUrlOtherShareCallBack;
UIKIT_EXTERN NSString * const ODUrlPersonalReleaseTask;
UIKIT_EXTERN NSString * const ODUrlOtherStoreDetail;
UIKIT_EXTERN NSString * const ODUrlStoreTime;
UIKIT_EXTERN NSString * const ODUrlOtherLoveDel;
UIKIT_EXTERN NSString * const ODUrlStoreApplyMy;
UIKIT_EXTERN NSString * const ODUrlHomeFound;
UIKIT_EXTERN NSString * const ODUrlStoreActivityList;
UIKIT_EXTERN NSString * const ODUrlStoreApplyDetail2;
UIKIT_EXTERN NSString * const ODUrlStoreActivityApply;
UIKIT_EXTERN NSString * const ODUrlOtherCityList;
UIKIT_EXTERN NSString * const ODUrlOtherShareCallBack;
UIKIT_EXTERN NSString * const ODUrlSwapList;
UIKIT_EXTERN NSString * const ODUrlOtherStoreDetail;
UIKIT_EXTERN NSString * const ODUrlStoreTimeline1;
UIKIT_EXTERN NSString * const ODUrlUserChange;
UIKIT_EXTERN NSString * const ODUrlUserCodeSend;
UIKIT_EXTERN NSString * const ODUrlUserRegist;
UIKIT_EXTERN NSString * const ODUrlUserInfo;
UIKIT_EXTERN NSString * const ODUrlUserChangePasswd;
UIKIT_EXTERN NSString * const ODUrlUserLogin1;
UIKIT_EXTERN NSString * const ODUrlUserAddressDel;
UIKIT_EXTERN NSString * const ODUrlUserAssressAdd;
UIKIT_EXTERN NSString * const ODUrlUserLoveList;



UIKIT_EXTERN NSString * const ODUrlUserBindMoble;

UIKIT_EXTERN NSString * const ODUrlStoreOrders;
UIKIT_EXTERN NSString * const ODUrlStoreInfoOrder;
UIKIT_EXTERN NSString * const ODUrlOtherStoreDetail;
UIKIT_EXTERN NSString * const ODUrlStoreCancelOrder;
UIKIT_EXTERN NSString * const ODUrlStoreApply;


UIKIT_EXTERN NSString * const ODUrlTaskTaskAdd;
UIKIT_EXTERN NSString * const ODUrlTaskDetail;



UIKIT_EXTERN NSString * const ODUrlCommunityBbsList;
UIKIT_EXTERN NSString * const ODUrlSwapDel;
UIKIT_EXTERN NSString * const ODUrlSwapOrderCancel;
UIKIT_EXTERN NSString * const ODUrlSwapRejectRefund;
UIKIT_EXTERN NSString * const ODUrlSwapConfirmRefund;
UIKIT_EXTERN NSString * const ODUrlSwapServiceTime;

UIKIT_EXTERN NSString * const ODUrlBbsList;
//UIKIT_EXTERN NSString * const ODUrlBbsDel;



UIKIT_EXTERN NSString * const ODUrlOtherStoreList;
UIKIT_EXTERN NSString * const ODUrlOtherHome;


UIKIT_EXTERN NSString * const ODUrlBazaarRequestHelp;
UIKIT_EXTERN NSString * const ODUrlBazaarReleaseTask;

//UIKIT_EXTERN NSString * const kBazaarReleaseTaskUrl;
UIKIT_EXTERN NSString * const kBazaarTaskDetailUrl;

//UIKIT_EXTERN NSString * const kBazaarReleaseTaskUrl;
//UIKIT_EXTERN NSString * const kBazaarTaskDetailUrl;

UIKIT_EXTERN NSString * const kBazaarTaskDelegateUrl;
UIKIT_EXTERN NSString * const kBazaarAcceptTaskUrl;
//UIKIT_EXTERN NSString * const kBazaarReleaseRewardUrl;
UIKIT_EXTERN NSString * const ODUrlRequestHelpReward;

//UIKIT_EXTERN NSString * const kBazaarExchangeSkillUrl;
UIKIT_EXTERN NSString * const ODUrlBazaarExchangeSkill;
UIKIT_EXTERN NSString * const ODUrlBazaarSkillDetail;
UIKIT_EXTERN NSString * const kBazaarExchangeSkillDetailUrl;
UIKIT_EXTERN NSString * const kBazaarReleaseSkillTimeUrl;
//UIKIT_EXTERN NSString * const kBazaarExchangeSkillDetailLoveUrl;
//UIKIT_EXTERN NSString * const kBazaarExchangeSkillDetailNotLoveUrl;

UIKIT_EXTERN NSString * const ODUrlSkillDetailLove;
UIKIT_EXTERN NSString * const ODUrlSkillDetailNotLove;

//UIKIT_EXTERN NSString * const kBazaarReleaseSkillUrl;
UIKIT_EXTERN NSString * const ODUrlBazaarReleaseSkill;

//UIKIT_EXTERN NSString * const kBazaarEditSkillUrl;
UIKIT_EXTERN NSString * const ODUrlBazaarEditSkill;
/** 接收人确认完成 */
UIKIT_EXTERN NSString * const kBazaarTaskReceiveCompleteUrl;
/** 发起人确认完成 */
UIKIT_EXTERN NSString * const kBazaarTaskInitiateCompleteUrl;

UIKIT_EXTERN NSString * const ODUrlCommunityReleaseBbs;
UIKIT_EXTERN NSString * const kCommunityBbsDetailUrl;
UIKIT_EXTERN NSString * const ODUrlCommunityBbsSearch;
UIKIT_EXTERN NSString * const kCommunityBbsReplyListUrl;
UIKIT_EXTERN NSString * const kCommunityBbsReplyUrl;
UIKIT_EXTERN NSString * const ODUrlCommunityBbsReply;
UIKIT_EXTERN NSString * const kCommunityBbsLatestUrl;

UIKIT_EXTERN NSString * const kPushImageUrl;
UIKIT_EXTERN NSString * const kDeleteReplyUrl;

UIKIT_EXTERN NSString * const kHomeFoundListUrl;

UIKIT_EXTERN NSString * const ODWebUrlFindJob;


//UIKIT_EXTERN NSString * const ODStoreListUrl;
//UIKIT_EXTERN NSString * const ODStoreDetailUrl;

//UIKIT_EXTERN NSString * const kMyOrderRecordUrl;
//UIKIT_EXTERN NSString * const kMyOrderDetailUrl;
//UIKIT_EXTERN NSString * const kCancelMyOrderUrl;
//UIKIT_EXTERN NSString * const kSaveAddressUrl;
UIKIT_EXTERN NSString * const kSaveAddressUrl;
UIKIT_EXTERN NSString * const ODUrlUserAddressList;
//UIKIT_EXTERN NSString * const kDeleteAddressUrl;
//UIKIT_EXTERN NSString * const kGetServecTimeUrl;
UIKIT_EXTERN NSString * const ODUrlStoreConfirmOrder;


UIKIT_EXTERN NSString * const ODUrlSwapLoveList;
UIKIT_EXTERN NSString * const ODUrlSwapOrderList;
UIKIT_EXTERN NSString * const ODUrlSwapOrderInfo;

UIKIT_EXTERN NSString * const ODUrlSwapOrderCancel;

UIKIT_EXTERN NSString * const ODUrlOtherBase64Upload;
UIKIT_EXTERN NSString * const kChangePassWorldUrl;
UIKIT_EXTERN NSString * const kGetCodeUrl;
UIKIT_EXTERN NSString * const kLoginUrl;
UIKIT_EXTERN NSString * const ODUrlTaskList;
UIKIT_EXTERN NSString * const ODUrlBbsDel;
UIKIT_EXTERN NSString * const ODUrlUserCommentList;
UIKIT_EXTERN NSString * const ODUrlCreateOrder;
UIKIT_EXTERN NSString * const ODUrlStoreApplyUsers;
UIKIT_EXTERN NSString * const kGetTaskUrl;
UIKIT_EXTERN NSString * const kDelateTaskUrl;
UIKIT_EXTERN NSString * const kGetCommentUrl;
UIKIT_EXTERN NSString * const ODUrlStoreCreateOrder;
UIKIT_EXTERN NSString * const kGetApplyListUrl;

UIKIT_EXTERN NSString * const ODUrlOtherFeedback;

UIKIT_EXTERN NSString * const ODUrlPayWeixinTradeNumber;

UIKIT_EXTERN NSString * const ODPersonReleaseTaskDeleteUrl;
UIKIT_EXTERN NSString * const ODReleaseDrawbackUrl;

UIKIT_EXTERN NSString * const ODRefuseDrawbackUrl;
UIKIT_EXTERN NSString * const ODReceiveDrawbackUrl;



UIKIT_EXTERN NSString * const ODUrlSkillCollection;

UIKIT_EXTERN NSString * const kCollectionUrl;
UIKIT_EXTERN NSString * const ODUrlUserWithdrawCash;
UIKIT_EXTERN NSString * const ODUrlUserCashList;
UIKIT_EXTERN NSString * const ODUrlSwapSellerOrderList;
UIKIT_EXTERN NSString * const ODUrlUserLoveList;
>>>>>>> 2c52cced8c65c6862043dc93615c588c84c4a451
UIKIT_EXTERN NSString * const kBalanceUrl;
UIKIT_EXTERN NSString * const kBalanceListUrl;
UIKIT_EXTERN NSString * const kMySellListUrl;
UIKIT_EXTERN NSString * const kDeliveryUrl;
UIKIT_EXTERN NSString * const kFinshOrderUrl;
UIKIT_EXTERN NSString * const kEvalueUrl;
UIKIT_EXTERN NSString * const ODUrlSwapOrder;
UIKIT_EXTERN NSString * const ODUrlPayWeixinCallbackSync;
