//
//  ODBazaarReleaseRewardViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarReleaseRewardViewController.h"

@interface ODBazaarReleaseRewardViewController ()

@end

@implementation ODBazaarReleaseRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"任务奖励";
    [self navigationInit];
    [self initjiangliView];
    [self createRequest];
    [self navigationInit];
    [self joiningTogetherParmeters];

}

- (void)initjiangliView {
    UIView *view = [ODClassMethod creatViewWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 40) tag:0 color:@"#ffffff"];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    [self.view addSubview:view];
    self.textField = [ODClassMethod creatTextFieldWithFrame:CGRectMake(8, 0, kScreenSize.width - 16, 40) placeHolder:@"请输入任务奖励" delegate:self tag:0];
    self.textField.font = [UIFont systemFontOfSize:13];
    [view addSubview:self.textField];

}

#pragma mark - 初始化导航

- (void)navigationInit {
    self.navigationItem.title = @"任务奖励";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick:) color:nil highColor:nil title:@"确认"];
}

- (void)confirmButtonClick:(UIButton *)button {
    if (self.taskRewardBlock) {
        self.taskRewardBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化manager

- (void)createRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc] init];
    self.idArray = [[NSMutableArray alloc] init];
}

#pragma mark - 拼接参数

- (void)joiningTogetherParmeters {
    NSDictionary *parameter = @{};
//    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:ODUrlRequestHelpReward parameter:parameter];
}

#pragma mark - 请求数据

- (void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter {
    __weak typeof(self) weakSelf = self;
//    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
//        if (responseObject) {
//            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//            NSDictionary *result = dict[@"result"];
//            NSArray *task_reward = result[@"task_reward"];
//            for (NSDictionary *itemDict in task_reward) {
//                NSString *name = itemDict[@"name"];
//                NSString *id = [NSString stringWithFormat:@"%@", itemDict[@"id"]];
//                [weakSelf.dataArray addObject:name];
//                [weakSelf.idArray addObject:id];
//            }
//            [weakSelf createCollectionView];
//            [weakSelf.collectionView reloadData];
//
//        }
//    }         failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
//
//    }];
    
    [ODHttpTool getWithURL:url parameters:parameter modelClass:[ODBazaarRequestHelpRewardModel class] success:^(ODBazaarRequestHelpRewardModelResponse *model) {
    

        ODBazaarRequestHelpRewardModel *rewardModel = [model result];
        for (ODBazaarRequestHelpTask_rewardModel *task_rewardModel in rewardModel.task_reward) {
            NSString *name = task_rewardModel.name;
            NSString *id = [NSString stringWithFormat:@"%d",task_rewardModel.id];
            [weakSelf.dataArray addObject:name];
            [weakSelf.idArray addObject:id];
        }
        [weakSelf createCollectionView];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - 创建tableView

- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(4, 48, kScreenSize.width - 8, kScreenSize.height - 112) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.layer.masksToBounds = YES;
    self.collectionView.layer.cornerRadius = 5;
    self.collectionView.layer.borderWidth = 1;
    self.collectionView.layer.borderColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1].CGColor;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarRewardCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarRewardCellId];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarRewardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarRewardCellId forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    if (indexPath.row == 0) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 32.5, 18.3, 15, 8.4)];
        self.imageView.image = [UIImage imageNamed:@"时间下拉箭头"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, 45.5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.textField.text = self.dataArray[indexPath.row];
    ODBazaarRewardCollectionCell *cell = (ODBazaarRewardCollectionCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
    self.count = indexPath.row;
    [cell addSubview:self.imageView];

}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
