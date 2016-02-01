//
//  ODBazaarExchangeSkillDetailViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarExchangeSkillDetailViewController.h"

@interface ODBazaarExchangeSkillDetailViewController ()

@end

@implementation ODBazaarExchangeSkillDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createRequest];
    [self createScrollView];
    [self joiningTogetherParmeters];
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
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64)];
    [self.view addSubview:self.scrollView];
}

-(void)createUserInfoView
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    UIView *userInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 80)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:userInfoView];
    
    
    UIButton *headButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    headButton.layer.masksToBounds = YES;
    headButton.layer.cornerRadius = 30;
    [headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar"]] forState:UIControlStateNormal];
    [userInfoView addSubview:headButton];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 35, 10,10)];
    imageView.image = [UIImage imageNamed:@"Skills profile page_icon_Not certified"];
    [userInfoView addSubview:imageView];
    
    UILabel *nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, kScreenSize.width-100 - 50, 20)];
    nickLabel.text = model.user[@"nick"];
    [userInfoView addSubview:nickLabel];
}

-(void)createDetailView
{
    ODBazaarExchangeSkillModel *model = [self.dataArray objectAtIndex:0];
    
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 85, kScreenSize.width, 200)];
    detailView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:detailView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenSize.width, 20)];
    titleLabel.text = [NSString stringWithFormat:@"我去 %@",model.title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [detailView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame)+10, kScreenSize.width-20, [ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14])];
    contentLabel.text = model.content;
    [detailView addSubview:contentLabel];
    
     __block CGRect frame;
    if (model.imgs_small.count) {
        for (NSInteger i = 0; i < model.imgs_small.count; i++) {
            NSDictionary *dict = model.imgs_small[i];
            NSLog(@"%@",dict[@"img_url"]);
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [imageView sd_setImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                [imageView sizeToFit];
                imageView.frame = CGRectMake(10, CGRectGetMaxY(contentLabel.frame)+ 10+(imageView.od_height * ((kScreenSize.width-20) / imageView.od_width)+10)*i, kScreenSize.width-20, imageView.od_height * ((kScreenSize.width-20) / imageView.od_width));
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [detailView addSubview:imageView];
                
                if (i==model.imgs_small.count-1) {
                    frame = imageView.frame;
                    detailView.frame = CGRectMake(0, 85, kScreenSize.width, frame.origin.y + frame.size.height);
                    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, 85+detailView.frame.size.height);
                }
                
            }];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
