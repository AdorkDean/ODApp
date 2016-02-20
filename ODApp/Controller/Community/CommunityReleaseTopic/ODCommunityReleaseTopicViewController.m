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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageArray = [[NSMutableArray alloc]init];
    self.strArray = [[NSMutableArray alloc]init];
    self.labelArray = [NSMutableArray array];
    self.navigationItem.title = @"新话题";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(cancelButtonClick) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"取消"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"确认"];
    [self createScrollView];
    [self createRequest];
    [self createTextView];
    [self createLabels];
    [self createAddPicButton];
}

-(void)cancelButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)confirmButtonClick
{
    [self.titleTextView resignFirstResponder];
    [self.topicContentTextView resignFirstResponder];
    
    if (self.titleTextView.text.length>0&&self.topicContentTextView.text.length>0) {
        [self joiningTogetherParmeters];
        for (NSString *title in self.labelArray) {
            NSLog(@"%@",title);
        }
    }else if (self.titleTextView.text.length>0&&self.topicContentTextView.text.length==0){
        
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入话题内容"];
    }else{

        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入话题标题"];
    }
    
}

#pragma mark - 创建scrollView
-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
    [self.view addSubview:self.scrollView];
}

#pragma mark - 创建textView
-(void)createTextView
{
    //标题
    self.titleTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, 4, kScreenSize.width-8, 53) delegate:self tag:0 font:16 color:@"#ffffff" alpha:1 maskToBounds:YES];
    [self.scrollView addSubview:self.titleTextView];
    self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, 4, kScreenSize.width - 20, 30) text:@"请输入话题标题" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.titleLabel];

    //内容
    self.topicContentTextView = [ODClassMethod creatTextViewWithFrame:CGRectMake(4, CGRectGetMaxY(self.titleTextView.frame)+4, kScreenSize.width-8, 106) delegate:self tag:0 font:16 color:@"#ffffff" alpha:101 maskToBounds:YES];
    [self.scrollView addSubview:self.topicContentTextView];
    self.topicContentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleTextView.frame)+4, kScreenSize.width-20, 30) text:@"请输入话题内容" font:16 alignment:@"left" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    self.topicContentLabel.backgroundColor = [UIColor clearColor];
    self.topicContentLabel.userInteractionEnabled = NO;
    [self.scrollView addSubview:self.topicContentLabel];
}

#pragma mark - UITextViewDelegate
NSString *topicTitleText = @"";
NSString *topicContentText = @"";
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.titleTextView){
        if (textView.text.length > 30){
            textView.text = [textView.text substringToIndex:30];
        }else{
            topicTitleText = textView.text;
        }
        
        if (self.titleTextView.text.length == 0) {
            self.titleLabel.text = @"请输入话题标题";
        }else{
            self.titleLabel.text = @"";
        }
    }else if (textView == self.topicContentTextView){
        if (textView.text.length > 500){
            textView.text = [textView.text substringToIndex:500];
        }else{
            topicContentText = textView.text;
        }
        
        if (self.topicContentTextView.text.length == 0) {
            self.topicContentLabel.text = @"请输入话题内容";
        }else{
            self.topicContentLabel.text = @"";
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.titleTextView) {
        if (textView.text.length == 0) {
            self.titleLabel.text = @"请输入话题标题";
        }
    }else{
        if (textView.text.length == 0) {
            self.topicContentLabel.text = @"请输入话题内容";
        }
    }
}

-(void)createLabels
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(self.topicContentTextView.frame)+10, kScreenSize.width-8, 15)];
    label.text = @"标签选择";
    label.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    [self.scrollView addSubview:label];
    
    NSArray *array = @[@"情感",@"搞笑",@"影视",@"二次元",@"生活",@"明星",@"爱美",@"宠物"];
    CGFloat width = (kScreenSize.width-20)/4;
    for (NSInteger i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(4+(width+4)*(i%4), CGRectGetMaxY(label.frame)+10+(25+4)*(i/4), width, 25);
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#b0b0b0" alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(labelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        button.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        button.tag = 1+i;
        [self.scrollView addSubview:button];
    }
}

-(void)labelButtonClick:(UIButton *)button
{
    NSString *title = button.titleLabel.text;
    if ([self.labelArray containsObject:title]) {
        [button setTitleColor:[UIColor colorWithHexString:@"#b0b0b0" alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        [self.labelArray removeObject:title];
    }else{
        [button setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        [self.labelArray addObject:title];
    }
    
}

#pragma mark - 创建添加图片按钮
-(void)createAddPicButton
{
    CGFloat width = (kScreenSize.width-20)/4;
    self.addPicButton = [ODClassMethod creatButtonWithFrame:CGRectMake(4, CGRectGetMaxY(self.topicContentTextView.frame)+95, width, width) target:self sel:@selector(addPicButtonClick:) tag:0 image:@"发布新话题－默认icon" title:nil font:0];
    self.addPicButton.layer.masksToBounds = YES;
    self.addPicButton.layer.cornerRadius = 5;
    self.addPicButton.layer.borderWidth = 1;
    self.addPicButton.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    [self.scrollView addSubview:self.addPicButton];
}


-(void)addPicButtonClick:(UIButton *)button
{
    if (self.imageArray.count < 9) {
        [self.titleTextView resignFirstResponder];
        [self.topicContentTextView resignFirstResponder];
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

#pragma mark - 上传特效
- (void)createProgressHUDTitle{
 
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.navigationController.view addSubview:self.hud ];
    self.hud.delegate = self;
    self.hud.labelText = @"图片上传中";
}

#pragma mark - 拼接参数
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
    
    __weak typeof (self)weakSelf = self;
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
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
        button.frame = CGRectMake(4 + (width + 4) * (i % 4), CGRectGetMaxY(self.topicContentTextView.frame) + 95 + (4+width) * (i / 4), width, width);
        [self.scrollView addSubview:button];
    }
    [self.addPicButton setFrame:CGRectMake(4 + (width + 4) * (self.imageArray.count % 4), CGRectGetMaxY(self.topicContentTextView.frame) + 95 + (4+width) * (self.imageArray.count / 4), width, width)];
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,262+(self.imageArray.count/4+1)*(width+4));
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
        parameter = @{@"title":self.titleTextView.text,@"content":self.topicContentTextView.text,@"open_id":[ODUserInformation sharedODUserInformation].openID};
    }else{
        parameter = @{@"title":self.titleTextView.text,@"content":self.topicContentTextView.text,@"imgs":imageStr,@"open_id":[ODUserInformation sharedODUserInformation].openID};
    }
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self pushDataWithUrl:kCommunityReleaseBbsUrl parameter:signParameter];
}

#pragma mark - 上传数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        

        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            if (weakSelf.myBlock) {
                weakSelf.myBlock([NSString stringWithFormat:@"refresh"]);
            }
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:1.0f title:@"话题发布成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        if ([responseObject[@"status"]isEqualToString:@"error"]){
            if ([responseObject[@"message"] isEqualToString:@"title not found"]) {
                
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入标题"];
            }else{
            
                [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入内容"];
            }
            
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
