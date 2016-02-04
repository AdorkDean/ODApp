//
//  ODBazaarReleaseSkillViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarReleaseSkillViewController.h"

@interface ODBazaarReleaseSkillViewController ()

@end

@implementation ODBazaarReleaseSkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getUserInfo];
    [self createScrollView];
    [self createMiddleView];
    [self createPicView];
    [self createBottomView];
    [self createReleaseButton];
    self.navigationItem.title = @"发布技能";
}

-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollView];
}

-(void)getUserInfo
{
    self.manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameter = @{@"open_id":[ODUserInformation sharedODUserInformation].openID};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.manager GET:kOthersInformationUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            NSDictionary *dict = responseObject[@"result"];
            weakSelf.avatar = dict[@"avatar"];
            [weakSelf createTopView];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
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
    self.titleCountLabel.text = [NSString stringWithFormat:@"%ld/7",self.titleTextField.text.length];
    self.titleCountLabel.textAlignment = NSTextAlignmentRight;
    self.titleCountLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    self.titleCountLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:self.titleCountLabel ];
    
    self.titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(120, 20, kScreenSize.width-170, 20)];
    self.titleTextField.placeholder = @"代买早饭";
    self.titleTextField.font = [UIFont systemFontOfSize:13];
    self.titleTextField.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.titleTextField.delegate = self;
    [self.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [topView addSubview:self.titleTextField];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kScreenSize.width, 1)];
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
    self.contentTextView.delegate = self;
    [middleView addSubview:self.contentTextView];
    
    self.contentPlaceholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(17.5, 10, kScreenSize.width-35, 20)];
    self.contentPlaceholderLabel.text = @"提供技能 , 变身校园大卡";
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
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(17.5, 169, kScreenSize.width-35, 1)];
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
    
    self.imageArray = [[NSMutableArray alloc]init];
    self.strArray = [[NSMutableArray alloc]init];
}

-(void)addPicButtonClick:(UIButton *)button
{
    if (self.imageArray.count<5) {
        [self.titleTextField resignFirstResponder];
        [self.contentTextView resignFirstResponder];
        [self.priceTextField resignFirstResponder];
        [self.unitTextField resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];
    }else{
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:@"已达图片最大上传数"];
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
                
                [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"您当前的照相机不可用"];
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
        
//        [self createProgressHUDTitle];
        
        
        //图片转化为data
        NSData *imageData;
        self.pickedImage = [self scaleImage:self.pickedImage];;
        if (UIImagePNGRepresentation(self.pickedImage)==nil) {
            imageData = UIImageJPEGRepresentation(self.pickedImage,0.4);
        }else{
            imageData = UIImagePNGRepresentation(self.pickedImage);
        }
        NSString *str = @"data:image/jpeg;base64,";
        NSString *strData = [str stringByAppendingString:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        [self.imageArray addObject:self.pickedImage];
        [self createParameter:strData];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//压缩尺寸
-(UIImage *) scaleImage:(UIImage *)image
{
    CGSize size = CGSizeMake(image.size.width * 0.4, image.size.height * 0.4);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform,0.4, 0.4);
    CGContextConcatCTM(context, transform);
    [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

-(void)createParameter:(NSString *)str
{
    NSDictionary *parameter = @{@"File":str};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self pushImageWithUrl:kPushImageUrl parameter:signParameter];
    
}

//上传图片返回数据
-(void)pushImageWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    __weakSelf
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSString *str = result[@"File"];
            [weakSelf.strArray addObject:str];
            [weakSelf reloadImageButtons];
            NSLog(@"%@",weakSelf.strArray);
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error");
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
    
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setBackgroundImage:self.imageArray[i] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(deletePicClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(17.5+(width+10)*(i%4), 10+(10+width)*(i/4), width, width);
        [self.picView addSubview:button];
        
        UIImageView *deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(width-22.5, 2.5, 20, 20)];
        deleteImageView.image = [UIImage imageNamed:@"button_delete pictures"];
        [button addSubview:deleteImageView];
    }
    [self.addPicButton setFrame:CGRectMake(17.5+(width+10) * (self.imageArray.count%4), 10+(10+width)*(self.imageArray.count/4), width, width)];
    [self.picView setFrame:CGRectMake(0, 230, kScreenSize.width, 20+width+(width+10)*(self.imageArray.count/4))];
    if (self.imageArray.count>=4) {
        [self.bottomView removeFromSuperview];
        [self createBottomView];
    }
}

#pragma mark - 删除图片
-(void)deletePicClick:(UIButton *)button
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weakSelf;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [button removeFromSuperview];
        [weakSelf.imageArray removeObject:button.currentBackgroundImage];
        [weakSelf.strArray removeObjectAtIndex:button.tag-100];
        [weakSelf reloadImageButtons];
        [weakSelf.bottomView removeFromSuperview];
        [weakSelf createBottomView];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)createBottomView
{
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
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
    self.priceTextField.delegate = self;
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
        [serviceView addSubview:button];
    }
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.picView.frame)+6, kScreenSize.width, priceView.frame.size.height+unitView.frame.size.height+serviceView.frame.size.height+18);
    
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,236+self.picView.frame.size.height+self.bottomView.frame.size.height);
}

-(void)serviceButtonClick:(UIButton *)button
{
    NSArray *selectedArray = @[@"button_Home service_Selected",@"button_Online service_Selected",@"button_Express delivery_Selected"];
    NSArray *array = @[@"button_Home service_default",@"button_Online service_default",@"button_Express delivery_default"];
    if (self.selectedButton == nil) {
        self.selectedButton = button;
        [button setBackgroundImage:[UIImage imageNamed:selectedArray[button.tag-10]] forState:UIControlStateNormal];
    }else if (self.selectedButton == button){
        
    }else if (self.selectedButton != button){
        for (NSInteger i = 0; i < selectedArray.count; i++) {
            UIView *view = (UIView *)[self.bottomView viewWithTag:1];
            UIButton *btn = (UIButton *)[view viewWithTag:10+i];
            if (btn == button) {
                [button setBackgroundImage:[UIImage imageNamed:selectedArray[button.tag-10]] forState:UIControlStateNormal];
                self.selectedButton = button;
            }else{
                [btn setBackgroundImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
            }
        }
    }
}

-(void)createReleaseButton
{
    UIButton *releaseButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenSize.height-64-50, kScreenSize.width, 50)];
    [releaseButton setTitle:@"发布" forState:UIControlStateNormal];
    [releaseButton setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
    [releaseButton setBackgroundColor:[UIColor colorWithHexString:@"#ff6666" alpha:1]];
    [releaseButton addTarget:self action:@selector(releaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:releaseButton];
}

-(void)releaseButtonClick:(UIButton *)button
{
    
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.titleTextField) {
        if (textField.text.length>7) {
            textField.text = [textField.text substringToIndex:7];
        }
        self.titleCountLabel.text = [NSString stringWithFormat:@"%ld/7",textField.text.length];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
