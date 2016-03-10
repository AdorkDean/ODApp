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

@interface ODBazaarReleaseSkillViewController ()

@end

@implementation ODBazaarReleaseSkillViewController

@synthesize imageArray = _imageArray;

- (void)setImageArray:(NSArray *)imageArray
{
    NSLogFunc
    _imageArray = imageArray;
    for (NSString *imageStr in _imageArray){
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL OD_URLWithString:imageStr]]];
        [self.mArray addObject:image];
    }
}

- (NSMutableArray *)mArray{
    if (!_mArray)
    {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLogFunc
    if ([self.type isEqualToString:@"编辑"]) {
        [self joiningTogetherTimeParmeters];
        self.navigationItem.title = @"编辑技能";
    }else{
        self.navigationItem.title = @"发布技能";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getUserInfo];
    [self createScrollView];
    [self createMiddleView];
    [self createPicView];
    [self createBottomView];
    [self createReleaseButton];
    [self reloadImageButtons];
}

-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
}

-(void)getUserInfo
{
     __weakSelf
    [ODHttpTool getWithURL:ODUrlUserInfo parameters:@{} modelClass:[ODUserModel class] success:^(id model)
    {
        ODUserModel *user = [model result];
        weakSelf.avatar = user.avatar;
        [weakSelf createTopView];
    }
                   failure:^(NSError *error)
    {
        
    }];
}

-(void)createTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width,60)];
    topView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:topView];
    
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeSystem];
    headButton.frame = CGRectMake(17.5, 10, 40, 40);
    headButton.layer.masksToBounds = YES;
    headButton.layer.cornerRadius = 20;
    [headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:self.avatar] forState:UIControlStateNormal];
    [headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:headButton];
    
    UILabel *woQuLabel = [[UILabel alloc]initWithFrame:CGRectMake(67.5, 20, 40, 20)];
    woQuLabel.text = @"我去 ·";
    woQuLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    woQuLabel.font = [UIFont systemFontOfSize:13];
    woQuLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:woQuLabel];
    
    self.titleCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-50, 20, 32.5, 20)];
    self.titleCountLabel.text = [NSString stringWithFormat:@"%ld/7",self.skillTitle.length];
    self.titleCountLabel.textAlignment = NSTextAlignmentRight;
    self.titleCountLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    self.titleCountLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:self.titleCountLabel ];
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 20, kScreenSize.width-170, 20)];
    self.titleTextField.placeholder = @"如:叫PS、陪看电影、代买早饭等";
    self.titleTextField.font = [UIFont systemFontOfSize:13];
    self.titleTextField.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.titleTextField.delegate = self;
    [self.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.titleTextField.text = self.skillTitle;
    [topView addSubview:self.titleTextField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, kScreenSize.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [topView addSubview:lineView];
}

-(void)headButtonClick:(UIButton *)button
{
    
}

-(void)createMiddleView
{
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenSize.width,170)];
    middleView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:middleView];
    
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(12, 6, kScreenSize.width-24, 134)];
    self.contentTextView.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.contentTextView.font = [UIFont systemFontOfSize:12];
    self.contentTextView.text = self.content;
    self.contentTextView.delegate = self;
    [middleView addSubview:self.contentTextView];
    
    self.contentPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 10, kScreenSize.width-35, 20)];
    if (self.content) {
        self.contentPlaceholderLabel.text = @"";
    }else{
       self.contentPlaceholderLabel.text = @"提供技能 , 变身校园大卡";
    }
    self.contentPlaceholderLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    self.contentPlaceholderLabel.font = [UIFont systemFontOfSize:12];
    self.contentPlaceholderLabel.userInteractionEnabled = NO;
    [middleView addSubview:self.contentPlaceholderLabel];
   
    self.contentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-100, 140, 82.5, 20)];
    self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/250",self.contentTextView.text.length];
    self.contentCountLabel.textAlignment = NSTextAlignmentRight;
    self.contentCountLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    self.contentCountLabel.font = [UIFont systemFontOfSize:12];
    [middleView addSubview:self.contentCountLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 169.5, kScreenSize.width-35, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [middleView addSubview:lineView];
    
}

-(void)createPicView
{
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
//        [self createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:@"已达图片最大上传数"];
        [ODProgressHUD showInfoWithStatus:@"已达图片最大上传数"];
    }
    
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
            else {
                
//                [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"您当前的照相机不可用"];
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

#pragma mark - 自己处理cancel
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击确定之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *sourceType = info[UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        self.pickedImage = info[UIImagePickerControllerOriginalImage];
        
        [ODProgressHUD showProgressWithStatus:@"正在上传"];
        
        //图片转化为data
        NSData *imageData;
        self.pickedImage = [self scaleImage:self.pickedImage];;
        if (UIImagePNGRepresentation(self.pickedImage)==nil) {
            imageData = UIImageJPEGRepresentation(self.pickedImage,0.3);
        }else{
            imageData = UIImagePNGRepresentation(self.pickedImage);
        }
        NSString *str = @"data:image/jpeg;base64,";
        NSString *strData = [str stringByAppendingString:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        [self.mArray addObject:self.pickedImage];
        [self createParameter:strData];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


//压缩尺寸
-(UIImage *) scaleImage:(UIImage *)image
{
    CGSize size = CGSizeMake(image.size.width * 0.3, image.size.height * 0.3);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform,0.3, 0.3);
    CGContextConcatCTM(context, transform);
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

-(void)createParameter:(NSString *)str
{
    // 拼接参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"File"] = str;
    __weakSelf
    // 上传图片
    [ODHttpTool postWithURL:ODUrlOtherBase64Upload parameters:params modelClass:[ODUploadImageModel class] success:^(id model) {
        // 取出模型
        ODUploadImageModel *uploadModel = [model result];
        [weakSelf.strArray addObject:uploadModel.File];
        [weakSelf reloadImageButtons];
    } failure:^(NSError *error) {
    }];
}

- (void)reloadImageButtons
{
    NSInteger width = (kScreenSize.width-35-30)/4;
    for (UIButton *view in self.picView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]] && ![view isEqual:self.addPicButton])
        {
            [view removeFromSuperview];
        }
    }
    NSLogFunc
    for (NSInteger i = 0; i < self.mArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:self.mArray[i] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(deletePicClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(17.5+(width+10)*(i%4), 10+(10+width)*(i/4), width, width);
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
    [self.addPicButton setFrame:CGRectMake(17.5+(width+10) * (self.mArray.count%4), 10+(10+width)*(self.mArray.count/4), width, width)];
    [self.picView setFrame:CGRectMake(0, 230, kScreenSize.width, 20+width+(width+10)*(self.mArray.count/4))];
    
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

#pragma mark - 删除图片
-(void)deletePicClick:(UIButton *)button
{
    NSLogFunc
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weakSelf;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [button removeFromSuperview];
        [weakSelf.mArray removeObject:button.currentBackgroundImage];
        [weakSelf.strArray removeObjectAtIndex:button.tag-100];
        [weakSelf reloadImageButtons];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)createBottomView
{
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    self.bottomView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.bottomView];
    
    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 50)];
    priceView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.bottomView addSubview:priceView];
    
    UIImageView *priceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 20, 20)];
    priceImageView.image = [UIImage imageNamed:@"icon_Price"];
    [priceView addSubview:priceImageView];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceImageView.frame)+7.5, 15, 50, 20)];
    priceLabel.text = @"价格:";
    priceLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    [priceView addSubview:priceLabel];
    
    self.priceTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame)+5, 15, kScreenSize.width-100, 20)];
    self.priceTextField.placeholder = @"输入价格";
    self.priceTextField.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.priceTextField.font = [UIFont systemFontOfSize:14];
    self.priceTextField.text = self.price;
    self.priceTextField.delegate = self;
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    [priceView addSubview:self.priceTextField];
    
    UIView *unitView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(priceView.frame)+6, kScreenSize.width, 50)];
    unitView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.bottomView addSubview:unitView];
    
    UIImageView *unitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 20, 20)];
    unitImageView.image = [UIImage imageNamed:@"icon_unit"];
    [unitView addSubview:unitImageView];
    
    UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(unitImageView.frame)+7.5, 15, 50, 20)];
    unitLabel.text = @"单位:";
    unitLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    unitLabel.font = [UIFont systemFontOfSize:14];
    unitLabel.textAlignment = NSTextAlignmentCenter;
    [unitView addSubview:unitLabel];
    
    self.unitTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(unitLabel.frame)+5, 15, kScreenSize.width-100, 20)];
    self.unitTextField.placeholder = @"如 每次/每分钟/每小时 等";
    self.unitTextField.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.unitTextField.font = [UIFont systemFontOfSize:14];
    self.unitTextField.text = self.unit;
    self.unitTextField.delegate = self;
    [unitView addSubview:self.unitTextField];
    
    CGFloat width = (kScreenSize.width-35-40)/3;
    UIView *serviceView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(unitView.frame)+6, kScreenSize.width, width+55)];
    serviceView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
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

-(void)serviceButtonClick:(UIButton *)button
{
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

-(UIView *)timeView
{
    if (!_timeView) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(serviceTimeClick:)];
        _timeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomView.frame), kScreenSize.width, 50)];
        _timeView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [_timeView addGestureRecognizer:gesture];
        [self.scrollView addSubview:_timeView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 15, 100, 20)];
        label.text = @"可服务时间";
        label.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        [_timeView addSubview:label];
        
        self.setLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenSize.width-95, 15, 60, 20)];
        
        if ([self.type isEqualToString:@"编辑"]&&([self.swap_type isEqualToString:@"1"]||[self.swap_type isEqualToString:@"3"])) {
            self.setLabel.text = @"设置完成";
        }else{
            self.setLabel.text = @"请设置";
        }
        self.setLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
        self.setLabel.font = [UIFont systemFontOfSize:14];
        self.setLabel.textAlignment = NSTextAlignmentRight;
        [_timeView addSubview:self.setLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width-27.5, 20, 10, 10)];
        imageView.image = [UIImage imageNamed:@"Skills profile page_icon_arrow_upper"];
        [_timeView addSubview:imageView];
    }
    return _timeView;
}

-(void)serviceTimeClick:(UITapGestureRecognizer *)gesture
{
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

-(void)createReleaseButton
{
    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenSize.height-64-50, kScreenSize.width, 50)];
    if ([self.type isEqualToString:@"编辑"]) {
        [releaseButton setTitle:@"编辑" forState:UIControlStateNormal];
    }else{
        [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    }
    [releaseButton setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
    [releaseButton setBackgroundColor:[UIColor colorWithHexString:@"#ff6666" alpha:1]];
    [releaseButton addTarget:self action:@selector(releaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
}

-(void)releaseButtonClick:(UIButton *)button
{
    if (self.titleTextField.text.length>0&&self.titleTextField.text.length<8&&self.contentTextView.text.length>0&&self.priceTextField.text.length>0&&self.unitTextField.text.length<4&&self.unitTextField.text.length>0&&self.swap_type != nil&&self.mArray.count<=5&&self.mArray.count>=3) {
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
        
        NSDictionary *parameter;
        if (self.timeArray.count) {
            parameter = @{@"swap_id":self.swap_id,@"title":self.titleTextField.text,@"content":self.contentTextView.text,@"swap_type":self.swap_type,@"price":self.priceTextField.text,@"unit":self.unitTextField.text,@"schedule":[self.timeArray desc],@"imgs":imageStr,@"city_id":[NSString stringWithFormat:@"%@",[ODUserInformation sharedODUserInformation].cityID],@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
        }else{
            parameter = @{@"swap_id":self.swap_id,@"title":self.titleTextField.text,@"content":self.contentTextView.text,@"swap_type":self.swap_type,@"price":self.priceTextField.text,@"unit":self.unitTextField.text,@"schedule":[self.editTimeArray desc],@"imgs":imageStr,@"city_id":[NSString stringWithFormat:@"%@",[ODUserInformation sharedODUserInformation].cityID],@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
        }
        [self pushDataWithUrl:ODUrlSwapEdit parameter:parameter isEdit:YES];
    }else{
        
        NSDictionary *parameter;
        if ([self.swap_type isEqualToString:@"1"]||[self.swap_type isEqualToString:@"3"]) {
            parameter = @{@"title":self.titleTextField.text,@"content":self.contentTextView.text,@"swap_type":self.swap_type,@"price":self.priceTextField.text,@"unit":self.unitTextField.text,@"schedule":[self.timeArray desc],@"imgs":imageStr,@"city_id":[NSString stringWithFormat:@"%@",[ODUserInformation sharedODUserInformation].cityID],@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
        }else if ([self.swap_type isEqualToString:@"2"]){
            parameter = @{@"title":self.titleTextField.text,@"content":self.contentTextView.text,@"swap_type":self.swap_type,@"price":self.priceTextField.text,@"unit":self.unitTextField.text,@"schedule":@"",@"imgs":imageStr,@"city_id":[NSString stringWithFormat:@"%@",[ODUserInformation sharedODUserInformation].cityID],@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
        }
        [self pushDataWithUrl:ODUrlSwapCreate parameter:parameter isEdit:NO];
    }

}

-(void)joiningTogetherTimeParmeters
{
    __weakSelf
    NSDictionary *parameter = @{@"swap_id":self.swap_id};
    [ODHttpTool getWithURL:ODUrlSwapSchedule parameters:parameter modelClass:[NSObject class] success:^(id model) {
        weakSelf.editTimeArray = [NSMutableArray arrayWithArray:model[@"result"]];
    } failure:^(NSError *error) {
        
    }];
}


-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter isEdit:(BOOL)isEdit
{
    __weakSelf
    [ODHttpTool postWithURL:url parameters:parameter modelClass:[NSObject class] success:^(id model) {
        
        if (isEdit) {
            [[NSNotificationCenter defaultCenter]postNotificationName:ODNotificationEditSkill object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [ODProgressHUD showInfoWithStatus:@"编辑成功"];
        }else{
            [[NSNotificationCenter defaultCenter ]postNotificationName:ODNotificationReleaseSkill object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [ODProgressHUD showInfoWithStatus:@"创建成功"];
        }
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - UITextFieldDelegate
-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.titleTextField) {
        self.titleCountLabel.text = [NSString stringWithFormat:@"%ld/7",textField.text.length];
        if (textField.text.length>7) {
            self.titleCountLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1.0f];
        } else {
            self.titleCountLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1.0f];
        }
        
    }
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
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
        self.contentPlaceholderLabel.text = @"请输入任务标题";
        self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/250",textView.text.length];
    }else{
        self.contentPlaceholderLabel.text = @"";
        self.contentCountLabel.text = [NSString stringWithFormat:@"%ld/250",textView.text.length];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
   if (textView.text.length == 0) {
       self.contentPlaceholderLabel.text = @"请输入任务标题";
   }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

#pragma mark - UIScrollViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
