//
//  ODCommunityReleaseTopicViewController.h
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBaseViewController.h"

@interface ODCommunityReleaseTopicViewController : ODBaseViewController <UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UITextView *titleTextView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextView *topicContentTextView;
@property(nonatomic, strong) UILabel *topicContentLabel;
@property(nonatomic, strong) UIButton *addPicButton;
@property(nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic, strong) NSMutableArray *strArray;
@property(nonatomic, strong) NSMutableArray *labelArray;
@property(nonatomic, strong) UIButton *lastSelectedButton;
@property(nonatomic, copy) void(^myBlock)(NSString *refresh);
@property(nonatomic, strong) UIImage *pickedImage;

@end
