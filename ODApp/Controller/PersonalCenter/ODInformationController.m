//
//  ODInformationController.m
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODInformationController.h"
#import "ODInformationView.h"
#import "ODUserSignatureController.h"
#import "ODUserNickNameController.h"
#import "ODUserGenderController.h"
#import "ODBindingMobileController.h"
#import "ODTabBarController.h"
#import "ODUserModel.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "UIImageView+WebCache.h"
#import "ODChangePassWordController.h"
@interface ODInformationController ()<UITableViewDataSource , UITableViewDelegate ,UIImagePickerControllerDelegate , UIActionSheetDelegate , UINavigationControllerDelegate>

@property (nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) ODInformationView *informationView;
@property (nonatomic , strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic , strong) AFHTTPRequestOperationManager *managers;
@property (nonatomic , strong) UIImage *image;
@property (nonatomic , strong) UIImagePickerController *imagePicker;
@property (nonatomic , copy) NSString *imgsString;

@end

@implementation ODInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
 
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self getData];
    [self navigationInit];
    
    
}

#pragma mark - lifeCycle
-(void)viewWillAppear:(BOOL)animated
{
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1.0;
}

#pragma mark - 请求数据
- (void)getData
{
    [self.dataArray removeAllObjects];
    
    
    
    
    
    self.manager = [AFHTTPRequestOperationManager manager];
    NSString *openId = [ODUserInformation getData].openID;
    
    
    NSDictionary *parameters = @{@"open_id":openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/user/info";
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSMutableDictionary *dic = responseObject[@"result"];
        ODUserModel *model = [[ODUserModel alloc] initWithDict:dic];
        
        
        
        [self.dataArray addObject:model];
        
        [self createTableView];
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
}



#pragma mark - 初始化
-(void)navigationInit
{
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
  
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 80) / 2, 28, 80, 20) text:@"个人中心" font:17 alignment:@"center" color:@"#000000" alpha:1];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    
   
<<<<<<< HEAD
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(-10, 28,90, 20) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:17];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
=======
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [confirmButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
>>>>>>> ab9b6b0ccedcaaee159908d6427c4c8f0fa3d1a6
    [self.headView addSubview:confirmButton];
    
}

- (void)createTableView
{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height - 64) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.userInteractionEnabled = YES;
    
    
    
    self.informationView = [ODInformationView getView];
    self.informationView.userInteractionEnabled = YES;
    self.informationView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height + 20);
    
    ODUserModel *model = self.dataArray[0];
    
    [self.informationView.userImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    UITapGestureRecognizer *pictMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picAction)];
    [self.informationView.userImageView addGestureRecognizer:pictMap];
    
    
    
    self.informationView.userImageView.layer.masksToBounds = YES;
    self.informationView.userImageView.layer.cornerRadius = 45;
    self.informationView.userImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.informationView.userImageView.layer.borderWidth = 1;

    
    if ([model.sign isEqualToString:@""]) {
        self.informationView.signatureLabel.text = @"未设置签名";
    }else{
        
        
        self.informationView.signatureLabel.text = model.sign;
        
    }

    UITapGestureRecognizer *signatureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signatureAction)];
    [self.informationView.signatureImageView addGestureRecognizer:signatureTap];

    
    
    if ([model.nick isEqualToString:@""]) {
        self.informationView.nickNameLabel.text = @"未设置昵称";
    }else{
        self.informationView.nickNameLabel.text = model.nick;
        
    }

    UITapGestureRecognizer *nickNameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nickNameAction)];
    [self.informationView.nickNameImageView addGestureRecognizer:nickNameTap];
    
    NSString *gender = [NSString stringWithFormat:@"%ld" , (long)model.gender];

    
    if ([gender isEqualToString:@"1"]) {
        self.informationView.genderLabel.text = @"男";
    }else if ([gender isEqualToString:@"2"]){
        self.informationView.genderLabel.text = @"女";
        
    }

    
    UITapGestureRecognizer *genderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderAction)];
    [self.informationView.genderImageView addGestureRecognizer:genderTap];
    
    
    self.informationView.phoneLabel.text = model.mobile;
    
//    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneAction)];
//    [self.informationView.phoneImageView addGestureRecognizer:phoneTap];
//    
    
    UITapGestureRecognizer *passWordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passWordAction)];
    [self.informationView.passWordImageView addGestureRecognizer:passWordTap];

    [self.informationView.codeImageView sd_setImageWithURL:[NSURL URLWithString:model.qrcode]];
    
    
    
    self.tableView.tableHeaderView = self.informationView;
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - 点击事件

-(void)fanhui:(UIButton *)sender
{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signatureAction
{
    
    ODUserSignatureController *vc = [[ODUserSignatureController alloc] init];
    
  
    vc.signature =self.informationView.signatureLabel.text;
    
    vc.getTextBlock = ^(NSString *text){
        
     
        if ([text isEqualToString:@""]) {
            self.informationView.signatureLabel.text = [NSString stringWithFormat:@"未设置签名"];
        }else{
            
            
            self.informationView.signatureLabel.text = text;
            
        }

        
        
        
    };
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
}

- (void)nickNameAction
{
    
    ODUserNickNameController *vc = [[ODUserNickNameController alloc] init];
    
  
    vc.nickName =  self.informationView.nickNameLabel.text;
   
    vc.getTextBlock = ^(NSString *text){
        
        
        if ([text isEqualToString:@""]) {
            self.informationView.nickNameLabel.text = [NSString stringWithFormat:@"未设置昵称"];
        }else{
            
            
            self.informationView.nickNameLabel.text = text;
            
        }
        
        
    };

    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)genderAction
{
    
    ODUserGenderController *vc = [[ODUserGenderController alloc] init];
     
    vc.getTextBlock = ^(NSString *text){
        
    if ([text isEqualToString:@"1"]) {
            self.informationView.genderLabel.text = @"男";
        }else if ([text isEqualToString:@"2"]){
            self.informationView.genderLabel.text = @"女";
            
        }
      };

    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)phoneAction
{
    
    ODBindingMobileController *vc = [[ODBindingMobileController alloc] init];
   
    
    
    vc.getTextBlock = ^(NSString *text){
        
        
    self.informationView.phoneLabel.text = text;

        
        
    };

    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)passWordAction
{
    
    ODChangePassWordController *vc = [[ODChangePassWordController alloc] init];
    
  
    vc.topTitle = @"修改密码";
    
    [self.navigationController pushViewController:vc animated:YES];

    
}

- (void)picAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];

}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            }
            else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您当前的照相机不可用" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:sure];
                [self presentViewController:alert animated:YES completion:nil];
            }
            break;
        case 1:
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
            break;
        default:
            break;
    }
}

// 自己处理cancel
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//点击确定之后
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *sourceType = info[UIImagePickerControllerMediaType];
    if ([sourceType isEqualToString:(NSString *)kUTTypeImage]) {
        
        self.image = info[UIImagePickerControllerEditedImage];
        
        self.informationView.userImageView.image = self.image;
        
        
        //设置image的尺寸
        CGSize imagesize = self.image.size;
        
        imagesize.height = 200;
        imagesize.width = 200;
        
        //对图片大小进行压缩--
        UIImage *image1 = [self imageWithImage:self.image scaledToSize:imagesize];
        //图片转化为data
        NSData *imageData;
        imageData = UIImagePNGRepresentation(image1);
        NSString *str = @"data:image/jpeg;base64,";
        NSString *strData = [str stringByAppendingString:[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
        
        NSDictionary *parameter = @{@"File":strData};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        
        NSString *url = @"http://woquapi.odong.com/1.0/other/base64/upload";
        
        
        [self pushImageWithUrl:url parameter:signParameter];

        
    }
}


#pragma mark - 压缩照片
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}



#pragma mark - 请求数据
-(void)pushImageWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSString *str = result[@"File"];
           
                self.imgsString = str;
                
                
                [self saveImge];
            
        
        }
     
      
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}


- (void)saveImge
{
    
    self.managers = [AFHTTPRequestOperationManager manager];
    
    ODUserModel *model = self.dataArray[0];
    NSString *open_id = model.open_id;

    NSDictionary *parameters = @{@"avatar": self.imgsString , @"open_id":open_id};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    
    NSString *url = @"http://woquapi.odong.com/1.0/user/change";
    [self.managers GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
           
            
       
               [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
            
        }
        
        else if ([responseObject[@"status"]isEqualToString:@"error"]) {
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:responseObject[@"message"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: @"确定" , nil];
            [alter show];
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];

    
    
}


#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
