//
//  ODBazaarExchangeSkillDetailViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarExchangeSkillDetailViewController.h"
#import "ODSecondOrderController.h"
@interface ODBazaarExchangeSkillDetailViewController ()

@property(nonatomic,strong)NSOperationQueue *queue;
@property(nonatomic,strong)NSMutableDictionary *imagesDic;
@property(nonatomic,strong)NSMutableDictionary *operations;

@end

@implementation ODBazaarExchangeSkillDetailViewController

-(NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}

- (NSMutableDictionary *)imagesDic
{
    if (!_imagesDic)
    {
        _imagesDic = [NSMutableDictionary dictionary];
    }
    return _imagesDic;
}

-(NSMutableDictionary *)operations
{
    if (_operations == nil) {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createRequest];
    [self createScrollView];
    [self joiningTogetherParmeters];
    self.navigationItem.title = self.nick;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(shareButtonClick) image:[UIImage imageNamed:@"话题详情-分享icon"] highImage:nil];

}


#pragma mark - 分享
-(void)shareButtonClick
{
    
    @try {
        
        ODBazaarExchangeSkillModel *model = self.dataArray[0];
        NSString *url = model.share[@"icon"];
        NSString *content = model.share[@"desc"];
        NSString *link = model.share[@"link"];
        NSString *title = model.share[@"title"];
        
        
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kGetUMAppkey
                                          shareText:content
                                         shareImage:nil
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                           delegate:self];
        
    }
    @catch (NSException *exception) {
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常无法分享"];
    }
    
}


-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter = @{@"swap_id":self.swap_id,@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarExchangeSkillDetailUrl parameter:signParameter];
}

-(void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weakSelf;
    if ([self.love isEqualToString:@"love"]) {
        
    }else{
        [SVProgressHUD showWithStatus:ODAlertIsLoading maskType:(SVProgressHUDMaskTypeBlack)];
    }
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            ODBazaarExchangeSkillModel *model = [[ODBazaarExchangeSkillModel alloc]init];
            [model setValuesForKeysWithDictionary:result];
            [weakSelf.dataArray addObject:model];
            weakSelf.love_id = [NSString stringWithFormat:@"%@",model.love_id];
            [weakSelf createUserInfoView];
            [weakSelf createDetailView];
            [weakSelf createBottomView];
            [SVProgressHUD dismiss];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50)];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.view addSubview:self.scrollView];
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray)
    {
        self.imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}

-(void)createUserInfoView
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otherInfoClick)];
    UIView *userInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 65)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [userInfoView addGestureRecognizer:gesture];
    [self.scrollView addSubview:userInfoView];
    
    UIButton *headButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    headButton.layer.masksToBounds = YES;
    headButton.layer.cornerRadius = 20;
    [headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar"]] forState:UIControlStateNormal];
    [userInfoView addSubview:headButton];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 22.5, 11,11)];
    imageView.image = [UIImage imageNamed:@"Skills profile page_icon_Not certified"];
    [userInfoView addSubview:imageView];
    
    UILabel *certificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, kScreenSize.width-80-50, 20)];
    certificationLabel.font = [UIFont systemFontOfSize:13];
    certificationLabel.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    NSString *user_auth_status = [NSString stringWithFormat:@"%@",model.user[@"user_auth_status"]];
    if ([user_auth_status isEqualToString:@"0"]) {
        certificationLabel.text = @"未认证";
    }else if ([user_auth_status isEqualToString:@"0"]){
        certificationLabel.text = @"已认证";
    }
    [userInfoView addSubview:certificationLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width-25, 25, 10, 10)];
    arrowImageView.image = [UIImage imageNamed:@"Skills profile page_icon_arrow_upper"];
    [userInfoView addSubview:arrowImageView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kScreenSize.width, 5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [userInfoView addSubview:lineView];
}

-(void)otherInfoClick
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    ODOthersInformationController *otherInfo = [[ODOthersInformationController alloc]init];
    otherInfo.open_id = model.user[@"open_id"];
    if ([model.user[@"open_id"] isEqualToString:[ODUserInformation sharedODUserInformation].openID]) {
        
    }else{
        [self.navigationController pushViewController:otherInfo animated:YES];
    }
}

-(void)createDetailView
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    self.detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, kScreenSize.width, 2000)];
    self.detailView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.detailView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenSize.width, 20)];
    titleLabel.text = [NSString stringWithFormat:@"我去 · %@",model.title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.detailView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+10, kScreenSize.width, 20)];
    priceLabel.text = [[[[NSString stringWithFormat:@"%@",model.price] stringByAppendingString:@"元"] stringByAppendingString:@"/"] stringByAppendingString:model.unit];
    priceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:14];
    [self.detailView addSubview:priceLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(priceLabel.frame)+10, kScreenSize.width-20, [ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14])];
    contentLabel.text = model.content;
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    [self.detailView addSubview:contentLabel];
    
    for (NSInteger i = 0; i < model.imgs_big.count; i++) {
        NSDictionary *dict = model.imgs_big[i];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL OD_URLWithString:dict[@"img_url"]]]];
        [self.imageArray addObject:image];
    }
    
    [SVProgressHUD dismiss];

    CGRect frame;
    for (NSInteger i = 0; i < self.imageArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = self.imageArray[i];
       
        [imageView sizeToFit];
        CGFloat multiple = imageView.od_width/(kScreenSize.width-20);
        CGFloat height = imageView.od_height/multiple;
        if (i==0) {
            imageView.frame = CGRectMake(10, CGRectGetMaxY(contentLabel.frame)+10,kScreenSize.width-20,height);
            frame = imageView.frame;
            if (model.imgs_big.count==1) {
                self.loveImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenSize.width - 180) / 2, CGRectGetMaxY(imageView.frame) + 10, 180, 40)];
                self.loveImageView.image = [UIImage imageNamed:@"Skills profile page_share"];
                [self.detailView addSubview:self.loveImageView];
                self.detailView.frame = CGRectMake(0, 65, kScreenSize.width, self.loveImageView.frame.origin.y+self.loveImageView.frame.size.height+60);
                self.scrollView.contentSize = CGSizeMake(kScreenSize.width,65+self.detailView.frame.size.height);
                [self createLoveButton];
            }
        }
        else
        {
            if (i==model.imgs_big.count-1) {
                imageView.frame = CGRectMake(10, CGRectGetMaxY(frame)+10, kScreenSize.width-20, height);
                self.loveImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenSize.width - 180) / 2, CGRectGetMaxY(imageView.frame) + 10, 180, 40)];
                self.loveImageView.image = [UIImage imageNamed:@"Skills profile page_share"];
                [self.detailView addSubview:self.loveImageView];
                self.detailView.frame = CGRectMake(0, 65, kScreenSize.width, self.loveImageView.frame.origin.y+self.loveImageView.frame.size.height+60);
                self.scrollView.contentSize = CGSizeMake(kScreenSize.width,65+self.detailView.frame.size.height);
                [self createLoveButton];
            }else{
                imageView.frame = CGRectMake(10, CGRectGetMaxY(frame)+10, kScreenSize.width-20, height);
                frame = imageView.frame;
            }
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.detailView addSubview:imageView];
        [self.detailView addSubview:imageView];
    }

}

-(void)createLoveButton
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    if (model.loves.count < 8) {
        for (NSInteger i = 0; i < model.loves.count; i++) {
            NSDictionary *dict = model.loves[i];
            CGFloat width = 30;
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake((kScreenSize.width-(model.loves.count-1)*10-model.loves.count*width)/2+(width+10)*i, CGRectGetMaxY(self.loveImageView.frame)+10, width, width);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = width/2;
            [button sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"avatar"]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(lovesListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.detailView addSubview:button];
        }
    }else{
        for (NSInteger i = 0; i < 7; i++) {
            NSDictionary *dict = model.loves[i];
            CGFloat width = 30;
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake((kScreenSize.width-6*10-7*width)/2+(width+10)*i, CGRectGetMaxY(self.loveImageView.frame)+10, width, width);
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = width/2;
            [button sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"avatar"]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(lovesListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.detailView addSubview:button];
        }
    }
}

#pragma mark - 收藏人列表点击事件
-(void)lovesListButtonClick:(UIButton *)button
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    ODCollectionController *collection = [[ODCollectionController alloc]init];
    collection.open_id = model.user[@"open_id"];
    collection.swap_id = [NSString stringWithFormat:@"%@",model.swap_id];
    [self.navigationController pushViewController:collection animated:YES];
}

#pragma mark - 底部收藏购买试图
- (void)createBottomView
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenSize.height-64-50, kScreenSize.width, 50)];
    [bottomView setBackgroundColor:[UIColor colorWithHexString:@"#e6e6e6" alpha:1]];
    [self.view addSubview:bottomView];
    
    UIButton *loveButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [loveButton addTarget:self action:@selector(loveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    loveButton.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [bottomView addSubview:loveButton];
    
    UIImageView *loveImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17.5, 15, 15)];
    
    [loveButton addSubview:loveImageView];
    
    self.loveLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 50, 20)];
    if ([self.love_id isEqualToString:@"0"]) {
        self.loveLabel.text = @"收藏";
        loveImageView.image = [UIImage imageNamed:@"Skills profile page_icon_Collection_default"];
    }else{
        self.loveLabel.text = @"已收藏";
        loveImageView.image = [UIImage imageNamed:@"Skills profile page_icon_Collection"];
    }
    self.loveLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.loveLabel.textAlignment = NSTextAlignmentLeft;
    self.loveLabel.font = [UIFont systemFontOfSize:15];
    [loveButton addSubview:self.loveLabel];

    UIButton *payButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, kScreenSize.width - 100, 50)];
    [payButton setTitle:@"立即购买" forState:UIControlStateNormal];
    if ([model.user[@"open_id"] isEqualToString:[ODUserInformation sharedODUserInformation].openID]) {
        [payButton setBackgroundColor:[UIColor colorWithHexString:@"#b0b0b0" alpha:1]];
        payButton.userInteractionEnabled = NO;
    }else{
        [payButton setBackgroundColor:[UIColor colorWithHexString:@"#ff6666" alpha:1]];
        payButton.userInteractionEnabled = YES;
    }
    [payButton setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payButton];
}

#pragma mark - 收藏事件
-(void)loveButtonClick:(UIButton *)button
{
    if ([[[ODUserInformation sharedODUserInformation]openID]isEqualToString:@""]) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    }else{
        if ([self.loveLabel.text isEqualToString:@"收藏"]) {
            NSDictionary *parameter = @{@"type":@"4",@"obj_id":self.swap_id,@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
            NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
            [self pushDataWithUrl:kBazaarExchangeSkillDetailLoveUrl parameter:signParameter isLove:YES];
        }else{
            NSDictionary *parameter = @{@"love_id":self.love_id,@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
            NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
            [self pushDataWithUrl:kBazaarExchangeSkillDetailNotLoveUrl parameter:signParameter isLove:NO];
        }
    }
}

-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter isLove:(BOOL)love
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weakSelf;
   [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       if (love) {
           if ([responseObject[@"status"] isEqualToString:@"success"]) {
               self.love = @"love";
               [weakSelf joiningTogetherParmeters];
               NSDictionary *dict = responseObject[@"result"];
               weakSelf.love_id = [NSString stringWithFormat:@"%@",dict[@"love_id"]];
               [weakSelf createProgressHUDWithAlpha:0.6 withAfterDelay:0.8 title:@"收藏成功"];
           }
       }else{
           if ([responseObject[@"status"] isEqualToString:@"success"]) {
               self.love = @"love";
               [weakSelf joiningTogetherParmeters];
               [weakSelf createProgressHUDWithAlpha:0.6 withAfterDelay:0.8 title:@"取消收藏"];
           }
       }
       
   } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
       
   }];

}

#pragma mark - 立即购买事件
-(void)payButtonClick:(UIButton *)button
{
    
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    NSString *type = [NSString stringWithFormat:@"%@" ,model.swap_type];
    
    if ([[[ODUserInformation sharedODUserInformation]openID] isEqualToString:@""]) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
        
    }else{
        if ([type isEqualToString:@"1"]) {
            ODOrderController *vc  =[[ODOrderController alloc] init];
            vc.informationModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([type isEqualToString:@"2"]) {
            
            ODSecondOrderController *orderController = [[ODSecondOrderController alloc]init];
            orderController.informationModel = model;
            [self.navigationController pushViewController:orderController animated:YES];
            
        }else{
            ODThirdOrderController *orderController = [[ODThirdOrderController alloc]init];
            orderController.informationModel = model;
            [self.navigationController pushViewController:orderController animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
