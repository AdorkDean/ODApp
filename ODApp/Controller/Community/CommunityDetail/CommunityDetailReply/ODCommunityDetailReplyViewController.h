//
//  ODCommunityDetailReplyViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/30.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "ODCommunityDetailModel.h"

@interface ODCommunityDetailReplyViewController : ODBaseViewController<UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,copy)NSString *bbs_id;
@property(nonatomic,copy)NSString *parent_id;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,copy)void(^myBlock)(NSString *refresh,ODCommunityDetailModel *model);


@end
