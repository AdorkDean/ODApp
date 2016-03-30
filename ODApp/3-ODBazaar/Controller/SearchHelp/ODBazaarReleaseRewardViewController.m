//
//  ODBazaarReleaseRewardViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/1/4.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaarReleaseRewardViewController.h"

#define kBazaarRewardCellId @"ODBazaarRewardCollectionCell"

@interface ODBazaarReleaseRewardViewController ()

@end

@implementation ODBazaarReleaseRewardViewController

#pragma mark - lazyload
-(NSMutableArray *)idArray{
    if (!_idArray) {
        _idArray = [[NSMutableArray alloc]init];
    }
    return _idArray;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(UITextField *)textField{
    if (!_textField) {
        UIView *view = [ODClassMethod creatViewWithFrame:CGRectMake(4, 4, kScreenSize.width - 8, 40) tag:0 color:@"#ffffff"];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor lineColor].CGColor;
        [self.view addSubview:view];
        _textField = [ODClassMethod creatTextFieldWithFrame:CGRectMake(8, 0, kScreenSize.width - 16, 40) placeHolder:@"请输入任务奖励" delegate:self tag:0];
        _textField.font = [UIFont systemFontOfSize:13];
        [view addSubview:self.textField];
    }
    return _textField;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(4, 48, kScreenSize.width - 8, kScreenSize.height - 112) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.layer.masksToBounds = YES;
        _collectionView.layer.cornerRadius = 5;
        _collectionView.layer.borderWidth = 1;
        _collectionView.layer.borderColor = [UIColor lineColor].CGColor;
        _collectionView.backgroundColor = [UIColor backgroundColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"ODBazaarRewardCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarRewardCellId];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"任务奖励";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick:) color:nil highColor:nil title:@"确认"];
    [self textField];
    [self requestData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#pragma mark - 请求数据
- (void)requestData{
    __weakSelf;
    NSDictionary *parameter = @{};
    [ODHttpTool getWithURL:ODUrlOtherConfigInfo parameters:parameter modelClass:[ODBazaarRequestHelpRewardModel class] success:^(ODBazaarRequestHelpRewardModelResponse *model) {
        ODBazaarRequestHelpRewardModel *rewardModel = [model result];
        for (ODBazaarRequestHelpTask_rewardModel *task_rewardModel in rewardModel.task_reward) {
            NSString *name = task_rewardModel.name;
            NSString *id = [NSString stringWithFormat:@"%d",task_rewardModel.id];
            [weakSelf.dataArray addObject:name];
            [weakSelf.idArray addObject:id];
        }
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarRewardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarRewardCellId forIndexPath:indexPath];
    cell.nameLabel.text = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width - 32.5, 18.3, 15, 8.4)];
        self.imageView.image = [UIImage imageNamed:@"时间下拉箭头"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, 45.5);
}

#pragma amrk - UICollectionViewDelegate
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

#pragma mark - action
- (void)confirmButtonClick:(UIButton *)button {
    if (self.taskRewardBlock) {
        self.taskRewardBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
