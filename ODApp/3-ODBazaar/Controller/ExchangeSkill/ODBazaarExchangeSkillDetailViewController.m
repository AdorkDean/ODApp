//
//  ODBazaarExchangeSkillDetailViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarExchangeSkillDetailViewController.h"
#import "ODSecondOrderController.h"
#import "WXApi.h"

#import "ODSubmitOrderController.h"

@interface ODBazaarExchangeSkillDetailViewController ()

@property (nonatomic, assign) BOOL isCollect;

@end

@implementation ODBazaarExchangeSkillDetailViewController

#pragma mark - lazyload
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 64 - 49)];
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.nick;
    [self requestData];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(shareButtonClick) image:[UIImage imageNamed:@"话题详情-分享icon"] highImage:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据请求
- (void)requestData
{
    __weakSelf;
    NSDictionary *parameter = @{@"swap_id" : self.swap_id};
    [ODHttpTool getWithURL:ODUrlSwapInfo parameters:parameter modelClass:[ODBazaarExchangeSkillDetailModel class] success:^(id model) {
        weakSelf.model = [model result];
        weakSelf.love_id = [NSString stringWithFormat:@"%@", [weakSelf.model valueForKeyPath:@"love_id"]];
        weakSelf.love_num = [NSString stringWithFormat:@"%@", [weakSelf.model valueForKeyPath:@"love_num"]];
        [weakSelf createUserInfoView];
        [weakSelf createDetailView];
        [weakSelf createBottomView];
        
        if (self.isCollect) {
            [weakSelf backRefreshData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter isLove:(BOOL)love {
    __weakSelf;
    [ODHttpTool getWithURL:url parameters:parameter modelClass:[ODBazaarExchangeSkillDetailLoveModel class] success:^(ODBazaarExchangeSkillDetailLoveModelResponse *model) {
        self.isCollect = YES;
        if (love) {
            weakSelf.love = @"love";
            [weakSelf requestData];
            ODBazaarExchangeSkillDetailLoveModel *loveModel = [model result];
            weakSelf.love_id = [NSString stringWithFormat:@"%d",loveModel.love_id];
            [ODProgressHUD showInfoWithStatus:@"收藏成功"];
        }else{
            weakSelf.love = @"love";
            [weakSelf requestData];
            [ODProgressHUD showInfoWithStatus:@"取消收藏"];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UMSocialUIDelegate
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if (response.responseCode == UMSResponseCodeSuccess) {
        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.swap_id, @"obj_id", @"3", @"type", @"微信", @"share_platform", nil];
        [ODHttpTool getWithURL:ODUrlOtherShareCallBack parameters:infoDic modelClass:[NSObject class] success:^(id model) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)createUserInfoView {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherInfoClick)];
    UIView *userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 73)];
    userInfoView.backgroundColor = [UIColor whiteColor];
    [userInfoView addGestureRecognizer:gesture];
    [self.scrollView addSubview:userInfoView];

    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 10, 40, 40)];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 20;
    [headImageView sd_setImageWithURL:[NSURL OD_URLWithString:self.model.user[@"avatar"]] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    [userInfoView addSubview:headImageView];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) + 17.5, 24.25, 11.5, 11.5)];
    imageView.image = [UIImage imageNamed:@"Skills profile page_icon_Not certified"];
    [userInfoView addSubview:imageView];

    UILabel *certificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 24, kScreenSize.width - 88 - 50, 12)];
    certificationLabel.font = [UIFont systemFontOfSize:11.5];
    certificationLabel.textColor = [UIColor colorGreyColor];
    NSString *user_auth_status = [NSString stringWithFormat:@"%@", self.model.user[@"user_auth_status"]];
    if ([user_auth_status isEqualToString:@"0"]) {
        certificationLabel.text = @"未认证";
    } else if ([user_auth_status isEqualToString:@"0"]) {
        certificationLabel.text = @"已认证";
    }
    [userInfoView addSubview:certificationLabel];

    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 22.5, 24.25, 7, 12.5)];
    arrowImageView.image = [UIImage imageNamed:@"Skills profile page_icon_arrow_upper"];
    [userInfoView addSubview:arrowImageView];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kScreenSize.width, 6)];
    lineView.backgroundColor = [UIColor lineColor];
    [userInfoView addSubview:lineView];
}

- (void)createDetailView {
    self.detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 66, kScreenSize.width, 200)];
    self.detailView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.detailView];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 30, kScreenSize.width - 35, 17)];
    titleLabel.text = [NSString stringWithFormat:@"我去 · %@", self.model.title];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self.detailView addSubview:titleLabel];

    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, CGRectGetMaxY(titleLabel.frame) + 10, kScreenSize.width - 35, 20)];
    priceLabel.text = [NSString stringWithFormat:@"%.2f元/%@", self.model.price, self.model.unit];
    priceLabel.textColor = [UIColor colorRedColor];
    priceLabel.textAlignment = NSTextAlignmentCenter;
    priceLabel.font = [UIFont systemFontOfSize:15];
    [self.detailView addSubview:priceLabel];

    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, CGRectGetMaxY(priceLabel.frame) + 27.5, kScreenSize.width - 20, [ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width - 20 fontSize:13])];
    contentLabel.text = self.model.content;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.numberOfLines = 0;
    [self.detailView addSubview:contentLabel];

    CGRect frame = contentLabel.frame;
    for (NSInteger i = 0; i < self.model.imgs_big.count; i++) {
        NSDictionary *dict = self.model.imgs_big[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat multiple = [[dict valueForKeyPath:@"x"] floatValue] / [[dict valueForKeyPath:@"y"] floatValue];
        if ([[dict valueForKeyPath:@"x"] floatValue] == 0) {
            imageView.frame = CGRectMake(17.5, CGRectGetMaxY(frame) + 12.5, kScreenSize.width - 35, 300);
        } else {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, CGRectGetMaxY(frame) + 6, kScreenSize.width - 35, (kScreenSize.width - 35) / multiple)];
        }
        frame = imageView.frame;
        [imageView sd_setImageWithURL:[NSURL OD_URLWithString:[dict valueForKeyPath:@"img_url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
        [self.detailView addSubview:imageView];
    }
    self.loveImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenSize.width - 181)/2, CGRectGetMaxY(frame)+30, 181, 40)];
    self.loveImageView.image = [UIImage imageNamed:@"Skills profile page_share"];
    [self.detailView addSubview:self.loveImageView];
    self.detailView.frame = CGRectMake(0, 66, kScreenSize.width, self.loveImageView.frame.origin.y + self.loveImageView.frame.size.height + 60);
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width, 66 + self.detailView.frame.size.height);
    [self createLoveButton];
}

- (void)createLoveButton {
    NSInteger count;
    if (self.model.loves.count < 8) {
        count = self.model.loves.count;
    }else{
        count = 7;
    }
    for (NSInteger i = 0; i < count; i++) {
        NSDictionary *dict = self.model.loves[i];
        CGFloat width = 30;
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake((kScreenSize.width-(count-1)*10-count*width)/2+(width+10)*i, CGRectGetMaxY(self.loveImageView.frame)+15, width, width);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = width / 2;
        [button sd_setBackgroundImageWithURL:[NSURL OD_URLWithString: [dict valueForKeyPath:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
        [button addTarget:self action:@selector(lovesListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.detailView addSubview:button];
    }
}

#pragma mark - 底部收藏购买试图
- (void)createBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 64 - 49, kScreenSize.width, 49)];
    [bottomView setBackgroundColor:[UIColor lineColor]];
    [self.view addSubview:bottomView];

    UIButton *loveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 49)];
    [loveButton addTarget:self action:@selector(loveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    loveButton.backgroundColor = [UIColor whiteColor];
    loveButton.layer.borderColor = [UIColor lineColor].CGColor;
    loveButton.layer.borderWidth = 0.5;
    [bottomView addSubview:loveButton];

    UIImageView *loveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 15, 15)];
    [loveButton addSubview:loveImageView];

    self.loveLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loveImageView.frame) + 5, 18, 50, 13)];
    if ([self.love_id isEqualToString:@"0"]) {
        self.loveLabel.text = @"收藏";
        loveImageView.image = [UIImage imageNamed:@"Skills profile page_icon_Collection_default"];
    } else {
        self.loveLabel.text = @"已收藏";
        loveImageView.image = [UIImage imageNamed:@"Skills profile page_icon_Collection"];
    }
    self.loveLabel.textColor = [UIColor blackColor];
    self.loveLabel.textAlignment = NSTextAlignmentLeft;
    self.loveLabel.font = [UIFont systemFontOfSize:12.5];
    [loveButton addSubview:self.loveLabel];

    UIButton *payButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, kScreenSize.width - 100, 49)];
    [payButton setTitle:@"立即购买" forState:UIControlStateNormal];
    if ([[self.model.user valueForKeyPath:@"open_id"] isEqualToString:[ODUserInformation sharedODUserInformation].openID]) {
        [payButton setBackgroundColor:[UIColor colorGreyColor]];
        payButton.userInteractionEnabled = NO;
    } else {
        [payButton setBackgroundColor:[UIColor colorRedColor]];
        payButton.userInteractionEnabled = YES;
    }
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payButton];
}

#pragma mark - action

- (void)backRefreshData {
    NSDictionary *loveDict = [[NSDictionary alloc] initWithObjectsAndKeys:self.love_num, @"loveNumber", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:ODNotificationloveSkill object:nil userInfo:loveDict];
}

- (void)shareButtonClick {
    [ODPublicTool shareAppWithTarget:self dictionary:self.model.share controller:self];
}

- (void)otherInfoClick {
    ODOthersInformationController *otherInfo = [[ODOthersInformationController alloc] init];
    otherInfo.open_id = self.model.user[@"open_id"];
    if ([self.model.user[@"open_id"] isEqualToString:[ODUserInformation sharedODUserInformation].openID]) {
    } else {
        [self.navigationController pushViewController:otherInfo animated:YES];
    }
}

- (void)lovesListButtonClick:(UIButton *)button {
    ODCollectionController *collection = [[ODCollectionController alloc] init];
    collection.open_id = [self.model.user valueForKeyPath:@"open_id"];
    collection.swap_id = [NSString stringWithFormat:@"%d", self.model.swap_id];
    [self.navigationController pushViewController:collection animated:YES];
}

- (void)loveButtonClick:(UIButton *)button {
    if ([ODUserInformation sharedODUserInformation].openID.length == 0) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    } else {
        if ([self.loveLabel.text isEqualToString:@"收藏"]) {
            NSDictionary *parameter = @{@"type" : @"4", @"obj_id" : self.swap_id};
            [self pushDataWithUrl:ODUrlOtherLoveAdd parameter:parameter isLove:YES];
        } else {
            NSDictionary *parameter = @{@"love_id" : self.love_id};
            [self pushDataWithUrl:ODUrlOtherLoveDel parameter:parameter isLove:NO];
        }
    }
}

- (void)payButtonClick:(UIButton *)button {
    NSString *type = [NSString stringWithFormat:@"%d", self.model.swap_type];
    if ([ODUserInformation sharedODUserInformation].openID.length == 0) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    } else {
        if ([type isEqualToString:@"1"]) {
            ODOrderController *vc = [[ODOrderController alloc] init];
            vc.informationModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([type isEqualToString:@"2"]) {
            ODSecondOrderController *orderController = [[ODSecondOrderController alloc] init];
            orderController.informationModel = self.model;
            [self.navigationController pushViewController:orderController animated:YES];
        } else {
            ODThirdOrderController *orderController = [[ODThirdOrderController alloc] init];
            orderController.informationModel = self.model;
            [self.navigationController pushViewController:orderController animated:YES];
        }
    }
}

@end
