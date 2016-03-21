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

/** 欧动集市自定义导航栏高度 */
UIKIT_EXTERN CGFloat const ODBazaaeExchangeNavHeight;

/** 欧动集市cell的间隙 */
UIKIT_EXTERN CGFloat const ODBazaaeExchangeCellMargin;

/** 获取验证码时间 */
UIKIT_EXTERN NSTimeInterval const getVerificationCodeTime;

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

/** 刷新任务发布及回复*/
UIKIT_EXTERN NSString * const ODNotificationRefreshTask;

#pragma mark - 网页URL

UIKIT_EXTERN NSString * const ODWebUrlFindJob;
UIKIT_EXTERN NSString * const ODWebUrlExpect;
UIKIT_EXTERN NSString * const ODWebUrlMapSearch;



#pragma mark - 请求URL接口

/** 统一的URL */
UIKIT_EXTERN NSString * const ODBaseURL;



//  bbs
UIKIT_EXTERN NSString * const ODUrlBbsList;
UIKIT_EXTERN NSString * const ODUrlBbsDel;
UIKIT_EXTERN NSString * const ODUrlBbsReplyList;
UIKIT_EXTERN NSString * const ODUrlBbsView;
UIKIT_EXTERN NSString * const ODUrlBbsCreate;
UIKIT_EXTERN NSString * const ODUrlBbsSearch;
UIKIT_EXTERN NSString * const ODUrlBbsReply;



//  other
UIKIT_EXTERN NSString * const ODUrlOtherLoveAdd;
UIKIT_EXTERN NSString * const ODUrlOtherCityList;
UIKIT_EXTERN NSString * const ODUrlOtherShareCallBack;
UIKIT_EXTERN NSString * const ODUrlOtherStoreDetail;
UIKIT_EXTERN NSString * const ODUrlOtherLoveDel;
UIKIT_EXTERN NSString * const ODUrlOtherCityList;
UIKIT_EXTERN NSString * const ODUrlOtherShareCallBack;
UIKIT_EXTERN NSString * const ODUrlOtherStoreDetail;
UIKIT_EXTERN NSString * const ODUrlOtherStoreList;
UIKIT_EXTERN NSString * const ODUrlOtherHome;
UIKIT_EXTERN NSString * const ODUrlOtherConfigInfo;
UIKIT_EXTERN NSString * const ODUrlOtherBase64Upload;
UIKIT_EXTERN NSString * const ODUrlOtherFeedback;



//   pay
UIKIT_EXTERN NSString * const ODUrlPayWeixinTradeNumber;
UIKIT_EXTERN NSString * const ODUrlPayWeixinCallbackSync;



//   store
UIKIT_EXTERN NSString * const ODUrlStoreConfirmOrder;
UIKIT_EXTERN NSString * const ODUrlStoreApplyUsers;
UIKIT_EXTERN NSString * const ODUrlStoreCreateOrder;
UIKIT_EXTERN NSString * const ODUrlStoreTime;
UIKIT_EXTERN NSString * const ODUrlStoreApplyMy;
UIKIT_EXTERN NSString * const ODUrlStoreActivityList;
UIKIT_EXTERN NSString * const ODUrlStoreApplyDetail2;
UIKIT_EXTERN NSString * const ODUrlStoreActivityApply;
UIKIT_EXTERN NSString * const ODUrlStoreTimeline1;
UIKIT_EXTERN NSString * const ODUrlStoreOrders;
UIKIT_EXTERN NSString * const ODUrlStoreInfoOrder;
UIKIT_EXTERN NSString * const ODUrlStoreCancelOrder;
UIKIT_EXTERN NSString * const ODUrlStoreApply;



// swap
UIKIT_EXTERN NSString * const ODUrlSwapSellerOrderList;
UIKIT_EXTERN NSString * const ODUrlSwapLoveList;
UIKIT_EXTERN NSString * const ODUrlSwapOrderList;
UIKIT_EXTERN NSString * const ODUrlSwapOrderInfo;
UIKIT_EXTERN NSString * const ODUrlSwapConfirmDelivery;
UIKIT_EXTERN NSString * const ODUrlSwapFinish;
UIKIT_EXTERN NSString * const ODUrlSwapOrderReason;
UIKIT_EXTERN NSString * const ODUrlSwapOrder;
UIKIT_EXTERN NSString * const ODUrlSwapList;
UIKIT_EXTERN NSString * const ODUrlSwapDel;
UIKIT_EXTERN NSString * const ODUrlSwapOrderCancel;
UIKIT_EXTERN NSString * const ODUrlSwapRejectRefund;
UIKIT_EXTERN NSString * const ODUrlSwapConfirmRefund;
UIKIT_EXTERN NSString * const ODUrlSwapServiceTime;
UIKIT_EXTERN NSString * const ODUrlSwapInfo;
UIKIT_EXTERN NSString * const ODUrlSwapSchedule;
UIKIT_EXTERN NSString * const ODUrlSwapCreate;
UIKIT_EXTERN NSString * const ODUrlSwapEdit;



//  task
UIKIT_EXTERN NSString * const ODUrlTaskTaskAdd;
UIKIT_EXTERN NSString * const ODUrlTaskDetail;
UIKIT_EXTERN NSString * const ODUrlTaskApply;
UIKIT_EXTERN NSString * const ODurlTaskAccept;
UIKIT_EXTERN NSString * const ODurlTaskDelivery;
UIKIT_EXTERN NSString * const ODUrlTaskConfirm;
UIKIT_EXTERN NSString * const ODUrlTaskList;



//  user
UIKIT_EXTERN NSString * const ODUrlUserCommentList;
UIKIT_EXTERN NSString * const ODUrlUserWithdrawCash;
UIKIT_EXTERN NSString * const ODUrlUserCashList;
UIKIT_EXTERN NSString * const ODUrlUserLoveList;
UIKIT_EXTERN NSString * const ODUrlUserChange;
UIKIT_EXTERN NSString * const ODUrlUserCodeSend;
UIKIT_EXTERN NSString * const ODUrlUserRegist;
UIKIT_EXTERN NSString * const ODUrlUserInfo;
UIKIT_EXTERN NSString * const ODUrlUserChangePasswd;
UIKIT_EXTERN NSString * const ODUrlUserLogin1;
UIKIT_EXTERN NSString * const ODUrlUserAddressDel;
UIKIT_EXTERN NSString * const ODUrlUserAddressAdd;
UIKIT_EXTERN NSString * const ODUrlUserLoveList;
UIKIT_EXTERN NSString * const ODUrlUserBindMoble;
UIKIT_EXTERN NSString * const ODUrlUserAddressList;



