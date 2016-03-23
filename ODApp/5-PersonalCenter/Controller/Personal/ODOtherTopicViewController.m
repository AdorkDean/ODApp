//
//  ODOtherTopicViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODOtherTopicViewController.h"

#define kCommunityCellId @"ODCommunityCollectionCell"
@interface ODOtherTopicViewController ()
{
    NSMutableDictionary *userInfoDic;
}
@end

@implementation ODOtherTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.count = 1;
    self.navigationItem.title = @"他发表的话题";
    [self createRequest];
    [self joiningTogetherParmeters];
    [self createCollectionView];
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf joiningTogetherParmeters];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

}

#pragma mark - 加载更多
-(void)loadMoreData
{
    self.count ++;
    NSDictionary *parameter = @{@"type":@"1",
                                @"page":[NSString stringWithFormat:@"%ld",(long)self.count],
                                @"open_id":self.open_id,
                                @"call_array":@"1"};
    [self downLoadDataWithUrl:ODUrlBbsList paramater:parameter];
}


#pragma mark - 初始化manager
-(void)createRequest
{

    self.dataArray = [[NSMutableArray alloc]init];
    self.userArray = [[NSMutableArray alloc]init];
    userInfoDic = [NSMutableDictionary dictionary];
}


#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    self.count = 1;
    NSDictionary *parameter = @{
                                @"type" : @"1",
                                @"page" : [NSString stringWithFormat:@"%ld",(long)self.count],
                                @"open_id" : self.open_id,@"call_array":@"1"
                                };
    [self downLoadDataWithUrl:ODUrlBbsList paramater:parameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)parameter
{
    
    __weakSelf
    [ODHttpTool getWithURL:url parameters:parameter modelClass:[ODCommunityBbsModel class] success:^(id model) {
        if (weakSelf.count == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        for (ODCommunityBbsListModel *bbsModel in [[model result] bbs_list]) {
            [weakSelf.dataArray addObject:bbsModel];
        }
        for (id usersKey in [[model result] users]) {
            NSString *key = [NSString stringWithFormat:@"%@", usersKey];
            ODCommunityBbsUsersModel *userModel = [ODCommunityBbsUsersModel mj_objectWithKeyValues:[[model result] users][key]];
            [userInfoDic setObject:userModel forKey:usersKey];
        }
        
        [weakSelf.collectionView.mj_header endRefreshing];
        
        ODNoResultLabel *noResultabel = [[ODNoResultLabel alloc] init];
        
        [ODHttpTool OD_endRefreshWith:weakSelf.collectionView array:[[model result] bbs_list]];
        
        if (weakSelf.dataArray.count == 0) {
            [noResultabel showOnSuperView:weakSelf.collectionView title:@"暂无话题"];
        }
        else {
            [noResultabel hidden];
        }
    } failure:^(NSError *error) {
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
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0, kScreenSize.width, kScreenSize.height-64) collectionViewLayout:flowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
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
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
    NSString *userId = [NSString stringWithFormat:@"%d",model.user_id];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [cell.headButton addTarget:self action:@selector(otherInformationClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.headButton sd_setBackgroundImageWithURL: [NSURL OD_URLWithString:[userInfoDic[userId]avatar_url] ] forState:UIControlStateNormal];
    cell.nickLabel.text = [userInfoDic[userId]nick];
    cell.signLabel.text = [userInfoDic[userId]sign];
    [cell setModel:model];
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
        cell.PicConstraintHeight.constant = 0.5;
    }
    return cell;
}

-(void)imageButtonClick:(UIButton *)button
{
    ODCommunityCollectionCell *cell = (ODCommunityCollectionCell *)button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODCommunityBbsListModel *model = self.dataArray[indexPath.row];
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


//动态计算cell的高度
-(CGFloat)returnHight:(ODCommunityBbsListModel *)model
{
    CGFloat width=kScreenSize.width>320?90:70;
    NSString *content = model.content;
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:10.5]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width-20, 30) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
    CGFloat baseHeight = size.height + 93;
    if (model.imgs.count==0) {
        return baseHeight+0.5;
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


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODCommunityDetailViewController *detailController = [[ODCommunityDetailViewController alloc]init];
    detailController.myBlock = ^(NSString *refresh){
        self.refresh = refresh;
    };
    ODCommunityBbsUsersModel *model = self.dataArray[indexPath.row];
    detailController.bbs_id = [NSString stringWithFormat:@"%d",model.id];
    [self.navigationController pushViewController:detailController animated:YES];
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
