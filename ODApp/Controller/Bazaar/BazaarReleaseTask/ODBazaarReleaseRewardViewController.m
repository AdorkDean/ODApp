//
//  ODBazaarReleaseRewardViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODBazaarReleaseRewardViewController.h"

@interface ODBazaarReleaseRewardViewController ()

@end

@implementation ODBazaarReleaseRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
    self.navigationItem.title = @"任务奖励";
    [self createRequest];
    [self joiningTogetherParmeters];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    //返回按钮
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    //确认按钮
    UIButton *confirmButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width - 35 - 17.5, 16,35, 44) target:self sel:@selector(confirmButtonClick:) tag:0 image:nil title:@"确认" font:16];
    [confirmButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];

    [self.headView addSubview:confirmButton];
    
    UIView *view = [ODClassMethod creatViewWithFrame:CGRectMake(4, 68, kScreenSize.width-8, 40) tag:0 color:@"#ffffff"];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    [self.view addSubview:view];
    self.textField = [ODClassMethod creatTextFieldWithFrame:CGRectMake(8,0, kScreenSize.width-16, 40) placeHolder:@"请输入任务奖励" delegate:self tag:0];
    [view addSubview:self.textField];
    
}

-(void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmButtonClick:(UIButton *)button
{
    if (self.taskRewardBlock) {
        self.taskRewardBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
    self.idArray = [[NSMutableArray alloc]init];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter = @{};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarReleaseRewardUrl parameter:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            NSArray *task_reward = result[@"task_reward"];
            for (NSDictionary *itemDict in task_reward) {
                NSString *name = itemDict[@"name"];
                NSString *id = [NSString stringWithFormat:@"%@",itemDict[@"id"]];
                [weakSelf.dataArray addObject:name];
                [weakSelf.idArray addObject:id];
            }
            [weakSelf createCollectionView];
            [weakSelf.collectionView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}


#pragma mark - 创建tableView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(4,112, kScreenSize.width-8, kScreenSize.height-112) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.layer.cornerRadius = 5;
    self.collectionView.layer.borderWidth = 1;
    self.collectionView.layer.borderColor = [UIColor colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarRewardCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarRewardCellId];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarRewardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarRewardCellId forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row==0) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenSize.width-40, 15,20, 20)];
        self.imageView.image = [UIImage imageNamed:@"时间下拉箭头"];
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, 40);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.textField.text = self.dataArray[indexPath.row];
    ODBazaarRewardCollectionCell *cell = (ODBazaarRewardCollectionCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    self.count = indexPath.row;
    [cell addSubview:self.imageView];

}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }

    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 30) {
            return NO;
    }
    return YES;
}


@end
