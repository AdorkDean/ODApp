//
//  ODCommunityReleaseTopicViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"
#import "ODTabBarController.h"
#import "ODClassMethod.h"
#import "ODColorConversion.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"

@interface ODCommunityReleaseTopicViewController : ODBaseViewController<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,strong)UIView *headView;
@property(nonatomic,strong)UITextView *titleTextView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextView *topicContentTextView;
@property(nonatomic,strong)UILabel *topicContentLabel;
@property(nonatomic,strong)UIButton *addPicButton;
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;

@end
