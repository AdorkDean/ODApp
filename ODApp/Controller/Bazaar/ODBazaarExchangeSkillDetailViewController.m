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

@end

@implementation ODBazaarExchangeSkillDetailViewController

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
                                             appKey:@"569dda54e0f55a994f0021cf"
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
    NSDictionary *parameter = @{@"swap_id":self.swap_id};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarExchangeSkillDetailUrl parameter:signParameter];
}

-(void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weakSelf;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            ODBazaarExchangeSkillModel *model = [[ODBazaarExchangeSkillModel alloc]init];
            [model setValuesForKeysWithDictionary:result];
            [weakSelf.dataArray addObject:model];
            [weakSelf createUserInfoView];
            [weakSelf createDetailView];
            [weakSelf createBottomView];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50)];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.view addSubview:self.scrollView];
}

-(void)createUserInfoView
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(otherInfoClick)];
    UIView *userInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 60)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [userInfoView addGestureRecognizer:gesture];
    [self.scrollView addSubview:userInfoView];
    
    UIButton *headButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    headButton.layer.masksToBounds = YES;
    headButton.layer.cornerRadius = 20;
    [headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar"]] forState:UIControlStateNormal];
    [userInfoView addSubview:headButton];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 22.5, 10,15)];
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
}

-(void)otherInfoClick
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    ODOthersInformationController *otherInfo = [[ODOthersInformationController alloc]init];
    otherInfo.open_id = model.user[@"open_id"];
    [self.navigationController pushViewController:otherInfo animated:YES];
}

-(void)createDetailView
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, kScreenSize.width, 2000)];
    detailView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:detailView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenSize.width, 20)];
    titleLabel.text = [NSString stringWithFormat:@"我去 · %@",model.title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [detailView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+10, kScreenSize.width, 20)];
    priceLabel.text = [[[[NSString stringWithFormat:@"%@",model.price] stringByAppendingString:@"元"] stringByAppendingString:@"/"] stringByAppendingString:model.unit];
    priceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:14];
    [detailView addSubview:priceLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(priceLabel.frame)+10, kScreenSize.width-20, [ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14])];
    contentLabel.text = model.content;
    contentLabel.font = [UIFont systemFontOfSize:14];
    [detailView addSubview:contentLabel];
    
    
    __block CGRect frame;
    for (NSInteger i = 0; i < model.imgs_big.count; i++) {
        NSDictionary *dict = model.imgs_big[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView sd_setImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [imageView sizeToFit];
            CGFloat multiple = imageView.od_width/(kScreenSize.width-20);
            CGFloat height = imageView.od_height/multiple;
            if (i==0) {
                imageView.frame = CGRectMake(10, CGRectGetMaxY(contentLabel.frame)+10,kScreenSize.width-20,height);
                frame = imageView.frame;
            }else{
                if (i==model.imgs_big.count-1) {
                    imageView.frame = CGRectMake(10, CGRectGetMaxY(frame)+10, kScreenSize.width-20, height);

                    UIImageView *loveIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenSize.width - 180) / 2, CGRectGetMaxY(imageView.frame) + 10, 180, 40)];
                    loveIamgeView.image = [UIImage imageNamed:@"Skills profile page_share"];
                    [detailView addSubview:loveIamgeView];
                        
                    if (model.loves.count) {
                        for (NSInteger i = 0; i < model.loves.count; i++) {
                            CGFloat width = 40;
                            NSDictionary *dict = model.loves[i];
                            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((kScreenSize.width-(model.loves.count-1)*10-model.loves.count*width)/2+(width+10)*i, CGRectGetMaxY(loveIamgeView.frame)+10, width, width)];
                            button.layer.masksToBounds = YES;
                            button.layer.cornerRadius = 20;
                            [button sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:dict[@"avatar"]] forState:UIControlStateNormal];
                            [button addTarget:self action:@selector(lovesListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                            [detailView addSubview:button];
                        }
                        detailView.frame = CGRectMake(0, 65, kScreenSize.width, loveIamgeView.frame.origin.y+loveIamgeView.frame.size.height+60);
                    }else{
                        detailView.frame = CGRectMake(0, 65, kScreenSize.width, loveIamgeView.frame.origin.y+loveIamgeView.frame.size.height+10);
                    }
                    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,65+detailView.frame.size.height);
                }else{
                    imageView.frame = CGRectMake(10, CGRectGetMaxY(frame)+10, kScreenSize.width-20, height);
                    frame = imageView.frame;
                }
            }
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [detailView addSubview:imageView];
        }];
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
    [bottomView addSubview:loveButton];
    
    UIImageView *loveImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17.5, 15, 15)];
    loveImageView.image = [UIImage imageNamed:@"Skills profile page_icon_Collection"];
    [loveButton addSubview:loveImageView];
    
    self.loveLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 50, 20)];
    if (model.loves.count) {
        for (NSInteger i = 0; i < model.loves.count; i++) {
            NSDictionary *dict = model.loves[i];
            if ([[[ODUserInformation sharedODUserInformation]openID] isEqualToString:dict[@"open_id"]]) {
                self.loveLabel.text = @"已收藏";
                break;
                
            }else{
                self.loveLabel.text = @"收藏";
            }
        }
    }else{
        self.loveLabel.text = @"收藏";
    }
    self.loveLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.loveLabel.textAlignment = NSTextAlignmentLeft;
    self.loveLabel.font = [UIFont systemFontOfSize:15];
    [loveButton addSubview:self.loveLabel];

    UIButton *payButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, kScreenSize.width - 100, 50)];
    [payButton setTitle:@"立即购买" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [payButton setBackgroundColor:[UIColor colorWithHexString:@"#ff6666" alpha:1]];
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
            NSLog(@"%@",signParameter);
            
        }else{
            NSDictionary *parameter = @{@"love_id":self.love_id,@"open_id":[[ODUserInformation sharedODUserInformation]openID]};
            NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
             NSLog(@"%@",signParameter);
            [self pushDataWithUrl:kBazaarExchangeSkillDetailNotLoveUrl parameter:signParameter isLove:NO];
        }
    }
}

-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter isLove:(BOOL)love
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
   [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
       if (love) {
           if ([responseObject[@"status"] isEqualToString:@"success"]) {
               self.loveLabel.text = @"已收藏";
                NSLog(@"%@",responseObject);
           }
       }else{
           NSLog(@"%@",responseObject);
           if ([responseObject[@"status"] isEqualToString:@"success"]) {
               self.loveLabel.text = @"收藏";
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
        if ([type isEqualToString:@"2"]) {
            ODSecondOrderController *vc  =[[ODSecondOrderController alloc] init];
            vc.informationModel = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ODOrderController *orderController = [[ODOrderController alloc]init];
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
