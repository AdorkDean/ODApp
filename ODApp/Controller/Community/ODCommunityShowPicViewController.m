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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createCollectionView];
    [self createCountLabel];
}

-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.pagingEnabled = YES;

    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarPicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellId];
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
    ODBazaarPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(picCkick:)];
    [cell.picImageView addGestureRecognizer:pgr];
    cell.picImageView.userInteractionEnabled = YES;
    if ([self.skill isEqualToString:@"skill"]) {
        NSDictionary *dict = self.photos[indexPath.row];
        [cell.picImageView sd_setImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.picImageView sizeToFit];
            CGFloat multiple = cell.picImageView.od_width/kScreenSize.width;
            CGFloat height = cell.picImageView.od_height/multiple;
            cell.picImageView.frame = CGRectMake(0, 0, kScreenSize.width, height);
            cell.picImageView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
            cell.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        }];
    }else{
        [cell.picImageView sd_setImageWithURL:[NSURL OD_URLWithString:self.photos[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.picImageView sizeToFit];
            CGFloat multiple = cell.picImageView.od_width/kScreenSize.width;
            CGFloat height = cell.picImageView.od_height/multiple;
            cell.picImageView.frame = CGRectMake(0, 0, kScreenSize.width, height);
            cell.picImageView.center = CGPointMake(KScreenWidth/2, KScreenHeight/2);
            cell.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        }];
    }

    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kScreenSize.width, kScreenSize.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:YES completion:nil];   
}

-(void)createCountLabel
{
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenSize.height - 30, kScreenSize.width, 30)];
    self.label.text = [NSString stringWithFormat:@"%ld/%ld",self.selectedIndex+1,self.photos.count];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.label];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/kScreenSize.width;
    self.label.text = [NSString stringWithFormat:@"%ld/%ld",index+1,self.photos.count];
}


-(void)picCkick:(UIPinchGestureRecognizer *)pgr
{
    static CGFloat scale = 1;
    pgr.view.transform = CGAffineTransformMakeScale(scale*pgr.scale, scale*pgr.scale);

    if (pgr.state == UIGestureRecognizerStateEnded)
    {
        scale = pgr.scale <= 1 ? 1 : pgr.scale;
    }
 
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
    [super viewWillDisappear:animated];
    self.skill = @"";
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
