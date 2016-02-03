//
//  ODCommunityShowPicViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODCommunityShowPicViewController.h"

#define kCellId @"UICollectionViewCell"

@interface ODCommunityShowPicViewController ()

@end

@implementation ODCommunityShowPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createCollectionView];
    [self createCountLabel];
}

-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(KScreenWidth, KScreenHeight);
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-100) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellId];
    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,100, kScreenSize.width-40, kScreenSize.height-200)];
    if ([self.skill isEqualToString:@"skill"]) {
        NSDictionary *dict = self.photos[indexPath.row];
        [imageView sd_setImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]]];
    }else{
        [imageView sd_setImageWithURL:[NSURL OD_URLWithString:self.photos[indexPath.row]]];
    }
    [cell.contentView addSubview:imageView];
    return cell;
}


-(void)createCountLabel
{
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenSize.height - 100, kScreenSize.width, 100)];
    self.label.text = [NSString stringWithFormat:@"%ld/%ld",self.selectedIndex+1,self.photos.count];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.label];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/kScreenSize.width;
    self.label.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.photos.count];
}

#pragma mark - view视图将要显示
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.skill = @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
