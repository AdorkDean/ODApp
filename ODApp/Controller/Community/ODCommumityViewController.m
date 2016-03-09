//
//  ODCommumityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommumityViewController.h"

#define kCommunityCellId @"ODCommunityCollectionCell"
@interface ODCommumityViewController ()

@end

@implementation ODCommumityViewController

#pragma mark - lazyload
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenSize.width, kScreenSize.height-64-55) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        [self.collectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCommunityCellId];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableDictionary *)userInfoDic
{
    if (!_userInfoDic) {
        _userInfoDic = [[NSMutableDictionary alloc]init];
    }
    return _userInfoDic;
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    self.refresh = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
    [self joiningTogetherParmeters];
    
    __weakSelf
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationSearchCircle object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue ] usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf joiningTogetherParmeters];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    [self.collectionView.mj_header beginRefreshing];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.releaseSuccess isEqualToString:@"delSuccess"]) {
        [self.dataArray removeObjectAtIndex:self.indexPath];
        [self.collectionView reloadData];
    }else if ([self.releaseSuccess isEqualToString:@"refresh"]){
        self.bbsMark = @"全部";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
        [self.collectionView.mj_header beginRefreshing];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.refresh = NO;
    self.releaseSuccess = @"";
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.button = [ODBarButton barButtonWithTarget:self action:@selector(titleButtonClick:) title:@"社区    "];
    [self.button setImage:[UIImage imageNamed:@"jiantou_icon"] forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:ODNavigationTextFont]];
    [self.button setBarButtonType:(ODBarButtonTypeTextLeft)];
    self.navigationItem.titleView = self.button;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(searchButtonClick) image:[UIImage imageNamed:@"fangdajing_icon"] highImage:nil];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(publishButtonClick) image:[UIImage imageNamed:@"发布任务icon"] highImage:nil];

}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.bbsType = self.bbsType ? self.bbsType :5;
    self.bbsMark = self.bbsMark ? self.bbsMark :@"";
    self.count = 1;
    NSDictionary *parameter;
    if ([self.bbsMark isEqualToString:@""]||[self.bbsMark isEqualToString:@"社区"]) {
        [self.button setTitle:@"社区" forState:UIControlStateNormal];
        parameter = @{@"type":[NSString stringWithFormat:@"%i", self.bbsType], @"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID], @"search":@"", @"call_array":@"1"};
    }else if ([self.bbsMark isEqualToString:@"全部"]){
        [self.button setTitle:@"全部" forState:UIControlStateNormal];
        parameter = @{@"type":[NSString stringWithFormat:@"%i", self.bbsType], @"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID], @"search":@"", @"call_array":@"1"};
    }else{
        [self.button setTitle:self.bbsMark forState:UIControlStateNormal];
        parameter = @{@"type":[NSString stringWithFormat:@"%i", self.bbsType], @"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID], @"search":self.bbsMark, @"call_array":@"1"};
    }
    [self downLoadDataWithUrl:ODUrlBbsList paramater:parameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    __weakSelf
    [ODHttpTool getWithURL:url parameters:parameter modelClass:[ODCommunityBbsModel class] success:^(ODCommunityBbsModelResponse  *model) {
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        ODCommunityBbsModel *bbsModel = [model result];
        for (ODCommunityBbsListModel *listModel in bbsModel.bbs_list) {
            [weakSelf.dataArray addObject:listModel];
        }
        NSDictionary *users = bbsModel.users;
        for (id userKey in users) {
            NSString *key = [NSString stringWithFormat:@"%@",userKey];
            ODCommunityBbsUsersModel *userModel = [ODCommunityBbsUsersModel mj_objectWithKeyValues:users[key]];
            [weakSelf.userInfoDic setObject:userModel forKey:userKey];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

-(void)loadMoreData
{
    self.count++;
    [self joiningTogetherParmeters];
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
    ODCommunityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommunityCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    cell.model = self.dataArray[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%d",cell.model.user_id];
    [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[self.userInfoDic[userId]avatar_url]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    [cell.headButton addTarget:self action:@selector(otherInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.nickLabel.text = [self.userInfoDic[userId]nick];
    cell.signLabel.text = [self.userInfoDic[userId]sign];
    
    CGFloat width=kScreenSize.width>320?90:70;
    if (cell.model.imgs.count) {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        for (NSInteger i = 0; i < cell.model.imgs.count; i++) {
            UIButton *imageButton = [[UIButton alloc] init];
            if (cell.model.imgs.count == 4) {
                imageButton.frame = CGRectMake((width + 5) * (i % 2), (width + 5) * (i / 2), width, width);
                cell.PicConstraintHeight.constant = 2*width+5;
            }else{
                imageButton.frame = CGRectMake((width + 5) * (i % 3), (width + 5) * (i / 3), width, width);
                 cell.PicConstraintHeight.constant = width+(width+5)*(cell.model.imgs.count/3);
            }
            [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:cell.model.imgs[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                if (error) {
                    [imageButton setBackgroundImage:[UIImage imageNamed:@"errorplaceholderImage"] forState:UIControlStateNormal];
                }
            }];
            [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.tag = 10 * indexPath.row + i;
            [cell.picView addSubview:imageButton];
        }
    }else{
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        cell.PicConstraintHeight.constant = 0.5;
    }
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

#pragma mark - UIPopDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - UICollectionDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc]init];
    detailController.myBlock = ^(NSString *refresh){
        self.releaseSuccess = refresh;
    };
    self.indexPath = indexPath.row;
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%d",model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}

//动态计算cell的高度
- (CGFloat)returnHight:(ODCommunityBbsListModel *)model {
    CGFloat width = kScreenSize.width > 320 ? 90 : 70;
    NSString *content = model.content;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:10.5]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width-20, 35) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
    CGFloat baseHeight = size.height + 93;
    if (model.imgs.count == 0) {
        return baseHeight+0.5;
    } else if (model.imgs.count > 0 && model.imgs.count < 4) {
        return baseHeight + width;
    } else if (model.imgs.count >= 4 && model.imgs.count < 7) {
        return baseHeight + 2 * width + 5;
    } else if (model.imgs.count >= 7 && model.imgs.count < 9) {
        return baseHeight + 3 * width + 10;
    } else {
        return baseHeight + 3 * width + 10;
    }
}


#pragma mark - action
-(void)titleButtonClick:(UIButton *)button
{
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view.backgroundColor = [UIColor colorWithHexString:@"#ffd802" alpha:1];
    controller.view.layer.borderColor = [UIColor colorWithHexString:@"#000000" alpha:1].CGColor;
    controller.view.layer.borderWidth = 1;
    controller.view.layer.cornerRadius = 10;
    
    NSArray *array = @[@"情感",@"搞笑",@"影视",@"二次元",@"生活",@"明星",@"爱美",@"宠物",@"全部"];
    for (NSInteger i = 0 ; i < array.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setFrame:CGRectMake(0, 30*i, 110, 29)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleViewLabelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [controller.view addSubview:button];
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(button.frame)+0.5, 80, 0.5)];
        lineImage.image = [UIImage imageNamed:@"shequxuxian_icon"];
        [controller.view addSubview:lineImage];
    }
    //设置弹出模式
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.preferredContentSize = CGSizeMake(110, 270);
    UIPopoverPresentationController *popVC = controller.popoverPresentationController;
    controller.popoverPresentationController.sourceView = button;
    controller.popoverPresentationController.sourceRect = button.bounds;
    popVC.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popVC.delegate = self;
    
    [self presentViewController:controller animated:YES completion:^{
    }];
}

-(void)titleViewLabelButtonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"情感"]) {
        self.bbsMark = @"情感";
    }else if ([button.titleLabel.text isEqualToString:@"搞笑"]){
        self.bbsMark = @"搞笑";
    }else if ([button.titleLabel.text isEqualToString:@"影视"]){
        self.bbsMark = @"影视";
    }else if ([button.titleLabel.text isEqualToString:@"二次元"]){
        self.bbsMark = @"二次元";
    }else if ([button.titleLabel.text isEqualToString:@"生活"]){
        self.bbsMark = @"生活";
    }else if ([button.titleLabel.text isEqualToString:@"明星"]){
        [self.button setTitle:@"明星" forState:UIControlStateNormal];
        self.bbsMark = @"明星";
    }else if ([button.titleLabel.text isEqualToString:@"爱美"]){
        self.bbsMark = @"爱美";
    }else if ([button.titleLabel.text isEqualToString:@"宠物"]){
        self.bbsMark = @"宠物";
    }else if ([button.titleLabel.text isEqualToString:@"全部"]){
        self.bbsMark = @"全部";
    }
    self.bbsType = 5;
    [self joiningTogetherParmeters];
    [self.collectionView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

-(void)searchButtonClick
{
    ODCommunityKeyWordSearchViewController *keyWordSearch = [[ODCommunityKeyWordSearchViewController alloc]init];
    [self.navigationController pushViewController:keyWordSearch animated:YES];
}

-(void)publishButtonClick
{
    __weakSelf
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    }else{
        ODCommunityReleaseTopicViewController *releaseTopic = [[ODCommunityReleaseTopicViewController alloc]init];
        releaseTopic.myBlock = ^(NSString *refresh){
            weakSelf.releaseSuccess = refresh;
        };
        [self.navigationController pushViewController:releaseTopic animated:YES];
    }
}
-(void)imageButtonClick:(UIButton *)button
{
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODCommunityModel *model = self.dataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc]init];
    picController.photos = model.imgs_big;
    picController.selectedIndex = button.tag-10*indexPath.row;
    [self presentViewController:picController animated:YES completion:nil];
}

- (void)otherInformationClick:(UIButton *)button
{
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%d",model.user_id];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = [self.userInfoDic[userId]open_id];
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:[self.userInfoDic[userId]open_id]]) {
    }else{
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
