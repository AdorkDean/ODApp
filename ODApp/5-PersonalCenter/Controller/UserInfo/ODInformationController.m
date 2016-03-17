//
//  ODInformationController.m
//  ODApp
//
//  Created by zhz on 16/1/7.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODInformationController.h"
#import "ODInformationView.h"
#import "ODUserSignatureController.h"
#import "ODUserNickNameController.h"
#import "ODUserGenderController.h"
#import "ODBindingMobileController.h"
#import "ODTabBarController.h"
#import "ODUserModel.h"
#import "UIImageView+WebCache.h"
#import "ODChangePassWordController.h"
#import "ODUploadImageModel.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ODInformationController ()<UITableViewDataSource , UITableViewDelegate ,UIImagePickerControllerDelegate , UIActionSheetDelegate , UINavigationControllerDelegate>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) ODInformationView *informationView;
@property (nonatomic , strong) UIImage *image;
@property (nonatomic , strong) UIImagePickerController *imagePicker;
@property (nonatomic , copy) NSString *imgsString;//分界线的标识符
@end

@implementation ODInformationController


#pragma mark - 生命周期方法
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getData];
    self.navigationItem.title = @"个人中心";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 初始化方法
- (void)createTableView
{
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, kScreenSize.height - 50) style:UITableViewStylePlain];
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.userInteractionEnabled = YES;
        
        self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        self.informationView = [ODInformationView getView];
        self.informationView.userInteractionEnabled = YES;
        self.tableView.tableHeaderView = self.informationView;
        [self.view addSubview:self.tableView];
    }
    
    ODUserModel *model = self.dataArray[0];
    
    
    [self.informationView.userImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.avatar]];
    
    
    UITapGestureRecognizer *pictMap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picAction)];
    [self.informationView.userImageView addGestureRecognizer:pictMap];
    
    
    
    self.informationView.userImageView.layer.masksToBounds = YES;
    self.informationView.userImageView.layer.cornerRadius = 47.5;
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
    
    [self.informationView.codeImageView sd_setImageWithURL:[NSURL OD_URLWithString:model.qrcode]];
    
    
    
}

#pragma mark - 请求数据
- (void)getData
{
    [self.dataArray removeAllObjects];
    __weakSelf
    [ODHttpTool getWithURL:ODUrlUserInfo  parameters:@{} modelClass:[ODUserModel class] success:^(id model) {
        ODUserModel *user = [model result];
        [weakSelf.dataArray addObject:user];
        
        [weakSelf createTableView];
        [weakSelf.tableView reloadData];
        
        if ([weakSelf.delegate respondsToSelector:@selector(infoVc:DidChangedUserImage:)])
        {
            [weakSelf.delegate infoVc:weakSelf DidChangedUserImage:user];
        }
        // 更新缓存
        [[ODUserInformation sharedODUserInformation] updateUserCache:user];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

#pragma mark - UIActionSheet 代理方法
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
                
                
                [ODProgressHUD showInfoWithStatus:@"您当前的照相机不可用"];
                
                
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
        /**
         //拿到图片
         UIImage *image = [UIImage imageNamed:@"flower.png"]; NSString *path_sandox = NSHomeDirectory();
         //设置一个图片的存储路径
         NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/flower.png"];
         //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
         [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
         
         */

        
        
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
        
        // 拼接参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"File"] = strData;
        __weakSelf
        // 上传图片
        [ODHttpTool postWithURL:ODUrlOtherBase64Upload parameters:params modelClass:[ODUploadImageModel class] success:^(id model) {
            // 取出模型
            ODUploadImageModel *uploadModel = [model result];
            weakSelf.imgsString = uploadModel.File;
            
            // 更新图片
            [weakSelf updateUserImage];
        } failure:^(NSError *error) {
        }];
    }
}

#pragma mark - 点击事件
- (void)signatureAction
{
    
    ODUserSignatureController *vc = [[ODUserSignatureController alloc] init];
    
    vc.signature =self.informationView.signatureLabel.text;
    
    vc.getTextBlock = ^(NSString *text){
        
        
        if ([text isEqualToString:@""] || [text isEqualToString:@"请输入签名"]) {
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
        
        
        if ([text isEqualToString:@""]||[text isEqualToString:@"请输入昵称"]) {
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
    ODUserModel *model = self.dataArray[0];
    
    vc.phoneNumber = model.mobile;
    
    vc.topTitle = @"修改密码";
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)picAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
    
}

/**
 *  更新图片
 */
- (void)updateUserImage
{
    // 拼接参数
    ODUserModel *model = self.dataArray[0];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"avatar"] = self.imgsString;
    params[@"open_id"] = model.open_id;
    __weakSelf
    // 发送请求
    [ODHttpTool getWithURL:ODUrlUserChange parameters:params modelClass:[ODUserModel class] success:^(id model)
     {
         ODUserModel *userModel = [model result];
         
         [weakSelf.informationView.userImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar]];
         
         [weakSelf.tableView reloadData];
         
         [weakSelf.imagePicker dismissViewControllerAnimated:YES completion:nil];
     } failure:^(NSError *error) {
     }];
}

/**
 *  压缩图片
 */
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@end
