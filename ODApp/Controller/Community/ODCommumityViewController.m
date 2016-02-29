//
//  ODCommumityViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommumityViewController.h"

@interface ODCommumityViewController ()
{
    NSMutableDictionary *userInfoDic;
}
@end

@implementation ODCommumityViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    self.refresh = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self navigationInit];
    [self createRequest];
    [self createCollectionView];
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

#pragma mark - 移除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
        UIImageView *lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(button.frame)+1, 80, 1)];
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

//如果要想在iPhone上也能弹出泡泡的样式必须要实现下面协议的方法
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}
-(void)titleViewLabelButtonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"情感"]) {
        self.bbsMark = @"情感";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }else if ([button.titleLabel.text isEqualToString:@"搞笑"]){
        self.bbsMark = @"搞笑";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }else if ([button.titleLabel.text isEqualToString:@"影视"]){
        self.bbsMark = @"影视";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }else if ([button.titleLabel.text isEqualToString:@"二次元"]){
        self.bbsMark = @"二次元";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }else if ([button.titleLabel.text isEqualToString:@"生活"]){
        self.bbsMark = @"生活";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }else if ([button.titleLabel.text isEqualToString:@"明星"]){
        [self.button setTitle:@"明星" forState:UIControlStateNormal];
        self.bbsMark = @"明星";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }else if ([button.titleLabel.text isEqualToString:@"爱美"]){
        self.bbsMark = @"爱美";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }else if ([button.titleLabel.text isEqualToString:@"宠物"]){
        self.bbsMark = @"宠物";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }else if ([button.titleLabel.text isEqualToString:@"全部"]){
        self.bbsMark = @"全部";
        self.bbsType = 5;
        [self joiningTogetherParmeters];
    }

    [self.collectionView.mj_header beginRefreshing];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

#pragma mark - 加载更多
-(void)loadMoreData
{
    self.bbsType = self.bbsType ? self.bbsType : 5;
    self.bbsMark = self.bbsMark ? self.bbsMark :@"";
    
    self.count ++;
    NSDictionary *parameter;
    if ([self.bbsMark isEqualToString:@""]||[self.bbsMark isEqualToString:@"社区"]) {
        [self.button setTitle:@"社区" forState:UIControlStateNormal];
        parameter = @{@"type":[NSString stringWithFormat:@"%i", self.bbsType], @"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID], @"search":self.bbsMark, @"call_array":@"1"};
    }else if ([self.bbsMark isEqualToString:@"全部"]){
        [self.button setTitle:@"全部" forState:UIControlStateNormal];
        parameter = @{@"type":[NSString stringWithFormat:@"%i", self.bbsType], @"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID], @"search":@"", @"call_array":@"1"};
    }else{
        [self.button setTitle:self.bbsMark forState:UIControlStateNormal];
        parameter = @{@"type":[NSString stringWithFormat:@"%i", self.bbsType], @"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":[NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID], @"search":self.bbsMark, @"call_array":@"1"};
    }
    
    
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kCommunityBbsLatestUrl paramater:signParameter];
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


#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
    userInfoDic = [NSMutableDictionary dictionary];
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
  
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    NSLog(@"%@",signParameter);
    [self downLoadDataWithUrl:kCommunityBbsLatestUrl paramater:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject) {
            NSDictionary *dcit = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dcit[@"result"];
            NSDictionary *bbs_list = result[@"bbs_list"];

            for (NSDictionary *itemDict in bbs_list) {
                ODCommunityModel *model = [[ODCommunityModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
            }
            
            NSDictionary *users = result[@"users"];
            for (id userKey in users) {
                NSString *key = [NSString stringWithFormat:@"%@",userKey];
                NSDictionary *itemDict = users[key];
                ODCommunityModel *model = [[ODCommunityModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [userInfoDic setObject:model forKey:userKey];
            }

            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_header endRefreshing];
            [weakSelf.collectionView.mj_footer endRefreshing];
            
            if (bbs_list.count == 0) {
                [weakSelf.collectionView.mj_footer noticeNoMoreData];
            }
        }
        
        NSLog(@"%@",operation);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
//        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - 创建collectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenSize.width, kScreenSize.height-64-55) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCommunityCellId];
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
    ODCommunityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommunityCellId forIndexPath:indexPath];
    ODCommunityModel *model = self.dataArray[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [cell.headButton addTarget:self action:@selector(otherInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[userInfoDic[userId]avatar_url]] forState:UIControlStateNormal];
    cell.nickLabel.text = [userInfoDic[userId]nick];
    cell.signLabel.text = [userInfoDic[userId]sign];
    [cell showDateWithModel:model];
    CGFloat width=kScreenSize.width>320?90:70;
    if (model.imgs.count) {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        if (model.imgs.count==4) {
            for (NSInteger i = 0; i < model.imgs.count; i++) {
                UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%2), (width+5)*(i/2), width, width)];
                [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.imgs[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error){
                        [imageButton setBackgroundImage:[UIImage imageNamed:@"errorplaceholderImage"] forState:UIControlStateNormal];
                    }
                }];
                [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.tag = 10*indexPath.row+i;
                [cell.picView addSubview:imageButton];
            }
            cell.PicConstraintHeight.constant = 2*width+5;
        }else{
            for (NSInteger i = 0;i < model.imgs.count ; i++) {
                UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake((width+5)*(i%3), (width+5)*(i/3), width, width)];
                [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.imgs[i]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error){
                        [imageButton setBackgroundImage:[UIImage imageNamed:@"errorplaceholderImage"] forState:UIControlStateNormal];
                    }
                }];
                [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                imageButton.tag = 10*indexPath.row+i;
                [cell.picView addSubview:imageButton];
            }
            cell.PicConstraintHeight.constant = width+(width+5)*(model.imgs.count/3);
        }
    }else{
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        cell.PicConstraintHeight.constant = 0;
    }
    
    return cell;

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
    ODCommunityModel *model = self.dataArray[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = [userInfoDic[userId]open_id];
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:[userInfoDic[userId]open_id]]) {
        
    }else{
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc]init];
    detailController.myBlock = ^(NSString *refresh){
        self.releaseSuccess = refresh;
    };
    self.indexPath = indexPath.row;
    ODCommunityModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%@",model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}

//动态计算cell的高度
-(CGFloat)returnHight:(ODCommunityModel *)model
{
    CGFloat width=kScreenSize.width>320?90:70;
    NSString *content = model.content;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width-20, 35) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
    CGFloat baseHeight = size.height + 93;
    if (model.imgs.count==0) {
        return baseHeight;
    }else if (model.imgs.count>0&&model.imgs.count<4){
        return baseHeight+width;
    }else if (model.imgs.count>=4&&model.imgs.count<7){
        return baseHeight+2*width+5;
    }else if (model.imgs.count>=7&&model.imgs.count<9){
        return baseHeight+3*width+10;
    }else{
        return baseHeight+3*width+10;
    }
}


#pragma mark - 试图将要出现
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

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    self.refresh = NO;
    self.releaseSuccess = @"";
    [super viewWillDisappear:animated];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
