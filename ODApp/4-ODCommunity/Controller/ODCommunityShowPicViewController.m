//
//  ODCommunityShowPicViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCommunityShowPicViewController.h"

#define kCellId @"UICollectionViewCell"

@interface ODCommunityShowPicViewController ()

@end

@implementation ODCommunityShowPicViewController

#pragma mark - lazyload
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"ODBazaarPicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellId];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenSize.height - 30, kScreenSize.width, 30)];
        _label.text = [NSString stringWithFormat:@"%ld/%ld", self.selectedIndex + 1, self.photos.count];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_label];
    }
    return _label;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self collectionView];
    [self label];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.skill = @"";
    self.navigationController.navigationBar.hidden = NO;
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDateSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ODBazaarPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    UITapGestureRecognizer *pgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picCkick:)];
    [cell.picImageView addGestureRecognizer:pgr];
    cell.picImageView.userInteractionEnabled = YES;
    if ([self.skill isEqualToString:@"skill"]) {
        [cell.picImageView sd_setImageWithURL:[NSURL OD_URLWithString:[self.photos[indexPath.row]valueForKeyPath:@"img_url"]] placeholderImage:[UIImage imageNamed:@"placeholderBigImage"] options:SDWebImageRetryFailed];
    } else {
        [cell.picImageView sd_setImageWithURL:[NSURL OD_URLWithString:self.photos[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholderBigImage"] options:SDWebImageRetryFailed];
    }
    cell.picImageView.center = CGPointMake(kScreenSize.width / 2, kScreenSize.height / 2);
    cell.scrollView.zoomScale = 1;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenSize.width, kScreenSize.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / kScreenSize.width;
    self.label.text = [NSString stringWithFormat:@"%ld/%ld", index + 1, self.photos.count];
}

#pragma mark - action
- (void)picCkick:(UITapGestureRecognizer *)pgr {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
