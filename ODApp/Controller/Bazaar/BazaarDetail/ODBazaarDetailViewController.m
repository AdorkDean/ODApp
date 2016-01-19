//
//  ODBazaarDetailViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarDetailViewController.h"

@interface ODBazaarDetailViewController ()

@end

@implementation ODBazaarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationInit];
    [self createScrollView];
    [self createRequest];
    
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"任务详情" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //返回按钮
<<<<<<< HEAD
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 28,32, 20) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
=======
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
>>>>>>> ab9b6b0ccedcaaee159908d6427c4c8f0fa3d1a6
    [self.headView addSubview:backButton];
}

-(void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 创建scrollView
-(void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width,kScreenSize.height-64)];
    self.scrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.scrollView];
}
#pragma mark - 初始化manager
-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
    self.picArray = [[NSMutableArray alloc]init];
    [self joiningTogetherParmeters];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter = @{@"task_id":self.task_id};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarTaskDetailUrl parameter:signParameter];
}

#pragma mark - 请求数据
-(void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            ODBazaarDetailModel *detailModel = [[ODBazaarDetailModel alloc]init];
            [detailModel setValuesForKeysWithDictionary:result];
            [weakSelf.dataArray addObject:detailModel];
            NSArray *applys = result[@"applys"];
            for (NSDictionary *itemDict in applys) {
                ODBazaarDetailModel *model = [[ODBazaarDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [self.picArray addObject:model];
            }
        }
        [self createUserInfoView];
        [self createTaskTopDetailView];
        [self createTaskBottomDetailView];
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        NSLog(@"error");
    }];
    
}

#pragma mark - 创建用户信息试图
-(void)createUserInfoView
{
    ODBazaarDetailModel *detailModel = [self.dataArray objectAtIndex:0];
    self.userView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, 0, kScreenSize.width-25, 76) tag:0 color:@"#ffffff"];
    [self.scrollView addSubview:self.userView];
    
    //头像
    UIButton *userHeaderButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 13.5, 48, 48) target:self sel:@selector(userHeaderButtonClick:) tag:0 image:nil title:@"sds" font:0];
    [userHeaderButton sd_setBackgroundImageWithURL:[NSURL URLWithString:detailModel.avatar] forState:UIControlStateNormal];
    userHeaderButton.layer.masksToBounds = YES;
    userHeaderButton.layer.cornerRadius = 24;
    userHeaderButton.backgroundColor = [UIColor grayColor];
    [self.userView addSubview:userHeaderButton];
    
    //昵称
    UILabel *userNickLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(60, 10, 100, 20) text:detailModel.user_nick font:15 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [self.userView addSubview:userNickLabel];
    
    //签名
    UILabel *userSignLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(60, 30, 150, 40) text:detailModel.user_sign font:13 alignment:@"left" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
    [self.userView addSubview:userSignLabel];
    
    //接受任务
    self.taskButton = [ODClassMethod creatButtonWithFrame:CGRectMake(self.userView.frame.size.width-80, 20, 80, 35) target:nil sel:nil tag:0 image:nil title:@"" font:14];
    self.taskButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.taskButton setTitleColor:[UIColor colorWithHexString:@"#d0d0d0" alpha:1] forState:UIControlStateNormal];
    self.taskButton.layer.masksToBounds = YES;
    self.taskButton.layer.cornerRadius = 5;
    self.taskButton.layer.borderWidth = 1;
    self.taskButton.layer.borderColor = [UIColor colorWithHexString:@"b0b0b0" alpha:1].CGColor;

    if ([[ODUserInformation getData].openID isEqualToString:self.open_id]) {
        [self.taskButton addTarget:self action:@selector(taskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.taskButton setTitleColor:[UIColor colorWithHexString:@"#ff6666" alpha:1] forState:UIControlStateNormal];
        [self.taskButton setTitle:@"删除任务" forState:UIControlStateNormal];
        [self.userView addSubview:self.taskButton];
    }else{
        if ([self.task_status isEqualToString:@"1"]) {
            [self.taskButton setTitle:@"接受任务" forState:UIControlStateNormal];
            [self.taskButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
            self.taskButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
            [self.taskButton addTarget:self action:@selector(taskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.userView addSubview:self.taskButton];
        }else if ([self.task_status isEqualToString:@"-2"]){
            [self.taskButton setTitle:@"任务过期" forState:UIControlStateNormal];
            [self.userView addSubview:self.taskButton];
        }else{
            userNickLabel.frame = CGRectMake(60, 10, self.userView.frame.size.width-60, 20);
            userSignLabel.frame = CGRectMake(60, 30, self.userView.frame.size.width-60, 40);
        }
    }
    
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 75, kScreenSize.width-25, 1) tag:0 color:@"#e6e6e6"];
    [self.userView addSubview:lineView];
}

-(void)userHeaderButtonClick:(UIButton *)button
{
    
}

-(void)taskButtonClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"删除任务"]) {
        NSDictionary *parameter = @{@"id":self.task_id,@"type":@"2",@"open_id":[ODUserInformation getData].openID};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [self pushDataWithUrl:kDeleteReplyUrl parameter:signParameter isDelete:YES];
    }else{
        if ([ODUserInformation getData].openID) {
            NSDictionary *parameter = @{@"task_id":self.task_id,@"open_id":[ODUserInformation getData].openID};
            NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
            [self pushDataWithUrl:kBazaarAcceptTaskUrl parameter:signParameter isDelete:NO];
        }else{
            ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
            [self.navigationController pushViewController:personalCenter animated:YES];
        }
    }
}

#pragma mark - 提交数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter isDelete:(BOOL)isDelete
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {

        if (isDelete) {
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                if (self.myBlock) {
                    self.myBlock([NSString stringWithFormat:@"del"]);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else{
            NSLog(@"%@",responseObject);
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                [self.taskButton setTitle:@"待派遣" forState:UIControlStateNormal];
                [self.taskButton setTitleColor:[UIColor colorWithHexString:@"#ff6666" alpha:1] forState:UIControlStateNormal];
                self.taskButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建TaskTopDetailView
-(void)createTaskTopDetailView
{
    ODBazaarDetailModel *detailModel = [self.dataArray objectAtIndex:0];
    self.taskTopView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, CGRectGetMaxY(self.userView.frame), kScreenSize.width-25, 100) tag:0 color:@"#ffffff"];
    [self.scrollView addSubview:self.taskTopView];
    //标题
    UILabel *taskTitleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 17.5, kScreenSize.width-25, [ODHelp textHeightFromTextString:detailModel.title width:kScreenSize.width-25 fontSize:15]) text:detailModel.title font:15 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [self.taskTopView addSubview:taskTitleLabel];
    
    //任务内容
    UILabel *contentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(taskTitleLabel.frame)+17.5, 80, 30) text:@"任务内容 :" font:14 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
    contentLabel.layer.borderColor = [UIColor colorWithHexString:@"ffd802" alpha:1].CGColor;
    [self.taskTopView addSubview:contentLabel];

    CGRect frame ;
    CGFloat height = [ODHelp textHeightFromTextString:detailModel.content width:kScreenSize.width-25 fontSize:15];
    if (height > 80) {
        frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame)+10, kScreenSize.width-25, 80);
    }else{
        frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame)+10,kScreenSize.width-25, [ODHelp textHeightFromTextString:detailModel.content width:kScreenSize.width-25 fontSize:15]);
    }
    self.taskContentLabel = [ODClassMethod creatLabelWithFrame:frame text:detailModel.content font:15 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
    self.taskContentLabel.numberOfLines = 4;
    [self.taskTopView addSubview:self.taskContentLabel];
    self.taskTopView.frame = CGRectMake(12.5, CGRectGetMaxY(self.userView.frame), kScreenSize.width-25, self.taskContentLabel.frame.size.height+self.taskContentLabel.frame.origin.y);
    
}

#pragma mark - 创建TaskBottomDetailView
-(void)createTaskBottomDetailView
{
    ODBazaarDetailModel *detailModel = [self.dataArray objectAtIndex:0];
    CGFloat height = [ODHelp textHeightFromTextString:detailModel.content width:kScreenSize.width-25 fontSize:15];
    self.taskBottomView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, CGRectGetMaxY(self.taskTopView.frame)+10, kScreenSize.width-25, 100) tag:0 color:@"#ffffff"];
    [self.scrollView addSubview:self.taskBottomView];
    
    CGFloat labelHeight;
    CGFloat buttonHeight;
    if (height < 80) {
        labelHeight = 0;
        buttonHeight = 0;
    }else{
        labelHeight = 30;
        buttonHeight = 22;
    }
    //显示全部内容
    self.allLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(self.taskBottomView.frame.size.width-130, 0, 100, labelHeight) text:@"显示全部内容" font:15 alignment:@"center" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    [self.taskBottomView addSubview:self.allLabel];
    
    UIButton *allButton = [ODClassMethod creatButtonWithFrame:CGRectMake(self.taskBottomView.frame.size.width-30,4, 25, buttonHeight) target:self sel:@selector(allButtonClick:) tag:0 image:@"任务详情下拉按钮" title:nil font:0];
    [self.taskBottomView addSubview:allButton];
    //任务奖励
    UILabel *rewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.allLabel.frame)+10, 80, 30) text:@"任务奖励 :" font:14 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
    rewardLabel.layer.borderColor = [UIColor colorWithHexString:@"ffd802" alpha:1].CGColor;
    [self.taskBottomView addSubview:rewardLabel];
    
    UILabel *taskRewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(rewardLabel.frame)+10, kScreenSize.width-25, [ODHelp textHeightFromTextString:detailModel.reward_name width:kScreenSize.width-25 fontSize:15]) text:detailModel.reward_name font:15 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
    if (detailModel.reward_name.length==0) {
        taskRewardLabel.text = @"该任务没有奖励";
    }
    [self.taskBottomView addSubview:taskRewardLabel];
    
    //任务时间
    UILabel *timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(taskRewardLabel.frame)+17.5,80, 30) text:@"任务时间 :" font:14 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
    timeLabel.layer.borderColor = [UIColor colorWithHexString:@"ffd802" alpha:1].CGColor;
    [self.taskBottomView addSubview:timeLabel];
    
    NSString *startTime = [[detailModel.task_datetime substringWithRange:NSMakeRange(5, 14)] stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    NSString *endTime = [[detailModel.task_datetime substringFromIndex:24] stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    UILabel *dateTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame)+10, kScreenSize.width-25, [ODHelp textHeightFromTextString:detailModel.task_datetime width:kScreenSize.width-25 fontSize:15]) text:[startTime stringByAppendingString:endTime] font:15 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
    [self.taskBottomView addSubview:dateTimeLabel];
    
    UILabel *createTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(dateTimeLabel.frame)+10, kScreenSize.width-25, [ODHelp textHeightFromTextString:detailModel.task_created_at width:kScreenSize.width fontSize:13]) text:[detailModel.task_created_at stringByReplacingOccurrencesOfString:@"/" withString:@"-"] font:13 alignment:@"right" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    [self.taskBottomView addSubview:createTimeLabel];
    
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(createTimeLabel.frame)+10, kScreenSize.width-25, 1) tag:0 color:@"#e6e6e6"];
    [self.taskBottomView addSubview:lineView];
    
    self.taskBottomView.frame = CGRectMake(12.5, CGRectGetMaxY(self.taskTopView.frame)+10, kScreenSize.width-25, lineView.frame.size.height+lineView.frame.origin.y);
   
    ODBazaarDetailLayout *layout = [[ODBazaarDetailLayout alloc]initWithAnim:HJCarouselAnimLinear];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(160, 200);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.taskBottomView.frame)+10, kScreenSize.width, 200) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ODBazaarDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarDetailCellId];
    [self.scrollView addSubview:self.collectionView];
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,self.userView.frame.size.height+self.taskTopView.frame.size.height+self.taskBottomView.frame.size.height+230);

}

-(void)allButtonClick:(UIButton *)button
{
    static BOOL buttonClicked = NO;
    
    if (buttonClicked) {
        
        [button setBackgroundImage:[UIImage imageNamed:@"任务详情下拉按钮"] forState:UIControlStateNormal];
        self.allLabel.text = @"显示全部内容";
        [self hiddenViewWhenButtonClickAgain:button];
        buttonClicked = NO;
        
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"任务详情上拉按钮"] forState:UIControlStateNormal];
        self.allLabel.text = @"隐藏全部内容";
        [self showViewWhenButtonClick:button];
        buttonClicked = YES;
    }
}

-(void)showViewWhenButtonClick:(UIButton *)button
{
    ODBazaarDetailModel *detailModel = [self.dataArray objectAtIndex:0];
    CGRect frame = self.taskContentLabel.frame;
    frame.size.height = [ODHelp textHeightFromTextString:detailModel.content width:kScreenSize.width-25 fontSize:15];
    self.taskContentLabel.frame = frame;
    self.taskContentLabel.numberOfLines = 0;
    self.taskTopView.frame = CGRectMake(12.5, CGRectGetMaxY(self.userView.frame), kScreenSize.width-25, self.taskContentLabel.frame.size.height+self.taskContentLabel.frame.origin.y);
    frame = self.taskBottomView.frame;
    frame.origin.y = CGRectGetMaxY(self.taskTopView.frame)+10;
    self.taskBottomView.frame = frame;
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.taskBottomView.frame)+10, kScreenSize.width, 200);
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,self.userView.frame.size.height+self.taskTopView.frame.size.height+self.taskBottomView.frame.size.height+230);
}

-(void)hiddenViewWhenButtonClickAgain:(UIButton *)button
{
    CGRect frame = self.taskContentLabel.frame;
    frame.size.height = 80;
    self.taskContentLabel.frame = frame;
    self.taskContentLabel.numberOfLines = 4;
    self.taskTopView.frame = CGRectMake(12.5, CGRectGetMaxY(self.userView.frame), kScreenSize.width-25, self.taskContentLabel.frame.size.height+self.taskContentLabel.frame.origin.y);
    frame = self.taskBottomView.frame;
    frame.origin.y = CGRectGetMaxY(self.taskTopView.frame)+10;
    self.taskBottomView.frame = frame;
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.taskBottomView.frame)+10, kScreenSize.width, 200);
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,self.userView.frame.size.height+self.taskTopView.frame.size.height+self.taskBottomView.frame.size.height+230);
}

- (NSIndexPath *)curIndexPath {
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *curIndexPath = nil;
    NSInteger curzIndex = 0;
    for (NSIndexPath *path in indexPaths.objectEnumerator) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:path];
        if (!curIndexPath) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
            continue;
        }
        if (attributes.zIndex > curzIndex) {
            curIndexPath = path;
            curzIndex = attributes.zIndex;
        }
    }
    return curIndexPath;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *curIndexPath = [self curIndexPath];
    if (indexPath.row == curIndexPath.row) {
        return YES;
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    
    return NO;
}



#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarDetailCellId forIndexPath:indexPath];
    ODBazaarDetailModel *model = self.picArray[indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    cell.nickLabel.text = model.user_nick;
    cell.signLabel.text = model.user_sign;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [UIColor colorWithHexString:@"#484848" alpha:1].CGColor;
    cell.layer.borderWidth = 1;
    return cell;
}

#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;
}

#pragma mark - 试图将要消失
-(void)viewWillDisappear:(BOOL)animated
{
    ODTabBarController * tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1.0;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
