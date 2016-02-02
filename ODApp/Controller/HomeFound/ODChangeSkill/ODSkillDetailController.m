//
//  ODSkillDetailController.m
//  ODApp
//
//  Created by 代征钏 on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODSkillDetailController.h"

@interface ODSkillDetailController ()

@end

@implementation ODSkillDetailController

#pragma mark - lazyLoad
- (UIScrollView *)scrollView
{
    if (_scrollView == nil)
    {

        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = self.skillDetailModel.user.nick;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithType:(ODBarButtonTypeDefault) target:self action:@selector(shareButtonClick:) image:[UIImage imageNamed:@"话题详情-分享icon"] highImage:nil textColor:nil highColor:nil title:nil];
    
    [self creatPayView];
    [self createSkillDetailRequest];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollView.frame = CGRectMake(10, ODTopY, kScreenSize.width, KControllerHeight - 50 - ODNavigationHeight);
}
#pragma mark - actions
- (void)shareButtonClick:(UIButton *)button
{

    
}

- (void)collectButtonClick:(UIButton *)button
{
    
    
}

- (void)leftButtonClick:(UIButton *)button
{

    
}

- (void)rightButtonClick:(UIButton *)button
{
    
    
}

- (void)payButtonClick:(UIButton *)button
{
    
    ODOrderController *vc = [[ODOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - init

- (void)createSkillDetailView{

    self.titleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 150) / 2, 10, 150, 20) text:self.skillDetailModel.title font:16 alignment:@"center" color:@"#000000" alpha:1];
    self.priceLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 100) / 2, CGRectGetMaxY(self.titleLabel.frame) + 5, 100, 20) text:[NSString stringWithFormat:@"%@元 / %@",self.skillDetailModel.price,self.skillDetailModel.unit] font:15 alignment:@"center" color:@"#000000" alpha:1];
    
    self.contentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame) + 10, kScreenSize.width - 20,[ODHelp textHeightFromTextString:self.skillDetailModel.content width:kScreenSize.width - 10 miniHeight:20 fontSize:14] ) text:self.skillDetailModel.content font:14 alignment:@"left" color:@"#000000" alpha:1];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.priceLabel];
    [self.scrollView addSubview:self.contentLabel];
    
    
    [self.view addSubview:self.scrollView];
}

- (void)createSkillDetailRequest
{

    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    self.pictureArray = [[NSMutableArray alloc] init];
    
    NSDictionary *parameter = @{@"swap_id":@"1601"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    __weakSelf
    [self.manager GET:ODSkillDetailUrl parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *result = dict[@"result"];
            
            weakSelf.skillDetailModel = [ODSkillDetailModel mj_objectWithKeyValues:result];
            
            for (ODSkillDetailImgBigModel *imgBbigModel in weakSelf.skillDetailModel.imgs_big) {
                [weakSelf.pictureArray addObject:imgBbigModel.img_url];
            }
            weakSelf.navigationItem.title = weakSelf.skillDetailModel.user.nick;
            [weakSelf createSkillDetailView];
            [weakSelf setImageView];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
    }];
}

- (void)setImageView
{
    if (self.pictureArray.count)
    {
        for (NSInteger i = 0; i < self.pictureArray.count; i++)
        {
            UIImageView *picImageView = [[UIImageView alloc]init];
            __weakSelf
            [picImageView sd_setImageWithURL:[NSURL OD_URLWithString:self.pictureArray[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                @try {
                    [picImageView sizeToFit];
                    //图片缩放比例
                    float scale = (kScreenSize.width - 20) / picImageView.od_width;
                    picImageView.frame = CGRectMake(0, CGRectGetMaxY(weakSelf.contentLabel.frame) + 5 + (picImageView.od_height * scale + 5) * i,kScreenSize.width - 20 , picImageView.od_height * scale);
                    [weakSelf.scrollView addSubview:picImageView];
                    picImageView.contentMode = UIViewContentModeScaleAspectFill;
                    
                    UIImageView *collectImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenSize.width - 180) / 2, CGRectGetMaxY(picImageView.frame) + 10, 180, 40)];
                    [collectImageView setImage:[UIImage imageNamed:@"Skills profile page_share"]];
                    [self.scrollView addSubview:collectImageView];
                    
                    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(collectImageView.frame) + 10, 15, 15)];
                    [leftButton setImage:[UIImage imageNamed:@"Skills profile page_icon_More left"] forState:UIControlStateNormal];
                    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrollView addSubview:leftButton];
                    
                    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width - 20 - 35, CGRectGetMaxY(collectImageView.frame) + 10, 15, 15)];
                    [rightButton setImage:[UIImage imageNamed:@"Skills profile page_icon_More right"] forState:UIControlStateNormal];
                    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                    [self.scrollView addSubview:rightButton];
                    
                    if (i == self.pictureArray.count - 1)
                    {
                        self.scrollView.contentSize = CGSizeMake(kScreenSize.width, CGRectGetMaxY(rightButton.frame) + 20);
                    }
                }
                @catch (NSException *exception) {
                    
                }
                
            }];
        }
    }
}

- (void)createCollectView
{
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.scrollView.frame) - 50, 15, 15)];
    [leftImageView setImage:[UIImage imageNamed:@"Skills profile page_icon_More left"]];
    [self.scrollView addSubview:leftImageView];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 20, CGRectGetMaxY(self.scrollView.frame) - 50, 15, 15)];
    [leftImageView setImage:[UIImage imageNamed:@"Skills profile page_icon_More right"]];
    [self.scrollView addSubview:rightImageView];
}

- (void)creatPayView
{
    self.payView = [ODClassMethod creatViewWithFrame:CGRectMake(0, KControllerHeight - 50 - ODNavigationHeight, kScreenSize.width, 50) tag:0 color:@"#ffffff"];
    self.payView.layer.borderWidth = 1;
    self.payView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    
    self.collectButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 0, 80, 50) target:self sel:@selector(collectButtonClick:) tag:0 image:nil title:@"" font:0];
    self.collectImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(15, 18, 15, 15) imageName:@"Skills profile page_icon_Collection" tag:0];
    UILabel *collectLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(35, 18, 30, 15) text:@"收藏" font:15 alignment:@"left" color:@"#000000" alpha:1];
    collectLabel.userInteractionEnabled = NO;
    
    self.payButton = [ODClassMethod creatButtonWithFrame:CGRectMake(80, 0, kScreenSize.width - 80, 54) target:self sel:@selector(payButtonClick:) tag:0 image:@"" title:@"立即购买" font:15];
    [self.payButton setTitleColor:[UIColor colorWithHexString:@"#ffffff" alpha:1] forState:UIControlStateNormal];
    self.payButton.backgroundColor = [UIColor redColor];
    
    [self.payView addSubview:self.collectButton];
    [self.payView addSubview:self.collectImageView];
    [self.payView addSubview:collectLabel];
    [self.payView addSubview:self.payButton];
    [self.view addSubview:self.payView];
}


#pragma mark - 创建CollectionView
- (void)createCollectionView
{
    
    UICollectionViewFlowLayout *flowLayout = [[ UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 3;
    flowLayout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight)collectionViewLayout:flowLayout];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODMyOrderRecordCell" bundle:nil] forCellWithReuseIdentifier:kMyOrderRecordCellId];
    
    [self.view addSubview:self.collectionView];
}





@end
