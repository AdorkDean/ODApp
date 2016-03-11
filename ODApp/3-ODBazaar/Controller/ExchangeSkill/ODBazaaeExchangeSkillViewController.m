//
//  ODBazaaeExchangeSkillViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/1.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODBazaaeExchangeSkillViewController.h"

#define cellID @"ODBazaarExchangeSkillCollectionCell"

@interface ODBazaaeExchangeSkillViewController ()

@end

@implementation ODBazaaeExchangeSkillViewController

#pragma mark - lazyLoad
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 64 - 40 - 55) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        [_collectionView registerNib:[UINib nibWithNibName:@"ODBazaarExchangeSkillCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.page = 1;
    [self requestData];
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [weakSelf requestData];
    }];

    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationReleaseSkill object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:ODNotificationLocationSuccessRefresh object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *_Nonnull note) {
        [weakSelf.collectionView.mj_header beginRefreshing];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据请求
-(void)requestData
{
    NSDictionary *parameter = @{@"page" : [NSString stringWithFormat:@"%ld", self.page], @"my":@"0"};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapList parameters:parameter modelClass:[ODBazaarExchangeSkillModel class] success:^(ODBazaarExchangeSkillModelResponse *model) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        NSArray *array = [model result];
        [weakSelf.dataArray addObjectsFromArray:array];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    self.page++;
    [self requestData];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    cell.model = self.dataArray[indexPath.row];
    [cell.headButton addTarget:self action:@selector(otherInfoClick:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat width = kScreenSize.width > 320 ? 90 : 70;
    if (cell.model.imgs_small.count) {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        for (NSInteger i = 0; i < cell.model.imgs_small.count; i++) {
            ODBazaarExchangeSkillImgs_smallModel *smallModel = cell.model.imgs_small[i];
            UIButton *imageButton = [[UIButton alloc] init];
            if (cell.model.imgs_small.count == 4) {
                imageButton.frame = CGRectMake((width + 5) * (i % 2), (width + 5) * (i / 2), width, width);
                cell.picViewConstraintHeight.constant = 2 * width + 5;
            }else{
                imageButton.frame = CGRectMake((width + 5) * (i % 3), (width + 5) * (i / 3), width, width);
                cell.picViewConstraintHeight.constant = width + (width + 5) * ((cell.model.imgs_small.count - 1) / 3);
            }
            [imageButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:smallModel.img_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                if (error) {
                    [imageButton setBackgroundImage:[UIImage imageNamed:@"errorplaceholderImage"] forState:UIControlStateNormal];
                }
            }];
            [imageButton addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            imageButton.tag = 10 * indexPath.row + i;
            [cell.picView addSubview:imageButton];
        }
    }
    else {
        for (id vc in cell.picView.subviews) {
            [vc removeFromSuperview];
        }
        cell.picViewConstraintHeight.constant = 0;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODBazaarExchangeSkillDetailViewController *detailControler = [[ODBazaarExchangeSkillDetailViewController alloc] init];
    detailControler.swap_id = [NSString stringWithFormat:@"%d", model.swap_id];
    detailControler.nick = model.user[@"nick"];
    [self.navigationController pushViewController:detailControler animated:YES];
}

#pragma mark - action
- (void)imageButtonClicked:(UIButton *)button {
    ODBazaarExchangeSkillCollectionCell *cell = (ODBazaarExchangeSkillCollectionCell *) button.superview.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODCommunityShowPicViewController *picController = [[ODCommunityShowPicViewController alloc] init];
    picController.photos = model.imgs_big;
    picController.selectedIndex = button.tag - 10 * indexPath.row;
    picController.skill = @"skill";
    [self.navigationController presentViewController:picController animated:YES completion:nil];
}

- (void)otherInfoClick:(UIButton *)button {
    ODBazaarExchangeSkillCollectionCell *cell = (ODBazaarExchangeSkillCollectionCell *) button.superview.superview;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ODBazaarExchangeSkillModel *model = self.dataArray[indexPath.row];
    ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
    vc.open_id = model.user[@"open_id"];
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:model.user[@"open_id"]]) {
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//动态计算cell的高度
- (CGFloat)returnHight:(ODBazaarExchangeSkillModel *)model {
    CGFloat width = kScreenSize.width > 320 ? 90 : 70;
    NSString *content = model.content;
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:11]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width - 93, 30) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
    CGFloat baseHeight = size.height + 121;
    if (model.imgs_small.count == 0) {
        return baseHeight;
    } else if (model.imgs_small.count > 0 && model.imgs_small.count < 4) {
        return baseHeight + width;
    } else if (model.imgs_small.count >= 4 && model.imgs_small.count < 7) {
        return baseHeight + 2 * width + 5;
    } else if (model.imgs_small.count >= 7 && model.imgs_small.count < 9) {
        return baseHeight + 3 * width + 10;
    } else {
        return baseHeight + 3 * width + 10;
    }
}


@end
