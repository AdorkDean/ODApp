//
//  ODPersonalCenterCollectionController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/18.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODPersonalCenterCollectionController.h"

#define cellID @"ODBazaarExchangeSkillCollectionCell"

@interface ODPersonalCenterCollectionController ()

@property(nonatomic, strong) UILabel *noReusltLabel;

@end

@implementation ODPersonalCenterCollectionController

#pragma mark - lazyLoad
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing = 5;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height - 64) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#f3f3f3" alpha:1];
        [_collectionView registerNib:[UINib nibWithNibName:@"ODBazaarExchangeSkillCollectionCell" bundle:nil] forCellWithReuseIdentifier:cellID];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"我的收藏";
    __weakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestData];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据请求
-(void)requestData
{
    NSDictionary *parameter = @{@"type" : @"4", @"page" : [NSString stringWithFormat:@"%ld", self.page], @"open_id" : [[ODUserInformation sharedODUserInformation] openID]};
    __weakSelf
    [ODHttpTool getWithURL:ODUrlSwapList parameters:parameter modelClass:[ODBazaarExchangeSkillModel class] success:^(ODBazaarExchangeSkillModelResponse *model) {
        weakSelf.dataArray = model.result;
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

#pragma mark - UICollectionViewDelegate
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, [self returnHight:self.dataArray[indexPath.row]]);
}

#pragma mark - UICollectionViewDelegate
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
    [self presentViewController:picController animated:YES completion:nil];
}

//动态计算cell的高度
- (CGFloat)returnHight:(ODBazaarExchangeSkillModel *)model {
    CGFloat width = kScreenSize.width > 320 ? 90 : 70;
    NSString *content = model.content;
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:13]};
    CGSize size = [content boundingRectWithSize:CGSizeMake(kScreenSize.width - 93, 35) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine) attributes:dict context:nil].size;
    CGFloat baseHeight = size.height + 119;
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
