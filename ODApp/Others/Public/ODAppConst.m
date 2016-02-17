#import <UIKit/UIKit.h>

#pragma mark - UI相关常量
/** TabBar的高度 */
CGFloat const ODTabBarHeight = 55;
CGFloat const ODNavigationHeight = 64;
CGFloat const ODLeftMargin = 17.5;
CGFloat const ODTopY = 0;

#pragma mark - 通用的Key
/** 偏好设置保存用户信息 */
NSString *const KUserDefaultsOpenId = @"userOpenId";

#pragma mark - 通知
/** 显示集市的通知 */
NSString *const ODNotificationShowBazaar = @"ODShowBazaarNotification";

/** 刷新我的话题通知 */
NSString *const ODNotificationMyTaskRefresh = @"ODNotificationMyTaskRefresh";

#pragma mark - 请求URL接口
/** 统一的URL */
#ifdef DEBUG
NSString * const ODBaseURL = @"http://woquapi.test.odong.com/1.0/";
#else
NSString * const ODBaseURL = @"http://woquapi.test.odong.com/1.0/";
#endif

NSString * const kBazaarUnlimitTaskUrl = @"http://woquapi.test.odong.com/1.0/task/list";
NSString * const kBazaarLabelSearchUrl = @"http://woquapi.test.odong.com/1.0/task/tag/search";
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
NSString * const kCommunityBbsListUrl = @"http://woquapi.test.odong.com/1.0/bbs/list/latest";
NSString * const kCommunityReleaseBbsUrl = @"http://woquapi.test.odong.com/1.0/bbs/create";
NSString * const kCommunityBbsDetailUrl = @"http://woquapi.test.odong.com/1.0/bbs/view";
NSString * const kCommunityBbsSearchUrl = @"http://woquapi.test.odong.com/1.0/bbs/search";
NSString * const kCommunityBbsReplyListUrl = @"http://woquapi.test.odong.com/1.0/bbs/reply/list";
NSString * const kCommunityBbsReplyUrl = @"http://woquapi.test.odong.com/1.0/bbs/reply";
NSString * const kCommunityBbsLatestUrl = @"http://woquapi.test.odong.com/1.0/bbs/list";

NSString * const kPushImageUrl = @"http://woquapi.test.odong.com/1.0/other/base64/upload";
NSString * const kDeleteReplyUrl = @"http://woquapi.test.odong.com/1.0/bbs/del";

NSString * const kHomeFoundListUrl = @"http://woquapi.test.odong.com/1.0/bbs/list";
NSString * const kHomeFoundPictureUrl = @"http://woquapi.test.odong.com/1.0/other/banner";

NSString * const ODSkillDetailUrl = @"http://woquapi.test.odong.com/1.0/swap/info";

NSString * const kMyOrderRecordUrl = @"http://woquapi.test.odong.com/1.0/store/orders";
NSString * const kMyOrderDetailUrl = @"http://woquapi.test.odong.com/1.0/store/info/order";

NSString * const kMyApplyActivityUrl = @"http://woquapi.test.odong.com/1.0/store/apply/my";
NSString * const kCancelMyOrderUrl = @"http://woquapi.test.odong.com/1.0/store/cancel/order";
NSString * const kOthersInformationUrl = @"http://woquapi.test.odong.com/1.0/user/info";
NSString * const kSaveAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/add";
NSString * const kGetAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/list";
NSString * const kDeleteAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/del";
NSString * const kEditeAddressUrl = @"http://woquapi.test.odong.com/1.0/user/address/edit";

NSString * const kGetServecTimeUrl = @"http://woquapi.test.odong.com/1.0/swap/service/time";
NSString * const kSaveOrderUrl = @"http://woquapi.test.odong.com/1.0/swap/order";

NSString * const KActivityListUrl = @"store/activity/list";
NSString * const KActivityDetailUrl = @"store/apply/detail2";

NSString * const kGetLikeListUrl = @"http://woquapi.test.odong.com/1.0/swap/love/list";
NSString * const kGetMyOrderListUrl = @"http://woquapi.test.odong.com/1.0/swap/order/list";
NSString * const kOrderDetailUrl = @"http://woquapi.test.odong.com/1.0/swap/order/info";
NSString * const kDelateOrderUrl = @"http://woquapi.test.odong.com/1.0/swap/order/cancel";

NSString * const kGetUserInformationUrl = @"http://woquapi.test.odong.com/1.0/user/info";
NSString * const kGetImageDataUrl = @"http://woquapi.test.odong.com/1.0/other/base64/upload";
NSString * const kChangeUserInformationUrl = @"http://woquapi.test.odong.com/1.0/user/change";
NSString * const kChangePassWorldUrl = @"http://woquapi.test.odong.com/1.0/user/change/passwd";
NSString * const kGetCodeUrl = @"http://woquapi.test.odong.com/1.0/user/verify/code/send";
NSString * const kLoginUrl = @"http://woquapi.test.odong.com/1.0/user/login1";
NSString * const kRegistUrl = @"http://woquapi.test.odong.com/1.0/user/register";
NSString * const kGetTopicUrl = @"http://woquapi.test.odong.com/1.0/bbs/list";
NSString * const kGetTaskUrl = @"http://woquapi.test.odong.com/1.0/task/list";
NSString * const kDelateTaskUrl = @"http://woquapi.test.odong.com/1.0/bbs/del";
NSString * const kGetCommentUrl = @"http://woquapi.test.odong.com/1.0/user/comment/list";
NSString * const kCreateOrderUrl = @"http://woquapi.test.odong.com/1.0/store/create/order";
NSString * const kGetStoreTimeUrl = @"http://woquapi.test.odong.com/1.0/store/timeline";
NSString * const kSaveStoreOrderUrl = @"http://woquapi.test.odong.com/1.0/store/confirm/order";


NSString * const kGetUMAppkey = @"569dda54e0f55a994f0021cf";
NSString * const kGetWXAppId = @"wxd25da104118aae2a";
NSString * const kGetWXAppSecret = @"5da1d304e3b05fe65e4c14deddfa56f1";

