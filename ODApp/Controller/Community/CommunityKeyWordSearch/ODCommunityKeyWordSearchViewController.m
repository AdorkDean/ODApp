//
//  ODCommunityKeyWordSearchViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityKeyWordSearchViewController.h"

@interface ODCommunityKeyWordSearchViewController ()
{
    NSMutableDictionary *userInfoDic;
}
@end

@implementation ODCommunityKeyWordSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
  
    [self navigationInit];
    [self createRequest];
    [self createSearchBar];
    [self createCollectionView];
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.searchBar.text.length>0) {
            
            [weakSelf joiningTogetherParmeters];
        }else{
            [weakSelf.collectionView.mj_header endRefreshing];
        }

    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

}

#pragma mark - 加载更多
-(void)loadMoreData
{
    if (self.searchBar.text.length>0) {
        self.count ++;
        NSDictionary *parameter = @{@"kw":self.searchBar.text,@"suggest":@"0",@"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":@"0",@"call_array":@"1"};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [self downLoadDataWithUrl:kCommunityBbsSearchUrl paramater:signParameter];
    }else{
        [self.collectionView.mj_footer endRefreshing];
    }
 
}

-(void)cancelButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化导航
-(void)navigationInit
{    
    self.navigationItem.title = @"欧动社区";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(cancelButtonClick) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"取消"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"确认"];}

-(void)confirmButtonClick
{
    [self.searchBar resignFirstResponder];
    
    if (self.searchBar.text.length>0) {
        
        [self joiningTogetherParmeters];
    }else{
        [self createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"请输入搜索内容"];
    }
}

#pragma mark - 创建searchBar
-(void)createSearchBar
{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 70, kScreenSize.width-20, 30)];
    [[[[ self.searchBar. subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"标签关键字";
    [self.view addSubview:self.searchBar];
//    [self.navigationItem setTitleView:self.searchBar];
}

#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self joiningTogetherParmeters];
}

#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
    self.userArray = [[NSMutableArray alloc]init];
    userInfoDic = [NSMutableDictionary dictionary];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.count = 1;
    NSDictionary *parameter = @{@"kw":self.searchBar.text,@"suggest":@"0",@"page":[NSString stringWithFormat:@"%ld",self.count],@"city_id":@"0",@"call_array":@"1"};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kCommunityBbsSearchUrl paramater:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    
    [self.searchBar resignFirstResponder];
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.noReusltLabel removeFromSuperview];
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
            
            if (weakSelf.dataArray.count == 0) {
                weakSelf.noReusltLabel = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width - 180)/2, kScreenSize.height/2, 180, 30) text:@"没有符合条件的话题" font:16 alignment:@"center" color:@"#000000" alpha:1];
                [weakSelf.view addSubview:weakSelf.noReusltLabel];
            }
            
            if (bbs_list.count == 0) {
                [weakSelf.collectionView.footer noticeNoMoreData];
            }
            
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf createProgressHUDWithAlpha:0.6f withAfterDelay:0.8f title:@"网络异常"];
    }];
}


#pragma mark - 创建collectionView
-(void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,106, kScreenSize.width, kScreenSize.height - 106) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];
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
    [cell.headButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[userInfoDic[userId]avatar_url] ] forState:UIControlStateNormal];
    cell.nickLabel.text = [userInfoDic[userId]nick];
    cell.signLabel.text = [userInfoDic[userId]sign];
    [cell showDateWithModel:model];
    CGFloat height = [ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14];
    cell.contentLabelHeight.constant = height;
    if (model.imgs.count) {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        if (model.imgs.count==4) {
            for (NSInteger i = 0; i < model.imgs.count; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((90+5)*(i%2), (90+5)*(i/2), 90, 90)];
                [imageView sd_setImageWithURL:[NSURL OD_URLWithString:model.imgs[i]]];
                [cell.picView addSubview:imageView];
            }
            cell.PicConstraintHeight.constant = 195;
        }else{
            for (NSInteger i = 0;i < model.imgs.count ; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((90+5)*(i%3), (90+5)*(i/3), 90, 90)];
                [imageView sd_setImageWithURL:[NSURL OD_URLWithString:model.imgs[i]]];
                [cell.picView addSubview:imageView];
            }
            cell.PicConstraintHeight.constant = 90+(90+5)*(model.imgs.count/3);
        }
    }else{
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        cell.PicConstraintHeight.constant = 0;
    }
    return cell;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc]init];
    ODCommunityModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%@",model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}

- (void)othersInformationClick:(UIButton *)button{
    
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview;
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:cell];
    ODCommunityModel *model = self.dataArray[indexpath.row];
    NSString *userId = [NSString stringWithFormat:@"%@",model.user_id];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = [userInfoDic[userId]open_id];
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:[userInfoDic[userId]open_id]]) {
        
    }else{
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//动态计算cell的高度
-(CGFloat)returnHight:(ODCommunityModel *)model
{
    if (model.imgs.count==0) {
        return 100+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14];
    }else if (model.imgs.count>0&&model.imgs.count<4){
        return 100+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14]+90;
    }else if (model.imgs.count>=4&&model.imgs.count<7){
        return 100+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14]+185;
    }else if (model.imgs.count>=7&&model.imgs.count<9){
        return 100+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14]+280;
    }else{
        return 100+[ODHelp textHeightFromTextString:model.content width:kScreenSize.width-20 fontSize:14]+280;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
