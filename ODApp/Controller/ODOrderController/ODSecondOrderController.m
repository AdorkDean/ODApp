//
//  ODSecondOrderController.m
//  ODApp
//
//  Created by zhz on 16/2/4.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODSecondOrderController.h"
#import "ODOrderCell.h"
#import "ODContactAddressController.h"
#import "AFNetworking.h"
#import "ODAPIManager.h"
#import "UIImageView+WebCache.h"
#import "ODOrderSecondHeadView.h"
#import "ODAddressModel.h"
@interface ODSecondOrderController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout , UITextViewDelegate>


@property (nonatomic ,strong) ODOrderSecondHeadView *headView;
@property (nonatomic , strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) UILabel *allPriceLabel;
@property (nonatomic ,copy) NSString *addressId;
@property (nonatomic, strong) AFHTTPRequestOperationManager *orderManager;
@property (nonatomic , copy) NSString *openId;
@property (nonatomic , strong) NSMutableArray *addressArray;
@property (nonatomic , strong) AFHTTPRequestOperationManager *addressManager;
@end

@implementation ODSecondOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    self.openId = [ODUserInformation sharedODUserInformation].openID;
    self.addressArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"提交订单";
    
      [self getAddress];
     [self createCollectionView];
    
}

- (void)getAddress
{
    self.addressManager = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *parameters = @{@"open_id":self.openId};
    NSDictionary *signParameters = [ODAPIManager signParameters:parameters];
    
    __weak typeof (self)weakSelf = self;
    [self.addressManager GET:kGetAddressUrl parameters:signParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([responseObject[@"status"] isEqualToString:@"success"]) {
            
            
            
            [weakSelf.addressArray removeAllObjects];
            
            
            NSMutableDictionary *dic = responseObject[@"result"];
            
            NSMutableDictionary *addressDic = dic[@"default"];
            
            
            if (addressDic.count != 0) {
                ODAddressModel *model = [[ODAddressModel alloc] init];
                [model setValuesForKeysWithDictionary:addressDic];
                [weakSelf.addressArray addObject:model];

            }
            
            
            
                
        
            
            
        }
        
        
        [weakSelf.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
}



#pragma mark - 初始化
-(void)createCollectionView
{
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width,kScreenSize.height - 115) collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[ODOrderSecondHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODOrderCell" bundle:nil] forCellWithReuseIdentifier:@"item"];
    [self.view addSubview:self.collectionView];
    
    
    UIImageView *amountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 56 - ODNavigationHeight, kScreenSize.width - 100, 56)];
    amountImageView.backgroundColor = [UIColor whiteColor];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 18,70, 20)];
    priceLabel.text = @"订单金额：";
    priceLabel.font = [UIFont systemFontOfSize:13];
    priceLabel.backgroundColor = [UIColor whiteColor];
    [amountImageView addSubview:priceLabel];
    
    
    self.allPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 18, amountImageView.frame.size.width - 130, 20)];
    self.allPriceLabel.text = [NSString stringWithFormat:@"%@元" , self.informationModel.price];
    self.allPriceLabel.textAlignment = NSTextAlignmentLeft;
    self.allPriceLabel.font = [UIFont systemFontOfSize:15];
    self.allPriceLabel.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    [amountImageView addSubview:self.allPriceLabel];
    [self.view addSubview:amountImageView];
    
    
    UIButton *saveOrderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveOrderButton.frame = CGRectMake(kScreenSize.width - 100, kScreenSize.height - 56 - ODNavigationHeight, 100, 56);
    saveOrderButton.backgroundColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
    [saveOrderButton setTitle:@"提交订单" forState:UIControlStateNormal];
    saveOrderButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [saveOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveOrderButton addTarget:self action:@selector(saveOrderAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveOrderButton];
    
    
    
    
}


- (void)saveOrderAction:(UIButton *)sender
{
  
    if ([self.headView.secondOrderView.addressLabel.text isEqualToString:@"联系地址"]){
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入联系地址"];
    }else{
        
        [self saveOrder];
    }
    
}



- (void)saveOrder
{
    self.orderManager = [AFHTTPRequestOperationManager manager];
    
    
      
    NSString *swap_id = [NSString stringWithFormat:@"%@" , self.informationModel.swap_id];
    
  
    NSDictionary *parameters = @{@"open_id":self.openId , @"swap_id":swap_id , @"service_time": @"" , @"user_address_id":self.addressId , @"comment": self.headView.secondOrderView.messageTextView.text};
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
    
    cell.model = self.informationModel;
    
    
    
    
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
    [self.headView.secondOrderView.addressImgeView addGestureRecognizer:addressTap];
    self.headView.secondOrderView.messageTextView.delegate = self;

    
    NSString *type = [NSString stringWithFormat:@"%@" , self.informationModel.swap_type];
    
    if ([type isEqualToString:@"1"]) {
        self.headView.secondOrderView.typeLabel.text = @"上门服务";
    }else
    {
         self.headView.secondOrderView.typeLabel.text = @"快递服务";
    }
    
    if (self.addressArray.count == 0) {
        self.headView.secondOrderView.addressLabel.text = @"联系地址";
    }else{
        ODAddressModel *model = self.addressArray[0];
        self.headView.secondOrderView.addressLabel.text = model.address;
        self.addressId = [NSString stringWithFormat:@"%@" , model.id];
        
        
    }

    
    
    return self.headView;
    
}

#pragma mark - textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.headView.secondOrderView.messageTextView) {
        if ([textView.text isEqualToString:NSLocalizedString(@"给ta留言", nil)]) {
            self.headView.secondOrderView.messageTextView.text=NSLocalizedString(@"", nil);
            self.headView.secondOrderView.messageTextView.textColor = [UIColor blackColor];
        }
        else{
            ;
        }
        
    }
}



- (void)textViewDidChange:(UITextView *)textView
{
    
    NSString *message = @"";
    
    if (textView == self.headView.secondOrderView.messageTextView)
    {
        if (textView.text.length > 20)
        {
            textView.text = [textView.text substringToIndex:20];
        }
        else
        {
            message = textView.text;
        }
    }
    
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.textColor = [UIColor lightGrayColor];
        if (textView == self.headView.secondOrderView.messageTextView) {
            textView.text=NSLocalizedString(@"给ta留言", nil);
            
            
        }
    }
}




- (void)addressAction
{
    ODContactAddressController *vc = [[ODContactAddressController alloc] init];
    
    __weakSelf
    vc.getAddressBlock = ^(NSString *address , NSString *addrssId , NSString *isAddress ){
        
        if ([isAddress isEqualToString:@"1"]) {
            weakSelf.headView.secondOrderView.addressLabel.text = @"联系地址";
            weakSelf.addressId = nil;
        }else{
            weakSelf.headView.secondOrderView.addressLabel.text = address;
            weakSelf.addressId = addrssId;

        }
        
    };
    
    vc.addressId = self.addressId;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



//动态设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(kScreenSize.width , 160);
    
    
    
}
//动态设置区头的高度(根据不同的分区)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenSize.width, 170);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}


@end
