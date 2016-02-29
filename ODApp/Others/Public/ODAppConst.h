#import <UIKit/UIKit.h>


#pragma mark - 蒙版提示语
UIKIT_EXTERN NSString * const ODAlertIsLoading;

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
UIKIT_EXTERN NSString * const KUserDefaultsOpenId;

UIKIT_EXTERN NSString * const KUserDefaultsAvatar;

UIKIT_EXTERN NSString * const KUserDefaultsMobile;


UIKIT_EXTERN NSString * const kGetUMAppkey;
UIKIT_EXTERN NSString * const kGetWXAppId;
UIKIT_EXTERN NSString * const kGetWXAppSecret;

/** 高德地图的apiKey */
UIKIT_EXTERN NSString *const ODLocationApiKey;



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


/** 已购买二级页面通知 */
UIKIT_EXTERN NSString * const ODNotificationMyOrderSecondRefresh ;
/** 已购买三级页面通知 */
UIKIT_EXTERN NSString * const ODNotificationMyOrderThirdRefresh ;
/** 已卖出二级页面通知 */
UIKIT_EXTERN NSString * const ODNotificationSellOrderSecondRefresh;
/** 已购买三级页面通知 */
UIKIT_EXTERN NSString * const ODNotificationSellOrderThirdRefresh ;

/**  点击收藏的通知 */
UIKIT_EXTERN NSString * const ODNotificationloveSkill;



#pragma mark - 请求URL接口 
/** 统一的URL */
UIKIT_EXTERN NSString * const ODBaseURL;

UIKIT_EXTERN NSString * const ODUrlLoveAdd;
UIKIT_EXTERN NSString * const ODUrlLoveDelete;
UIKIT_EXTERN NSString * const ODUrlMyApplyActivity;

UIKIT_EXTERN NSString * const kBazaarUnlimitTaskUrl;
UIKIT_EXTERN NSString * const kBazaarReleaseTaskUrl;
UIKIT_EXTERN NSString * const kBazaarTaskDetailUrl;
UIKIT_EXTERN NSString * const kBazaarTaskDelegateUrl;
UIKIT_EXTERN NSString * const kBazaarLabelSearchUrl;
UIKIT_EXTERN NSString * const kBazaarAcceptTaskUrl;
UIKIT_EXTERN NSString * const kBazaarReleaseRewardUrl;
UIKIT_EXTERN NSString * const kBazaarExchangeSkillUrl;
UIKIT_EXTERN NSString * const kBazaarExchangeSkillDetailUrl;
UIKIT_EXTERN NSString * const kBazaarReleaseSkillTimeUrl;
UIKIT_EXTERN NSString * const kBazaarExchangeSkillDetailLoveUrl;
UIKIT_EXTERN NSString * const kBazaarExchangeSkillDetailNotLoveUrl;
UIKIT_EXTERN NSString * const kBazaarReleaseSkillUrl;
UIKIT_EXTERN NSString * const kBazaarEditSkillUrl;
/** 接收人确认完成 */
UIKIT_EXTERN NSString * const kBazaarTaskReceiveCompleteUrl;
/** 发起人确认完成 */
UIKIT_EXTERN NSString * const kBazaarTaskInitiateCompleteUrl;

UIKIT_EXTERN NSString * const kCommunityBbsListUrl;
UIKIT_EXTERN NSString * const kCommunityReleaseBbsUrl;
UIKIT_EXTERN NSString * const kCommunityBbsDetailUrl;
UIKIT_EXTERN NSString * const kCommunityBbsSearchUrl;
UIKIT_EXTERN NSString * const kCommunityBbsReplyListUrl;
UIKIT_EXTERN NSString * const kCommunityBbsReplyUrl;
UIKIT_EXTERN NSString * const kCommunityBbsLatestUrl;

UIKIT_EXTERN NSString * const kPushImageUrl;
UIKIT_EXTERN NSString * const kDeleteReplyUrl;

UIKIT_EXTERN NSString * const kHomeFoundListUrl;
UIKIT_EXTERN NSString * const kHomeFoundPictureUrl;

UIKIT_EXTERN NSString * const ODSkillDetailUrl;
UIKIT_EXTERN NSString * const ODFindJobUrl;
UIKIT_EXTERN NSString * const ODHotActivityUrl;
UIKIT_EXTERN NSString * const ODHomeFoundUrl;
UIKIT_EXTERN NSString * const ODCityListUrl;
UIKIT_EXTERN NSString * const ODHomeChangeSkillUrl;

UIKIT_EXTERN NSString *const ODStoreListUrl;
UIKIT_EXTERN NSString *const ODStoreDetailUrl;

UIKIT_EXTERN NSString * const kMyOrderRecordUrl;
UIKIT_EXTERN NSString * const kMyOrderDetailUrl;
UIKIT_EXTERN NSString * const kCancelMyOrderUrl;
UIKIT_EXTERN NSString * const kOthersInformationUrl;
UIKIT_EXTERN NSString * const kSaveAddressUrl;
UIKIT_EXTERN NSString * const kGetAddressUrl;
UIKIT_EXTERN NSString * const kDeleteAddressUrl;
UIKIT_EXTERN NSString * const kGetServecTimeUrl;
UIKIT_EXTERN NSString * const kSaveOrderUrl;

UIKIT_EXTERN NSString * const KActivityListUrl;
UIKIT_EXTERN NSString * const KActivityDetailUrl;
UIKIT_EXTERN NSString * const KActivityApplyUrl;

UIKIT_EXTERN NSString * const kGetLikeListUrl;
UIKIT_EXTERN NSString * const kGetMyOrderListUrl;
UIKIT_EXTERN NSString * const kOrderDetailUrl;

UIKIT_EXTERN NSString * const kDelateOrderUrl;

UIKIT_EXTERN NSString * const kGetUserInformationUrl;
UIKIT_EXTERN NSString * const kGetImageDataUrl;
UIKIT_EXTERN NSString * const kChangeUserInformationUrl;
UIKIT_EXTERN NSString * const kChangePassWorldUrl;
UIKIT_EXTERN NSString * const kGetCodeUrl;
UIKIT_EXTERN NSString * const kLoginUrl;
UIKIT_EXTERN NSString * const kRegistUrl;
UIKIT_EXTERN NSString * const kGetTopicUrl;
UIKIT_EXTERN NSString * const kGetTaskUrl;
UIKIT_EXTERN NSString * const kDelateTaskUrl;
UIKIT_EXTERN NSString * const kGetCommentUrl;
UIKIT_EXTERN NSString * const kCreateOrderUrl;
UIKIT_EXTERN NSString * const kGetStoreTimeUrl;
UIKIT_EXTERN NSString * const kGetApplyListUrl;

UIKIT_EXTERN NSString * const kGiveOpinionUrl;
UIKIT_EXTERN NSString * const ODPersonalReleaseTaskUrl;

UIKIT_EXTERN NSString * const kGetPayInformationUrl;

UIKIT_EXTERN NSString * const ODPersonReleaseTaskDeleteUrl;
UIKIT_EXTERN NSString * const ODReleaseDrawbackUrl;

UIKIT_EXTERN NSString * const ODRefuseDrawbackUrl;
UIKIT_EXTERN NSString * const ODReceiveDrawbackUrl;

UIKIT_EXTERN NSString * const kCallbackUrl;

UIKIT_EXTERN NSString * const kCollectionUrl;
UIKIT_EXTERN NSString * const kBalanceUrl;
UIKIT_EXTERN NSString * const kBalanceListUrl;
UIKIT_EXTERN NSString * const kMySellListUrl;
UIKIT_EXTERN NSString * const kDeliveryUrl;
UIKIT_EXTERN NSString * const kFinshOrderUrl;
UIKIT_EXTERN NSString * const kEvalueUrl;
UIKIT_EXTERN NSString * const kPayBackUrl;
UIKIT_EXTERN NSString * const kGetOrderUrl;
