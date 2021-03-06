//
//  ODBazaarReleaseSkillViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarReleaseSkillViewController.h"
#import "NSArray+ODExtension.h"
#import "ODUploadImageModel.h"
#import "AFNetworking.h"
#import "ODHttpTool.h"
#import "UIImageView+WebCache.h"
#import "ODBazaarExchangeSkillDetailModel.h"
#import "ODBazaarReleaseSkillTimeModel.h"

@interface ODBazaarReleaseSkillViewController ()

@property(nonatomic, strong) ODBazaarExchangeSkillDetailModel *model;

@end

@implementation ODBazaarReleaseSkillViewController

#pragma mark - lazyload
- (NSMutableArray *)mArray{
    if (!_mArray){
        _mArray = [[NSMutableArray alloc]init];
    }
    return _mArray;
}

- (NSMutableArray *)strArray{
    if (!_strArray) {
        _strArray = [[NSMutableArray alloc]init];
    }
    return _strArray;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50)];
        _scrollView.backgroundColor = [UIColor backgroundColor];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.type isEqualToString:@"编辑"]) {
        self.navigationItem.title = @"编辑技能";
        [self requestTimeData];
        [self requestDetailData];
    }else{
        self.navigationItem.title = @"发布技能";
    }
    [self createTopView];
    [self createMiddleView];
    [self createPicView];
    [self createBottomView];
    [self createReleaseButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 数据请求
-(void)requestTimeData{
    __weakSelf
    NSDictionary *parameter = @{@"swap_id":self.swap_id};
    [ODHttpTool getWithURL:ODUrlSwapSchedule parameters:parameter modelClass:[ODBazaarReleaseSkillTimeModel class] success:^(id model) {
        weakSelf.editTimeArray = [NSMutableArray arrayWithArray:[model result]];
    } failure:^(NSError *error) {
    }];
}

-(void)requestDetailData{
    __weakSelf
    NSDictionary *parameter = @{@"swap_id":self.swap_id};
    [ODHttpTool getWithURL:ODUrlSwapInfo parameters:parameter modelClass:[ODBazaarExchangeSkillDetailModel class] success:^(id model) {
        weakSelf.model = [model result];
        [weakSelf setControls];
    } failure:^(NSError *error) {
    }];
}

-(void)pushDataWith:(NSString *)str{
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
            [weakSelf reloadImageButtonsWithMarray:weakSelf.mArray];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter isEdit:(BOOL)isEdit{
    __weakSelf
    [ODHttpTool postWithURL:url parameters:parameter modelClass:[NSObject class] success:^(id model) {
        if (isEdit) {
            [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationEditSkill object:nil];
            [weakSelf.navigationController popToViewController:weakSelf.navigationController.childViewControllers[1] animated:YES];
            [ODProgressHUD showInfoWithStatus:@"编辑成功"];
        }else{
            [[NSNotificationCenter defaultCenter ]postNotificationName:ODNotificationReleaseSkill object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [ODProgressHUD showInfoWithStatus:@"创建成功"];
        }
    } failure:^(NSError *error) {
    }];
}

-(void)setControls{
    [self reloadImageButtonsWithMarray:(NSMutableArray *)self.model.imgs_small];
    self.titleTextField.text = self.model.title;
    self.contentTextView.text = self.model.content;
    [self.strArray addObjectsFromArray:[self.model.imgs_small valueForKeyPath:@"md5"]];
    self.priceTextField.text = [NSString stringWithFormat:@"%.2f",self.model.price];
    self.unitTextField.text = self.model.unit;
    self.swap_type = [NSString stringWithFormat:@"%d",self.model.swap_type];
    self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/250",self.model.content.length];
    self.titleCountLabel.text = [NSString stringWithFormat:@"%ld/7",self.model.title.length];
    UIView *view = (UIView *)[self.bottomView viewWithTag:1];
    if ([self.swap_type isEqualToString:@"1"]||[self.swap_type isEqualToString:@"3"]) {
        if ([self.swap_type isEqualToString:@"1"]) {
            UIButton *button = (UIButton *)[view viewWithTag:10];
            [button setBackgroundImage:[UIImage imageNamed:@"button_Home service_Selected"] forState:UIControlStateNormal];
        }else{
            UIButton *button = (UIButton *)[view viewWithTag:11];
            [button setBackgroundImage:[UIImage imageNamed:@"button_Online service_Selected"] forState:UIControlStateNormal];
        }
        self.timeView.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width,236+self.picView.frame.size.height+self.bottomView.frame.size.height+56);
    }else if ([self.swap_type isEqualToString:@"2"]){
        UIButton *button = (UIButton *)[view viewWithTag:12];
        [button setBackgroundImage:[UIImage imageNamed:@"button_Express delivery_Selected"] forState:UIControlStateNormal];
        self.timeView.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width,236+self.picView.frame.size.height+self.bottomView.frame.size.height);
    }
}

-(void)createTopView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width,60)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:topView];
    
    ODUserModel *model =  [[ODUserInformation sharedODUserInformation]getUserCache];
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeSystem];
    headButton.frame = CGRectMake(17.5, 10, 40, 40);
    headButton.layer.masksToBounds = YES;
    headButton.layer.cornerRadius = 20;
    [headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed];
    [topView addSubview:headButton];
    
    UILabel *woQuLabel = [[UILabel alloc]initWithFrame:CGRectMake(67.5, 20, 40, 20)];
    woQuLabel.text = @"我去 ·";
    woQuLabel.textColor = [UIColor blackColor];
    woQuLabel.font = [UIFont systemFontOfSize:13];
    woQuLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:woQuLabel];
    
    self.titleCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-50, 20, 32.5, 20)];
    self.titleCountLabel.text = @"0/7";
    self.titleCountLabel.textAlignment = NSTextAlignmentRight;
    self.titleCountLabel.textColor = [UIColor colorGreyColor];
    self.titleCountLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:self.titleCountLabel ];
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 20, kScreenSize.width-170, 20)];
    self.titleTextField.placeholder = @"如:叫PS、陪看电影、代买早饭等";
    self.titleTextField.font = [UIFont systemFontOfSize:13];
    self.titleTextField.textColor = [UIColor blackColor];
    self.titleTextField.delegate = self;
    [self.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [topView addSubview:self.titleTextField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, kScreenSize.width, 0.5)];
    lineView.backgroundColor = [UIColor lineColor];
    [topView addSubview:lineView];
    
}

-(void)createMiddleView{
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenSize.width,170)];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:middleView];
    
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(12, 6, kScreenSize.width-24, 134)];
    self.contentTextView.textColor = [UIColor blackColor];
    self.contentTextView.font = [UIFont systemFontOfSize:12];
    self.contentTextView.delegate = self;
    [middleView addSubview:self.contentTextView];
    
    self.contentPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 10, kScreenSize.width-35, 20)];
    if ([self.type isEqualToString:@"编辑"]) {
        self.contentPlaceholderLabel.text = @"";
    }else{
        self.contentPlaceholderLabel.text = @"提供技能 , 变身校园大卡";
    }
    self.contentPlaceholderLabel.textColor = [UIColor colorGreyColor];
    self.contentPlaceholderLabel.font = [UIFont systemFontOfSize:12];
    self.contentPlaceholderLabel.userInteractionEnabled = NO;
    [middleView addSubview:self.contentPlaceholderLabel];
    
    self.contentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-100, 140, 82.5, 20)];
    self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/250",self.contentTextView.text.length];
    self.contentCountLabel.textAlignment = NSTextAlignmentRight;
    self.contentCountLabel.textColor = [UIColor colorGreyColor];
    self.contentCountLabel.font = [UIFont systemFontOfSize:12];
    [middleView addSubview:self.contentCountLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 169.5, kScreenSize.width-35, 0.5)];
    lineView.backgroundColor = [UIColor lineColor];
    [middleView addSubview:lineView];
}

-(void)createPicView{
    CGFloat width = (kScreenSize.width-35-30)/4;
    self.picView = [[UIView alloc]initWithFrame:CGRectMake(0, 230, kScreenSize.width, width+20)];
    self.picView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.picView];
    
    self.addPicButton = [[UIButton alloc]initWithFrame:CGRectMake(17.5, 10, width, width)];
    [self.addPicButton setBackgroundImage:[UIImage imageNamed:@"button_Add pictures"] forState:UIControlStateNormal];
    [self.addPicButton addTarget:self action:@selector(addPicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.picView addSubview:self.addPicButton];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.4*width, 0.2*width)];
    imageView.image = [UIImage imageNamed:@"button_Cover label_one"];
    imageView.tag = 9;
    [self.addPicButton addSubview:imageView];
}

- (void)reloadImageButtonsWithMarray:(NSMutableArray *)marray{
    NSInteger width = (kScreenSize.width-35-30)/4;
    for (UIButton *view in self.picView.subviews){
        if ([view isKindOfClass:[UIButton class]] && ![view isEqual:self.addPicButton]){
            [view removeFromSuperview];
        }
    }
    
    __weakSelf
    for (NSInteger i = 0; i < marray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(17.5+(width+10)*(i%4), 10+(10+width)*(i/4), width, width);
        if ([self.type isEqualToString:@"编辑"] && marray!=self.mArray) {
            NSDictionary *dict = marray[i];
            [button sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:[dict valueForKeyPath:@"img_url"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    [weakSelf.mArray addObject:image];
                }
            }];
        }else{
            [button setBackgroundImage:marray[i] forState:UIControlStateNormal];
        }
        button.tag = 100+i;
        [button addTarget:self action:@selector(deletePicClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.picView addSubview:button];
        
        UIImageView *deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width-22.5, 2.5, 20, 20)];
        deleteImageView.image = [UIImage imageNamed:@"button_delete pictures"];
        [button addSubview:deleteImageView];
        
        if (i==0) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0.4*width, 0.2*width)];
            imageView.image = [UIImage imageNamed:@"button_Cover label_one"];
            [button addSubview:imageView];
        }
    }
    UIImageView *imageView = (UIImageView *)[self.addPicButton viewWithTag:9];
    [imageView removeFromSuperview];
    [self.addPicButton setFrame:CGRectMake(17.5+(width+10) * (marray.count%4), 10+(10+width)*(marray.count/4), width, width)];
    [self.picView setFrame:CGRectMake(0, 230, kScreenSize.width, 20+width+(width+10)*(marray.count/4))];
    
    CGFloat height = self.bottomView.frame.size.height;
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.picView.frame)+6, kScreenSize.width, height);
    if ([self.swap_type isEqualToString:@"2"]||self.swap_type == nil) {
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width,236+self.picView.frame.size.height+self.bottomView.frame.size.height);
    }else if ([self.swap_type isEqualToString:@"1"]||[self.swap_type isEqualToString:@"3"]){
        self.timeView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), kScreenSize.width, 50);
        self.timeView.hidden = NO;
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width,236+self.picView.frame.size.height+self.bottomView.frame.size.height+56);
    }
    [ODProgressHUD dismiss];
}

-(void)createBottomView{
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor backgroundColor];
    self.bottomView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.bottomView];
    
    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    priceView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:priceView];
    
    UIImageView *priceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 20, 20)];
    priceImageView.image = [UIImage imageNamed:@"icon_Price"];
    [priceView addSubview:priceImageView];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceImageView.frame)+7.5, 15, 50, 20)];
    priceLabel.text = @"价格:";
    priceLabel.textColor = [UIColor blackColor];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [priceView addSubview:priceLabel];
    
    self.priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+5, 15, kScreenSize.width-100, 20)];
    self.priceTextField.placeholder = @"输入价格";
    self.priceTextField.textColor = [UIColor blackColor];
    self.priceTextField.font = [UIFont systemFontOfSize:14];
    self.priceTextField.delegate = self;
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [priceView addSubview:self.priceTextField];
    
    UIView *unitView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(priceView.frame)+6, kScreenSize.width, 50)];
    unitView.backgroundColor = [UIColor whiteColor];
    [self.bottomView addSubview:unitView];
    
    UIImageView *unitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 20, 20)];
    unitImageView.image = [UIImage imageNamed:@"icon_unit"];
    [unitView addSubview:unitImageView];
    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(unitImageView.frame)+7.5, 15, 50, 20)];
    unitLabel.text = @"单位:";
    unitLabel.textColor = [UIColor blackColor];
    unitLabel.font = [UIFont systemFontOfSize:14];
    unitLabel.textAlignment = NSTextAlignmentCenter;
    [unitView addSubview:unitLabel];
    
    self.unitTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(unitLabel.frame)+5, 15, kScreenSize.width-100, 20)];
    self.unitTextField.placeholder = @"如 每次/每分钟/每小时 等";
    self.unitTextField.textColor = [UIColor blackColor];
    self.unitTextField.font = [UIFont systemFontOfSize:14];
    self.unitTextField.delegate = self;
    [unitView addSubview:self.unitTextField];
    
    CGFloat width = (kScreenSize.width-35-40)/3;
    UIView *serviceView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(unitView.frame)+6, kScreenSize.width, width+55)];
    serviceView.backgroundColor = [UIColor whiteColor];
    serviceView.tag = 1;
    [self.bottomView addSubview:serviceView];
    
    UIImageView *serviceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 20, 20)];
    serviceImageView.image = [UIImage imageNamed:@"icon_service mode"];
    [serviceView addSubview:serviceImageView];
    
    UILabel *serviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(serviceImageView.frame)+7.5, 15, 150, 20)];
    serviceLabel.text = @"服务方式";
    [serviceView addSubview:serviceLabel];
    
    NSArray *array = @[@"button_Home service_default",@"button_Online service_default",@"button_Express delivery_default"];
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(17.5+(width+20)*i, 45, width, width)];
        button.tag = 10+i;
        [button setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.type isEqualToString:@"编辑"]) {
            button.userInteractionEnabled = NO;
        }else{
            button.userInteractionEnabled = YES;
        }
        [serviceView addSubview:button];
    }
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.picView.frame)+6, kScreenSize.width, priceView.frame.size.height+unitView.frame.size.height+serviceView.frame.size.height+18);
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,236+self.picView.frame.size.height+self.bottomView.frame.size.height);
}

-(UIView *)timeView{
    if (!_timeView) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serviceTimeClick:)];
        _timeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), kScreenSize.width, 50)];
        _timeView.backgroundColor = [UIColor whiteColor];
        [_timeView addGestureRecognizer:gesture];
        [self.scrollView addSubview:_timeView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 15, 100, 20)];
        label.text = @"可服务时间";
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14];
        [_timeView addSubview:label];
        
        self.setLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-95, 15, 60, 20)];
        if ([self.type isEqualToString:@"编辑"]&&([self.swap_type isEqualToString:@"1"]||[self.swap_type isEqualToString:@"3"])) {
            self.setLabel.text = @"设置完成";
        }else{
            self.setLabel.text = @"请设置";
        }
        self.setLabel.textColor = [UIColor blackColor];
        self.setLabel.font = [UIFont systemFontOfSize:14];
        self.setLabel.textAlignment = NSTextAlignmentRight;
        [_timeView addSubview:self.setLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width-27.5, 20, 10, 10)];
        imageView.image = [UIImage imageNamed:@"Skills profile page_icon_arrow_upper"];
        [_timeView addSubview:imageView];
    }
    return _timeView;
}

-(void)createReleaseButton{
    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenSize.height-64-50, kScreenSize.width, 50)];
    if ([self.type isEqualToString:@"编辑"]) {
        [releaseButton setTitle:@"编辑" forState:UIControlStateNormal];
    }else{
        [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    }
    [releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [releaseButton setBackgroundColor:[UIColor colorRedColor]];
    [releaseButton addTarget:self action:@selector(releaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
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

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  拍照 : info[UIImagePickerControllerOriginalImage] == nil
 *  本地 : assets-library://asset/asset.JPG?id=AEFCAAE3-1B0D-404A-8FF5-7A49BA02C7B7&ext=JPG
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *sourceType = info[UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
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
        [self.mArray addObject:self.pickedImage];
        [ODProgressHUD showProgressWithStatus:@"正在上传"];
        [self pushDataWith:strData];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)joiningTogetherParmetersWithButton:(UIButton *)button
{
    NSString *imageStr = [[NSString alloc] init];
    for (NSInteger i = 0; i < self.strArray.count; i++) {
        if (i==0) {
            imageStr = self.strArray[i];
        }else{
            NSString *str = self.strArray[i];
            imageStr = [[imageStr stringByAppendingString:@"|"] stringByAppendingString:str];
        }
    }
    if ([button.titleLabel.text isEqualToString:@"编辑"]) {
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        
        
        if (self.timeArray.count) {
            
            parameter[@"swap_id"] = self.swap_id;
            parameter[@"title"] = self.titleTextField.text;
            parameter[@"content"] = self.contentTextView.text;
            parameter[@"swap_type"] = self.swap_type;
            parameter[@"price"] = self.priceTextField.text;
            parameter[@"unit"] = self.unitTextField.text;            
            parameter[@"imgs"] = imageStr;
            parameter[@"schedule"] = [self.timeArray od_desc];
        }else{
            NSMutableArray *array = [ODBazaarReleaseSkillTimeModel mj_keyValuesArrayWithObjectArray:self.editTimeArray];
            
            parameter[@"swap_id"] = self.swap_id;
            parameter[@"title"] = self.titleTextField.text;
            parameter[@"content"] = self.contentTextView.text;
            parameter[@"swap_type"] = self.swap_type;
            parameter[@"price"] = self.priceTextField.text;
            parameter[@"unit"] = self.unitTextField.text;
            parameter[@"imgs"] = imageStr;
            parameter[@"schedule"] = [array od_desc];
        }
        [self pushDataWithUrl:ODUrlSwapEdit parameter:parameter isEdit:YES];
    }else{
        NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
        if ([self.swap_type isEqualToString:@"1"]||[self.swap_type isEqualToString:@"3"]) {
            
            parameter[@"title"] = self.titleTextField.text;
            parameter[@"content"] = self.contentTextView.text;
            parameter[@"swap_type"] = self.swap_type;
            parameter[@"price"] = self.priceTextField.text;
            parameter[@"unit"] = self.unitTextField.text;
            parameter[@"schedule"] = [self.timeArray od_desc];
            parameter[@"imgs"] = imageStr;
            
        }else if ([self.swap_type isEqualToString:@"2"]){
            
            parameter[@"title"] = self.titleTextField.text;
            parameter[@"content"] = self.contentTextView.text;
            parameter[@"swap_type"] = self.swap_type;
            parameter[@"price"] = self.priceTextField.text;
            parameter[@"unit"] = self.unitTextField.text;
            parameter[@"schedule"] = @"";
            parameter[@"imgs"] = imageStr;
        }
        [self pushDataWithUrl:ODUrlSwapCreate parameter:parameter isEdit:NO];
    }
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.titleTextField) {
        self.titleCountLabel.text = [NSString stringWithFormat:@"%ld/7",textField.text.length];
        if (textField.text.length>7) {
            self.titleCountLabel.textColor = [UIColor colorRedColor];
        } else {
            self.titleCountLabel.textColor = [UIColor colorGreyColor];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.priceTextField) {
        if ([textField.text rangeOfString:@"."].location == NSNotFound) {
            self.isHaveDian = NO;
        }
        if ([string length] > 0) {
            unichar single = [string characterAtIndex:0];
            if ((single >= '0' && single <= '9') || single == '.') {
                if([textField.text length] == 0){
                    if(single == '.') {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if (single == '.') {
                    if(!self.isHaveDian){
                        self.isHaveDian = YES;
                        return YES;
                    }else{
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }else{
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
}

#pragma mark - UITextViewDelegate
NSString *skillContentText = @"";
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 250){
        textView.text = [textView.text substringToIndex:250];
    }else{
        skillContentText = textView.text;
    }
    
    if (textView.text.length == 0) {
        self.contentPlaceholderLabel.text = @"提供技能 , 变身校园大卡";
        self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/250",textView.text.length];
    }else{
        self.contentPlaceholderLabel.text = @"";
        self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/250",textView.text.length];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.contentPlaceholderLabel.text = @"提供技能 , 变身校园大卡";
    }
}

#pragma amrk - action
-(void)addPicButtonClick:(UIButton *)button
{
    if (self.mArray.count<5) {
        [self.titleTextField resignFirstResponder];
        [self.contentTextView resignFirstResponder];
        [self.priceTextField resignFirstResponder];
        [self.unitTextField resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];
    }else{
        [ODProgressHUD showInfoWithStatus:@"已达图片最大上传数"];
    }
}

-(void)deletePicClick:(UIButton *)button
{
    NSLogFunc
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weakSelf;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [button removeFromSuperview];
        [weakSelf.mArray removeObject:button.currentBackgroundImage];
        [weakSelf.strArray removeObjectAtIndex:button.tag-100];
        [weakSelf reloadImageButtonsWithMarray:weakSelf.mArray];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)serviceButtonClick:(UIButton *)button{
    
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.unitTextField resignFirstResponder];
    
    NSInteger width = (kScreenSize.width-35-30)/4;
    NSArray *selectedArray = @[@"button_Home service_Selected",@"button_Online service_Selected",@"button_Express delivery_Selected"];
    NSArray *array = @[@"button_Home service_default",@"button_Online service_default",@"button_Express delivery_default"];
    UIView *view = (UIView *)[self.bottomView viewWithTag:1];
    
    if (self.selectedButton == nil) {
        self.selectedButton = button;
        [button setBackgroundImage:[UIImage imageNamed:selectedArray[button.tag-10]] forState:UIControlStateNormal];
    }else if (self.selectedButton == button){
        
    }else if (self.selectedButton != button){
        for (NSInteger i = 0; i < selectedArray.count; i++) {
            UIButton *btn = (UIButton *)[view viewWithTag:10+i];
            if (btn == button) {
                [button setBackgroundImage:[UIImage imageNamed:selectedArray[button.tag-10]] forState:UIControlStateNormal];
                self.selectedButton = button;
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            }
        }
    }
    
    if (button.tag == 10 || button.tag==11) {
        if (button.tag == 10) {
            self.swap_type = @"1";
        }else{
            self.swap_type = @"3";
        }
        self.timeView.hidden = NO;
        self.timeView.frame = CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), kScreenSize.width, 50);
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width,236+self.picView.frame.size.height+self.bottomView.frame.size.height+56);
        if (self.mArray.count >=4) {
            [self.scrollView setContentOffset:CGPointMake(0, 59+50+width+10) animated:YES];
        }else{
            [self.scrollView setContentOffset:CGPointMake(0, 59+50) animated:YES];
        }
    }
    if (button.tag == 12) {
        self.swap_type = @"2";
        self.timeView.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width,236+self.picView.frame.size.height+self.bottomView.frame.size.height);
    }
}

-(void)serviceTimeClick:(UITapGestureRecognizer *)gesture{
    ODBazaarReleaseSkillTimeViewController *timeController = [[ODBazaarReleaseSkillTimeViewController alloc]init];
    timeController.myBlock = ^(NSMutableArray *array){
        self.timeArray = [[NSMutableArray alloc]init];
        self.timeArray = array;
        self.setLabel.text = @"设置完成";
    };
    timeController.swap_id = self.swap_id;
    timeController.dataArray = self.timeArray;
    [self.navigationController pushViewController:timeController animated:YES];
}

-(void)releaseButtonClick:(UIButton *)button{
    if (self.titleTextField.text.length > 0 &&
        self.titleTextField.text.length < 8 &&
        self.contentTextView.text.length > 0 &&
        self.priceTextField.text.length > 0 &&
        self.unitTextField.text.length < 4 &&
        self.unitTextField.text.length > 0 &&
        self.swap_type != nil &&
        self.mArray.count <= 5 && self.mArray.count >= 3) {
        [self joiningTogetherParmetersWithButton:button];
    }else{
        if (self.titleTextField.text.length==0) {
            [ODProgressHUD showInfoWithStatus:@"请输入标题"];
        }else if (self.titleTextField.text.length>7){
            [ODProgressHUD showInfoWithStatus:@"标题不能超过七个字"];
        }else if (self.contentTextView.text.length==0){
            [ODProgressHUD showInfoWithStatus:@"请输入内容"];
        }else if (self.priceTextField.text.length==0){
            [ODProgressHUD showInfoWithStatus:@"不要钱了吗"];
        }else if (self.unitTextField.text.length==0){
            [ODProgressHUD showInfoWithStatus:@"认真填写个单位吧"];
        }else if (self.unitTextField.text.length>3){
            [ODProgressHUD showInfoWithStatus:@"单位不能超过三个字"];
        }else if (self.swap_type == nil){
            [ODProgressHUD showInfoWithStatus:@"请选择你的服务方式"];
        }else if (([self.swap_type isEqualToString:@"1"]||[self.swap_type isEqualToString:@"3"])&&self.timeArray.count==0&&[button.titleLabel.text isEqualToString:@"发布"]){
            [ODProgressHUD showInfoWithStatus:@"请设置时间"];
        }else if (self.mArray.count<3||self.mArray.count>5){
            [ODProgressHUD showInfoWithStatus:@"图需3-5张"];
        }
    }
}

@end
