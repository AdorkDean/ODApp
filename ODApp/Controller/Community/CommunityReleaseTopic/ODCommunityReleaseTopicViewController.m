//
//  ODCommunityReleaseTopicViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityReleaseTopicViewController.h"

@interface ODCommunityReleaseTopicViewController ()

@end

@implementation ODCommunityReleaseTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = [[NSMutableArray alloc]init];
    self.strArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self createRequest];
    [self navigationInit];
    [self createTextView];
    [self createAddPicButton];

    
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"新话题" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //取消按钮

    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    //确认按钮
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 35 - 17.5, 16,35, 44) target:self sel:@selector(confirmButtonClick:) tag:0 image:nil title:@"确认" font:16];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];

    [self.headView addSubview:confirmButton];
}

-(void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmButtonClick:(UIButton *)button
{
    if (self.titleTextView.text.length>0&&self.topicContentTextView.text.length>0) {
        [self joiningTogetherParmeters];
    }else if (self.titleTextView.text.length>0&&self.topicContentTextView.text.length==0){
        
        [self createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"请输入话题内容"];
    }else{

        [self createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"请输入话题标题"];
    }
}

#pragma mark - 创建textView
-(void)createTextView
{
    //标题
    self.titleTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 68, kScreenSize.width-8, 53) delegate:self tag:100 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.view addSubview:self.titleTextView];
    self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 68, kScreenSize.width - 20, 30) text:@"请输入话题标题" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.userInteractionEnabled = NO;
    [self.view addSubview:self.titleLabel];


    //内容
    self.topicContentTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, CGRectGetMaxY(self.titleTextView.frame)+4, kScreenSize.width-8, 106) delegate:self tag:0 font:16 color:@"#ffffff" alpha:101 maskToBounds:YES];
    [self.view addSubview:self.topicContentTextView];
    self.topicContentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleTextView.frame)+4, kScreenSize.width-20, 30) text:@"请输入话题内容" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.topicContentLabel.backgroundColor = [UIColor clearColor];
    self.topicContentLabel.userInteractionEnabled = NO;
    [self.view addSubview:self.topicContentLabel];
}

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.titleTextView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 30) {
            return NO;
        }
    }
    
    if (textView == self.topicContentTextView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 500) {
            return NO;
        }
    }
    
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 100) {
        self.titleLabel.text = @"";
    }else{
        self.topicContentLabel.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == 100) {
        if (textView.text.length == 0) {
            self.titleLabel.text = @"请输入话题标题";
        }
    }else{
        if (textView.text.length == 0) {
            self.topicContentLabel.text = @"请输入话题内容";
        }
    }
}

#pragma mark - 创建添加图片按钮
-(void)createAddPicButton
{
    CGFloat width = (kScreenSize.width-20)/4;
    self.addPicButton = [ODClassMethod creatButtonWithFrame:CGRectMake(4, CGRectGetMaxY(self.topicContentTextView.frame)+4, width, width) target:self sel:@selector(addPicButtonClick:) tag:0 image:@"发布新话题－默认icon" title:nil font:0];
    self.addPicButton.layer.masksToBounds = YES;
    self.addPicButton.layer.cornerRadius = 5;
    self.addPicButton.layer.borderWidth = 1;
    self.addPicButton.layer.borderColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1].CGColor;
    [self.view addSubview:self.addPicButton];
}


-(void)addPicButtonClick:(UIButton *)button
{
    if (self.imageArray.count < 9) {
        [self.titleTextView resignFirstResponder];
        [self.topicContentTextView resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];
    }else{
        
        [self createProgressHUDWithAlpha:1.0f withAfterDelay:1.0f title:@"已达图片最大上传数"];
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
                
                [self createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"您当前的照相机不可用"];
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
        
        [self createProgressHUDTitle];
    
    
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

- (void)createProgressHUDTitle{
 
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:self.hud ];
    self.hud.delegate = self;
    self.hud.labelText = @"图片上传中";
    
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
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSString *str = result[@"File"];
            [self.strArray addObject:str];
            [self reloadImageButtons];
            NSLog(@"%@",self.strArray);

        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
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

- (void)reloadImageButtons
{
    NSInteger width = (kScreenSize.width-20)/4;
    for (UIButton *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]] && ![view isEqual:self.addPicButton])
        {
            [view removeFromSuperview];
        }
    }
    
    for (NSInteger i = 0; i < self.imageArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setBackgroundImage:self.imageArray[i] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.tag = 10010+i;
        [button addTarget:self action:@selector(deletePicClick:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(4 + (width + 4) * (i % 4), CGRectGetMaxY(self.topicContentTextView.frame) + 4 + (4+width) * (i / 4), width, width);
        [self.view addSubview:button];
    }
    [self.addPicButton setFrame:CGRectMake(4 + (width + 4) * (self.imageArray.count % 4), CGRectGetMaxY(self.topicContentTextView.frame) + 4 + (4+width) * (self.imageArray.count / 4), width, width)];

    [self.hud hide:NO afterDelay:0];
}



#pragma mark - 删除图片
-(void)deletePicClick:(UIButton *)button
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除图片" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [button removeFromSuperview];
        [self.imageArray removeObject:button.currentBackgroundImage];
        [self.strArray removeObjectAtIndex:button.tag-10010];
        [self reloadImageButtons];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter;
    NSString *imageStr = [[NSString alloc] init];
    for (NSInteger i = 0; i < self.strArray.count; i++) {
        if (i==0) {
            imageStr = self.strArray[i];
        }else{
            NSString *str = self.strArray[i];
            imageStr = [[imageStr stringByAppendingString:@"|"] stringByAppendingString:str];
        }
    }
    if (imageStr.length==0) {
        parameter = @{@"title":self.titleTextView.text,@"content":self.topicContentTextView.text,@"open_id":[ODUserInformation getData].openID};
    }else{
        parameter = @{@"title":self.titleTextView.text,@"content":self.topicContentTextView.text,@"imgs":imageStr,@"open_id":[ODUserInformation getData].openID};
        NSLog(@"%@",parameter);
    }
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self pushDataWithUrl:kCommunityReleaseBbsUrl parameter:signParameter];
}

#pragma mark - 上传数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (self.myBlock) {
                self.myBlock([NSString stringWithFormat:@"refresh"]);
            }
            
            [self createProgressHUDWithAlpha:1.0f withAfterDelay:1.0f title:@"话题发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}




#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    ODTabBarController * tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
