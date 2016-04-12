//
//  ODCommunityReleaseTopicViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCommunityReleaseTopicViewController.h"
#import "ODUploadImageModel.h"
#import "AFNetworking.h"

@interface ODCommunityReleaseTopicViewController ()

@end

@implementation ODCommunityReleaseTopicViewController

#pragma mark - lazyload
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 64)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(NSMutableArray *)strArray{
    if (!_strArray) {
        _strArray = [NSMutableArray array];
    }
    return _strArray;
}

-(NSMutableArray *)labelArray{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"新话题";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(cancelButtonClick) color:[UIColor blackColor] highColor:nil title:@"取消"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick) color:[UIColor blackColor] highColor:nil title:@"确认"];
    [self createTextView];
    [self createLabels];
    [self createAddPicButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 拼接参数
-(void)pushImageData:(NSString *)str{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameter = @{@"File":str};
    NSDictionary *signParameter = [ODHttpTool signParameters:parameter];
    __weakSelf
    NSString *url = [NSString stringWithFormat:@"%@/%@",ODBaseURL,ODUrlOtherBase64Upload];
    [manager POST:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSString *str = result[@"File"];
            [weakSelf.strArray addObject:str];
            [weakSelf reloadImageButtons];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

#pragma mark - 上传数据
- (void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter {
    __weakSelf
    [ODHttpTool getWithURL:url parameters:parameter modelClass:[NSObject class] success:^(id model) {
        if (weakSelf.myBlock) {
            weakSelf.myBlock([NSString stringWithFormat:@"refresh"]);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 创建textView
- (void)createTextView {
    self.titleTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 53) delegate:self tag:0 font:13 color:@"#ffffff" alpha:1 maskToBounds:YES];
    self.titleTextView.textColor = [UIColor blackColor];
    [self.scrollView addSubview:self.titleTextView];
    self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 4, kScreenSize.width - 20, 30) text:@"请输入话题标题" font:13 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.titleLabel.textColor = [UIColor colorGrayColor];
    self.titleLabel.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.titleLabel];

    self.topicContentTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, CGRectGetMaxY(self.titleTextView.frame) + 4, kScreenSize.width - 8, 106) delegate:self tag:0 font:13 color:@"#ffffff" alpha:101 maskToBounds:YES];
    self.topicContentTextView.textColor = [UIColor colorWithRGBString:@"#7e7e7e" alpha:1];
    [self.scrollView addSubview:self.topicContentTextView];
    self.topicContentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleTextView.frame) + 4, kScreenSize.width - 20, 30) text:@"请输入话题内容" font:13 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.titleLabel.textColor = [UIColor colorGrayColor];
    self.topicContentLabel.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.topicContentLabel];
}

#pragma mark - 创建标签
- (void)createLabels {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(4, CGRectGetMaxY(self.topicContentTextView.frame) + 10, kScreenSize.width - 8, 15)];
    label.text = @"标签选择";
    label.textColor = [UIColor colorGreyColor];
    label.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:label];

    NSArray *array = @[@"情感", @"搞笑", @"影视", @"二次元", @"生活", @"明星", @"爱美", @"宠物"];
    CGFloat width = (kScreenSize.width - 20) / 4;
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(4 + (width + 4) * (i % 4), CGRectGetMaxY(label.frame) + 10 + (25 + 4) * (i / 4), width, 25);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorGreyColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(labelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 1 + i;
        [self.scrollView addSubview:button];
    }
}

#pragma mark - 创建添加图片按钮
- (void)createAddPicButton {
    CGFloat width = (kScreenSize.width - 20) / 4;
    self.addPicButton = [ODClassMethod creatButtonWithFrame:CGRectMake(4, CGRectGetMaxY(self.topicContentTextView.frame) + 95, width, width) target:self sel:@selector(addPicButtonClick:) tag:0 image:@"发布新话题－默认icon" title:nil font:0];
    self.addPicButton.layer.masksToBounds = YES;
    self.addPicButton.layer.cornerRadius = 5;
    self.addPicButton.layer.borderWidth = 1;
    self.addPicButton.layer.borderColor = [UIColor lineColor].CGColor;
    [self.scrollView addSubview:self.addPicButton];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }else {
                [ODProgressHUD showInfoWithStatus:@"您当前的照相机不可用"];
            }
            break;
        case 1:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    NSString *sourceType = info[UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *) kUTTypeImage]) {
        NSString *imageUrl = [info[UIImagePickerControllerReferenceURL] absoluteString];
        NSRange range;
        range.location = [imageUrl rangeOfString:@"=" options:NSBackwardsSearch].location + 1;
        range.length = imageUrl.length - range.location;
        imageUrl = [imageUrl substringWithRange:range];
        NSData *imageData;
        self.pickedImage = info[UIImagePickerControllerOriginalImage];
        if ([imageUrl.lowercaseString isEqualToString:@"jpg"]) {    // JPG
            self.pickedImage = [UIImage od_scaleImage:self.pickedImage];
            imageData = UIImageJPEGRepresentation(self.pickedImage, 0.3);
        } else if (!imageUrl.length) { // 拍照
            self.pickedImage = [UIImage od_scaleImage:self.pickedImage];
            imageData = UIImageJPEGRepresentation(self.pickedImage, 0.3);
        } else {    // 其他类型 : bmp...
            imageData = UIImagePNGRepresentation(self.pickedImage);
        }
        NSString *str = @"data:image/jpeg;base64,";
        NSString *strData = [str stringByAppendingString:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        [self.imageArray addObject:self.pickedImage];
        [ODProgressHUD showProgressWithStatus:@"正在上传"];
        [self pushImageData:strData];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)reloadImageButtons {
    NSInteger width = (kScreenSize.width - 20) / 4;
    for (UIButton *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]] && ![view isEqual:self.addPicButton]) {
            [view removeFromSuperview];
        }
    }
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setBackgroundImage:self.imageArray[i] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.tag = 10010 + i;
        [button addTarget:self action:@selector(deletePicClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(4 + (width + 4) * (i % 4), CGRectGetMaxY(self.topicContentTextView.frame) + 95 + (4 + width) * (i / 4), width, width);
        [self.scrollView addSubview:button];
    }
    [self.addPicButton setFrame:CGRectMake(4 + (width + 4) * (self.imageArray.count % 4), CGRectGetMaxY(self.topicContentTextView.frame) + 95 + (4 + width) * (self.imageArray.count / 4), width, width)];
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, 262 + (self.imageArray.count / 4 + 1) * (width + 4));
    [ODProgressHUD dismiss];
}

#pragma mark - 拼接参数
- (void)joiningTogetherParmeters {
    NSString *imageStr = [[NSString alloc] init];
    for (NSInteger i = 0; i < self.strArray.count; i++) {
        if (i == 0) {
            imageStr = self.strArray[i];
        } else {
            NSString *str = self.strArray[i];
            imageStr = [[imageStr stringByAppendingString:@"|"] stringByAppendingString:str];
        }
    }

    NSString *tag_ids = [[NSString alloc] init];
    for (NSInteger i = 0; i < self.labelArray.count; i++) {
        if (i == 0) {
            tag_ids = self.labelArray[i];
        } else {
            NSString *tag = self.labelArray[i];
            tag_ids = [[tag_ids stringByAppendingString:@"|"] stringByAppendingString:tag];
        }
    }
    NSDictionary *parameter = @{@"title" : self.titleTextView.text, @"content" : self.topicContentTextView.text, @"tag_ids" : tag_ids, @"imgs" : imageStr};
    [self pushDataWithUrl:ODUrlBbsCreate parameter:parameter];
}

#pragma mark - UITextViewDelegate
NSString *topicTitleText = @"";
NSString *topicContentText = @"";
- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.titleTextView) {
        if (textView.text.length > 30) {
            textView.text = [textView.text substringToIndex:30];
        } else {
            topicTitleText = textView.text;
        }
        
        if (self.titleTextView.text.length == 0) {
            self.titleLabel.text = @"请输入话题标题";
        } else {
            self.titleLabel.text = @"";
        }
    } else if (textView == self.topicContentTextView) {
        if (textView.text.length > 500) {
            textView.text = [textView.text substringToIndex:500];
        } else {
            topicContentText = textView.text;
        }
        
        if (self.topicContentTextView.text.length == 0) {
            self.topicContentLabel.text = @"请输入话题内容";
        } else {
            self.topicContentLabel.text = @"";
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.titleTextView) {
        if (textView.text.length == 0) {
            self.titleLabel.text = @"请输入话题标题";
        }
    } else {
        if (textView.text.length == 0) {
            self.topicContentLabel.text = @"请输入话题内容";
        }
    }
}


#pragma mark - action
- (void)cancelButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmButtonClick {
    [self.titleTextView resignFirstResponder];
    [self.topicContentTextView resignFirstResponder];
    
    if (self.titleTextView.text.length > 0 && self.topicContentTextView.text.length > 0) {
        [self joiningTogetherParmeters];
    } else if (self.titleTextView.text.length > 0 && self.topicContentTextView.text.length == 0) {
        [ODProgressHUD showInfoWithStatus:@"请输入话题内容"];
    } else {
        [ODProgressHUD showInfoWithStatus:@"请输入话题标题"];
    }
}
- (void)labelButtonClick:(UIButton *)button {
    NSString *tag_ids;
    if ([button.titleLabel.text isEqualToString:@"情感"]) {
        tag_ids = @"4";
    } else if ([button.titleLabel.text isEqualToString:@"搞笑"]) {
        tag_ids = @"5";
    } else if ([button.titleLabel.text isEqualToString:@"影视"]) {
        tag_ids = @"7";
    } else if ([button.titleLabel.text isEqualToString:@"二次元"]) {
        tag_ids = @"8";
    } else if ([button.titleLabel.text isEqualToString:@"生活"]) {
        tag_ids = @"6";
    } else if ([button.titleLabel.text isEqualToString:@"明星"]) {
        tag_ids = @"9";
    } else if ([button.titleLabel.text isEqualToString:@"爱美"]) {
        tag_ids = @"11";
    } else if ([button.titleLabel.text isEqualToString:@"宠物"]) {
        tag_ids = @"10";
    }
    
    if ([self.labelArray containsObject:tag_ids]) {
        [button setTitleColor:[UIColor colorGreyColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [self.labelArray removeObject:tag_ids];
    } else {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorRedColor];
        [self.labelArray addObject:tag_ids];
    }
}

- (void)addPicButtonClick:(UIButton *)button {
    if (self.imageArray.count < 9) {
        [self.titleTextView resignFirstResponder];
        [self.topicContentTextView resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
        [actionSheet showInView:self.view];
    } else {
        [ODProgressHUD showInfoWithStatus:@"已达图片最大上传数"];
    }
}

- (void)deletePicClick:(UIButton *)button {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [button removeFromSuperview];
        [self.imageArray removeObject:button.currentBackgroundImage];
        [self.strArray removeObjectAtIndex:button.tag - 10010];
        [self reloadImageButtons];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
