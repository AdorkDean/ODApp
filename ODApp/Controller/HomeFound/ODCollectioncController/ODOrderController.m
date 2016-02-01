//
//  ODOrderController.m
//  ODApp
//
//  Created by zhz on 16/1/31.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODOrderController.h"
#import "ODOrderCell.h"
#import "ODContactAddressController.h"
#import "ODOrderHeadView.h"
#import "ODOrderDataModel.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "DataButton.h"
@interface ODOrderController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UIButton *selectedButton;

@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UILabel *allPriceLabel;
@property (nonatomic ,strong) ODOrderHeadView *headView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic , strong) UIView *choseTimeView;
@property (nonatomic , strong) UIScrollView *scroller;

@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *selectDataArray;


@end

@implementation ODOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getData];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectDataArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"提交订单";
    [self createCollectionView];
}


- (void)getData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"swap_id":@"1827"};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    NSString *url = @"http://woquapi.test.odong.com/1.0/swap/service/time";
    
    [self.manager GET:url parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if (responseObject) {
            NSMutableDictionary *dic = responseObject[@"result"];
            
            
            for (NSMutableDictionary *miniDic in dic) {
                ODOrderDataModel *model = [[ODOrderDataModel alloc] initWithDict:miniDic];
                [self.dataArray addObject:model];
            }
            
            
        }
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
        
        
        
        
    }];
    
    
}


#pragma mark - 初始化
-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width,KControllerHeight - 50) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ODOrderHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODOrderCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
    
    
    UIImageView *amountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 50, kScreenSize.width - 100, 50)];
    amountImageView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,90, 30)];
    priceLabel.text = @"订单金额：";
    priceLabel.backgroundColor = [UIColor whiteColor];
    [amountImageView addSubview:priceLabel];
    
    
    self.allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, amountImageView.frame.size.width - 110, 30)];
    self.allPriceLabel.text = @"10元";
    self.allPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.allPriceLabel.textColor = [UIColor redColor];
    [amountImageView addSubview:self.allPriceLabel];
    [self.view addSubview:amountImageView];
    
    
    
    
    
    UIButton *saveOrderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveOrderButton.frame = CGRectMake(kScreenSize.width - 100, kScreenSize.height - 50, 100, 50);
    saveOrderButton.backgroundColor = [UIColor redColor];
    [saveOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [saveOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:saveOrderButton];
    
    
    
    
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    
    
    
    
    return cell;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
    self.headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressAction)];
    [self.headView.orderView.addressImgeView addGestureRecognizer:addressTap];
    
    
    UITapGestureRecognizer *timeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeAction)];
    [self.headView.orderView.choseTimeView addGestureRecognizer:timeTap];
    
    return self.headView;
    
}




//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , 200);
    
    
    
}
//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenSize.width, 200);
    
}

- (void)timeAction
{
    self.choseTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenSize.height / 2, kScreenSize.width,kScreenSize.height / 2)];
    self.choseTimeView.userInteractionEnabled = YES;
    self.choseTimeView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.text = @"服务时间";
    titleLabel.textColor = [UIColor blackColor];
    [self.choseTimeView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 20)];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = @"(该时间将影响订单自动确认时间)";
    contentLabel.textColor = [UIColor lightGrayColor];
    [self.choseTimeView addSubview:contentLabel];
    
    
    self.scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30,  self.choseTimeView.frame.size.width, 50)];
    self.scroller.backgroundColor = [UIColor whiteColor];
    self.scroller.userInteractionEnabled = YES;
    self.scroller.showsHorizontalScrollIndicator = NO;
    self.scroller.contentSize = CGSizeMake(self.scroller.frame.size.width * 2.35, 50);
    [self.choseTimeView addSubview:self.scroller];
    
    
    for (int i = 0; i < 7; i++) {
        DataButton *button = [[DataButton alloc] initWithFrame: CGRectMake(5 + i * self.scroller.frame.size.width / 3, 5 , self.scroller.frame.size.width / 3 - 10, 40)];
        if (i == 0) {
            button.layer.borderColor = [UIColor orangeColor].CGColor;
        }else{
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
        
        
        ODOrderDataModel *model = self.dataArray[i];
        button.tag = i + 7;
        [button addTarget:self action:@selector(timeAction:) forControlEvents:UIControlEventTouchUpInside];
        button.dataLabel.text = [NSString stringWithFormat:@"%@" ,model.date];
        button.timeLabel.text = [NSString stringWithFormat:@"%@" ,model.date_name];
        
        [self.scroller addSubview:button];
        
    }
    
    
    
    [self createButtonWithNumber:0];
    
    
    
    [self.view addSubview:self.choseTimeView];
}


- (void)timeAction:(DataButton *)sender
{
    
    for (NSInteger i = 0; i < 7; i++) {
        DataButton *button = [self.scroller viewWithTag:i+7];
        if (sender.tag != button.tag) {
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.dataLabel.textColor = [UIColor lightGrayColor];
            button.timeLabel.textColor = [UIColor lightGrayColor];
            
        }else{
            button.layer.borderColor = [UIColor orangeColor].CGColor;
            button.dataLabel.textColor = [UIColor orangeColor];
            button.timeLabel.textColor = [UIColor orangeColor];
        }
    }
    
    
    
    [self createButtonWithNumber:sender.tag - 7];
    
    
}



- (void)createButtonWithNumber:(NSInteger)number
{
    
    ODOrderDataModel *model = self.dataArray[number];
    NSMutableArray *timeArray = model.times;
    self.selectDataArray = model.times;
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i *  self.choseTimeView.frame.size.width / 4, 90,  self.choseTimeView.frame.size.width / 4, ( self.choseTimeView.frame.size.height - 80) / 4);
        button.backgroundColor = [UIColor whiteColor];
        
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 0;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        
        button.tag = 888 + i;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableDictionary *dic = timeArray[i];
        NSString *status = [NSString stringWithFormat:@"%@" , dic[@"status"]];
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor lightGrayColor];
        }
        [button setTitle:[NSString stringWithFormat:@"%@" ,dic[@"time"]] forState:UIControlStateNormal];
        [ self.choseTimeView addSubview:button];
    }
    
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i *  self.choseTimeView.frame.size.width / 4, 90 + ( self.choseTimeView.frame.size.height - 80) / 4,  self.choseTimeView.frame.size.width / 4, ( self.choseTimeView.frame.size.height - 80) / 4);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 0;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        button.tag = 888 + i + 4;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *dic = timeArray[i + 4];
        NSString *status = [NSString stringWithFormat:@"%@" , dic[@"status"]];
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor lightGrayColor];
        }
        
        [button setTitle:[NSString stringWithFormat:@"%@" ,dic[@"time"]] forState:UIControlStateNormal];
        [ self.choseTimeView addSubview:button];
    }
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i *  self.choseTimeView.frame.size.width / 4, 90 + 2 *( self.choseTimeView.frame.size.height - 80) / 4,  self.choseTimeView.frame.size.width / 4, ( self.choseTimeView.frame.size.height - 80) / 4);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 0;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        button.tag = 888 + i + 8;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *dic = timeArray[i + 8];
        NSString *status = [NSString stringWithFormat:@"%@" , dic[@"status"]];
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor lightGrayColor];
        }
        [button setTitle:[NSString stringWithFormat:@"%@" ,dic[@"time"]] forState:UIControlStateNormal];
        [ self.choseTimeView addSubview:button];
    }
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(i *  self.choseTimeView.frame.size.width / 4, 90 + 3 *( self.choseTimeView.frame.size.height - 80) / 4,  self.choseTimeView.frame.size.width / 4, ( self.choseTimeView.frame.size.height - 80) / 4);
        button.backgroundColor = [UIColor whiteColor];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 0;
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        button.tag = 888 + i + 12;
        [button addTarget:self action:@selector(ChosetimeAction:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableDictionary *dic = timeArray[i + 12];
        NSString *status = [NSString stringWithFormat:@"%@" , dic[@"status"]];
        if (![status isEqualToString:@"1"]) {
            button.userInteractionEnabled = NO;
            button.backgroundColor = [UIColor lightGrayColor];
        }
        [button setTitle:[NSString stringWithFormat:@"%@" ,dic[@"time"]] forState:UIControlStateNormal];
        
        [ self.choseTimeView addSubview:button];
    }
    
}


- (void)ChosetimeAction:(UIButton *)sender
{
    [self.choseTimeView removeFromSuperview];
    NSMutableDictionary *dic = self.selectDataArray[sender.tag - 888];
    self.headView.orderView.timeLabel.text = dic[@"request"];
    
}

- (void)addressAction
{
    ODContactAddressController *vc = [[ODContactAddressController alloc] init];
    
    __weakSelf
    vc.getAddressBlock = ^(NSString *address){
        
        weakSelf.headView.orderView.addressLabel.text = address;
        
    };
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
