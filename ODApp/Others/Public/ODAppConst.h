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

#pragma mark - 通用的Key
/** 偏好设置保存用户信息 */
UIKIT_EXTERN NSString * const KUserDefaultsOpenId;

#pragma mark - 通知
/** 显示集市的通知 */
UIKIT_EXTERN NSString * const ODNotificationShowBazaar;

/** 刷新我的话题通知 */
UIKIT_EXTERN NSString * const ODNotificationMyTaskRefresh;


#pragma mark - 请求URL接口 
/** 统一的URL */
UIKIT_EXTERN NSString *const ODCommonURL;


UIKIT_EXTERN NSString * const kBazaarUnlimitTaskUrl;
UIKIT_EXTERN NSString * const kBazaarReleaseTaskUrl;
UIKIT_EXTERN NSString * const kBazaarTaskDetailUrl;
UIKIT_EXTERN NSString * const kBazaarTaskDelegateUrl;
UIKIT_EXTERN NSString * const kBazaarLabelSearchUrl;
UIKIT_EXTERN NSString * const kBazaarAcceptTaskUrl;
UIKIT_EXTERN NSString * const kBazaarReleaseRewardUrl;
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

UIKIT_EXTERN NSString * const kMyOrderRecordUrl;
UIKIT_EXTERN NSString * const kMyOrderDetailUrl;

UIKIT_EXTERN NSString * const kMyApplyActivityUrl;
UIKIT_EXTERN NSString * const kCancelMyOrderUrl;
UIKIT_EXTERN NSString * const kOthersInformationUrl;
UIKIT_EXTERN NSString * const kSaveAddressUrl;
UIKIT_EXTERN NSString * const kGetAddressUrl;
UIKIT_EXTERN NSString * const kDeleteAddressUrl;