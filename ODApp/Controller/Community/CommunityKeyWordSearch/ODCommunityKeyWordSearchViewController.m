//
//  ODCommunityKeyWordSearchViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCommunityKeyWordSearchViewController.h"


#define kCommunityCellId @"ODCommunityCollectionCell"

@interface ODCommunityKeyWordSearchViewController () 

@end

@implementation ODCommunityKeyWordSearchViewController

#pragma mark - lazyload
-(UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 8, kScreenSize.width - 20,30)];
        [[[[_searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
        _searchBar.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"标签关键字";
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,46, kScreenSize.width, kScreenSize.height-110) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        [self.collectionView registerNib:[UINib nibWithNibName:@"ODCommunityCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCommunityCellId];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(NSMutableDictionary *)userInfoDic{
    if (!_userInfoDic) {
        _userInfoDic = [[NSMutableDictionary alloc]init];
    }
    return _userInfoDic;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self searchBar];
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.searchBar.text.length > 0) {
            [weakSelf joiningTogetherParmeters];
        } else {
            [weakSelf.collectionView.mj_header endRefreshing];
        }
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    self.navigationItem.title = @"欧动社区";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(cancelButtonClick) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"取消"];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(confirmButtonClick) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"确认"];
}

#pragma mark - 拼接参数
- (void)joiningTogetherParmeters {
    NSDictionary *parameter = @{@"kw" : self.searchBar.text, @"suggest" : @"0", @"page" : [NSString stringWithFormat:@"%ld", self.count], @"city_id" : [NSString stringWithFormat:@"%@", [ODUserInformation sharedODUserInformation].cityID], @"call_array" : @"1"};
    [self downLoadDataWithUrl:ODUrlBbsSearch paramater:parameter];
}

#pragma mark - 请求数据
- (void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter {

    [self.searchBar resignFirstResponder];
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

- (void)loadMoreData {
    if (self.searchBar.text.length > 0) {
        self.count++;
        [self joiningTogetherParmeters];
    } else {
        [self.collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODCommunityCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCommunityCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    cell.model = self.dataArray[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%d",cell.model.user_id];
    [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[self.userInfoDic[userId]avatar_url]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"]];
    [cell.headButton addTarget:self action:@selector(othersInformationClick:) forControlEvents:UIControlEventTouchUpInside];
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc] init];
    ODCommunityModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%@", model.id];
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self joiningTogetherParmeters];
    [self.collectionView.mj_header beginRefreshing];
}

//动态计算cell的高度
- (CGFloat)returnHight:(ODCommunityModel *)model {
    CGFloat width = kScreenSize.width > 320 ? 90 : 70;
    NSString *content = model.content;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:10.5]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width-20, 30) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
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
- (void)confirmButtonClick {
   [self.searchBar resignFirstResponder];
   if (self.searchBar.text.length > 0) {
       [self joiningTogetherParmeters];
       [self.collectionView.mj_header beginRefreshing];
   } else {
       [ODProgressHUD showInfoWithStatus:@"请输入搜索内容"];
   }
}

- (void)cancelButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageButtonClick:(UIButton *)button {
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *) button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODCommunityModel *model = self.dataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc] init];
    picController.photos = model.imgs;
    picController.selectedIndex = button.tag - 10 * indexPath.row;
    [self presentViewController:picController animated:YES completion:nil];
}

- (void)othersInformationClick:(UIButton *)button {
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
