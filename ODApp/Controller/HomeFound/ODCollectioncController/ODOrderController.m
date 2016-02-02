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
#import "UIImageView+WebCache.h"

@interface ODOrderController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UITextViewDelegate>

@property(nonatomic,strong)UIButton *selectedButton;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UILabel *allPriceLabel;
@property (nonatomic ,strong) ODOrderHeadView *headView;
@property (nonatomic, strong) AFHTTPRequestOperationManager *orderManager;
@property (nonatomic , strong) UIView *choseTimeView;
@property (nonatomic , strong) UIScrollView *scroller;
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (nonatomic , strong) NSMutableArray *selectDataArray;
@property (nonatomic , copy) NSString *openId;
@property (nonatomic ,copy) NSString *addressId;

@end

@implementation ODOrderController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.openId = [ODUserInformation sharedODUserInformation].openID;
    
    
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
    
 
    
    [self.manager GET:kGetServecTimeUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
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
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width,KControllerHeight - 110) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ODOrderHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODOrderCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
    
    
    UIImageView *amountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 50 - ODNavigationHeight, kScreenSize.width - 100, 50)];
    amountImageView.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10,90, 30)];
    priceLabel.text = @"订单金额：";
    priceLabel.backgroundColor = [UIColor whiteColor];
    [amountImageView addSubview:priceLabel];
    
    
    self.allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, amountImageView.frame.size.width - 110, 30)];
    self.allPriceLabel.text = [NSString stringWithFormat:@"%@元" , self.informationModel.price];
    self.allPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.allPriceLabel.textColor = [UIColor redColor];
    [amountImageView addSubview:self.allPriceLabel];
    [self.view addSubview:amountImageView];
    
    
    
    
    
    UIButton *saveOrderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveOrderButton.frame = CGRectMake(kScreenSize.width - 100, kScreenSize.height - 50 - ODNavigationHeight, 100, 50);
    saveOrderButton.backgroundColor = [UIColor redColor];
    [saveOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [saveOrderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveOrderButton addTarget:self action:@selector(saveOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveOrderButton];
    
    
    
    
}


- (void)saveOrderAction:(UIButton *)sender
{
    if ([self.headView.orderView.timeLabel.text isEqualToString:@"服务时间"]) {
         [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入服务时间"];
    }else if ([self.headView.orderView.addressLabel.text isEqualToString:@"联系地址"]){
         [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入联系地址"];
    }else{
        
         [self saveOrder];
    }
   
}


- (void)saveOrder
{
    self.orderManager = [AFHTTPRequestOperationManager manager];
    
    NSString *swap_id = [NSString stringWithFormat:@"%@" , self.informationModel.swap_id];
    
    
    NSDictionary *parameters = @{@"open_id":self.openId , @"swap_id":swap_id , @"service_time": self.headView.orderView.timeLabel.text , @"user_address_id":self.addressId , @"comment":self.headView.orderView.messageTextView.text};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
       __weak typeof (self)weakSelf = self;
    [self.orderManager GET:kSaveOrderUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
          [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"提交订单成功"];
        }else if ([responseObject[@"status"] isEqualToString:@"error"]) {
            
            [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:responseObject[@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];

}


#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODOrderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item" forIndexPath:indexPath];
    
    
 
    [cell.userImgeView sd_setImageWithURL:[NSURL OD_URLWithString:self.informationModel.user[@"avatar"]]];
    cell.nickLabel.text = self.informationModel.user[@"nick"];
    cell.orderTitle.text = self.informationModel.title;
    cell.orderPrice.text = [NSString stringWithFormat:@"%@元/%@" , self.informationModel.price , self.informationModel.unit];
    NSString *url = self.informationModel.imgs_small[0][@"img_url"];
    [cell.orderImageView sd_setImageWithURL:[NSURL OD_URLWithString:url]];
    
    
    
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
    
    
    self.headView.orderView.messageTextView.delegate = self;
    
    
    return self.headView;
    
}


#pragma mark - textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.headView.orderView.messageTextView) {
        if ([textView.text isEqualToString:NSLocalizedString(@"给他留言", nil)]) {
            self.headView.orderView.messageTextView.text=NSLocalizedString(@"", nil);
             self.headView.orderView.messageTextView.textColor = [UIColor blackColor];
        }
        else{
            ;
        }
        
    }
}

NSString *message = @"";

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.headView.orderView.messageTextView)
    {
        if (textView.text.length > 20)
        {
            textView.text = message;
        }
        else
        {
            message = textView.text;
        }
    }
  
}




-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView == self.headView.orderView.messageTextView) {
        
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder];
            return NO;
            
        }
    }
    
    
    return YES;
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.textColor = [UIColor lightGrayColor];
        if (textView == self.headView.orderView.messageTextView) {
            textView.text=NSLocalizedString(@"给他留言", nil);
            
        
        }
    }
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
    self.choseTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight / 2 - ODNavigationHeight, kScreenSize.width,KScreenHeight / 2)];
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
    vc.getAddressBlock = ^(NSString *address , NSString *addrssId){
        
        weakSelf.headView.orderView.addressLabel.text = address;
        weakSelf.addressId = addrssId;
    };
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
