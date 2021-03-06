//
//  ODBazaarReleaseSkillViewController.h
//  ODApp
//
//  Created by Odong-YG on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBaseViewController.h"
#import "UIButton+WebCache.h"
#import "ODBazaarReleaseSkillTimeViewController.h"

@interface ODBazaarReleaseSkillViewController : ODBaseViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UITextField *titleTextField;
@property(nonatomic, strong) UILabel *titleCountLabel;
@property(nonatomic, strong) UITextView *contentTextView;
@property(nonatomic, strong) UILabel *contentCountLabel;
@property(nonatomic, strong) UILabel *contentPlaceholderLabel;
@property(nonatomic, strong) UIButton *addPicButton;
@property(nonatomic, strong) UITextField *priceTextField;
@property(nonatomic, strong) UITextField *unitTextField;
@property(nonatomic, strong) UIView *picView;
@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UILabel *setLabel;
@property(nonatomic, strong) UIView *timeView;
@property(nonatomic) BOOL isHaveDian;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, strong) UIImage *pickedImage;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSMutableArray *strArray;
@property(nonatomic, strong) UIButton *selectedButton;
@property(nonatomic, strong) NSMutableArray *timeArray;
@property(nonatomic, strong) NSMutableArray *editTimeArray;
@property(nonatomic, strong) NSMutableArray *mArray;
@property(nonatomic, copy) NSString *swap_type;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *swap_id;
@end
