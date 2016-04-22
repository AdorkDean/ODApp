//
//  ODBazaarDetailViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/29.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODBazaarDetailViewController.h"
#import "UMSocial.h"
#import "WXApi.h"


#define kBazaarDetailCellId @"ODBazaarDetailCollectionCell"

@interface ODBazaarDetailViewController ()

@end

@implementation ODBazaarDetailViewController

#pragma mark - lazyload
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        ODBazaarDetailLayout *layout = [[ODBazaarDetailLayout alloc]initWithAnim:HJCarouselAnimLinear];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(120, 150);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.taskBottomView.frame)+10, kScreenSize.width, 150) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"ODBazaarDetailCollectionCell" bundle:nil] forCellWithReuseIdentifier:kBazaarDetailCellId];
        [self.scrollView addSubview:_collectionView];
    }
    return _collectionView;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width,kScreenSize.height-64)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.userInteractionEnabled = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(NSMutableArray *)picArray{
    if (!_picArray) {
        _picArray = [[NSMutableArray alloc]init];
    }
    return _picArray;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.num = 1;
    self.navigationItem.title = @"任务详情";
    [self requestData];
    if ([self.task_status_name isEqualToString:@"过期"]&& [[ODUserInformation sharedODUserInformation].openID isEqualToString:self.open_id]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(shareButtonClick:) color:[UIColor blackColor] highColor:nil title:@"删除"];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(shareButtonClick:) image:[UIImage imageNamed:@"话题详情-分享icon"] highImage:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 请求数据
-(void)requestData{
    __weakSelf
    NSDictionary *parameter = @{@"task_id":self.task_id};
    [ODHttpTool getWithURL:ODUrlTaskDetail parameters:parameter modelClass:[ODBazaarDetailModel class] success:^(id model) {
        weakSelf.model = [model result];
        for (ODBazaarDetailApplysModel *applysModel in weakSelf.model.applys) {
            if ([applysModel.apply_status isEqualToString:@"1"]) {
                [weakSelf.picArray removeAllObjects];
                [weakSelf.picArray addObject:applysModel];
                break;
            }else{
                [weakSelf.picArray addObject:applysModel];
            }
        }
        
        [weakSelf createUserInfoView];
        [weakSelf createTaskTopDetailView];
        [weakSelf createTaskBottomDetailView];
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
    }];
}

-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter withName:(NSString *)name{
    __weak typeof (self)weakSelf = self;
    [ODHttpTool getWithURL:url parameters:parameter modelClass:[ODBazaarDetailModel class] success:^(id model) {
        if ([name isEqualToString:@"删除任务"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else if ([name isEqualToString:@"接受任务"]) {
            [weakSelf.picArray removeAllObjects];
            [weakSelf requestData];
            [weakSelf.taskButton setTitle:@"待派遣" forState:UIControlStateNormal];
            [weakSelf.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
            weakSelf.taskButton.backgroundColor = [UIColor whiteColor];
            [ODProgressHUD showInfoWithStatus:@"接受成功"];
        }else if ([name isEqualToString:@"确认提交"]){
            [ODProgressHUD showInfoWithStatus:@"提交成功"];
            [weakSelf.taskButton setTitle:@"已提交" forState:UIControlStateNormal];
        }else if ([name isEqualToString:@"确认完成"]){
            [weakSelf.evaluationView removeFromSuperview];
            [weakSelf.taskButton setTitle:@"已完成" forState:UIControlStateNormal];
            [ODProgressHUD showInfoWithStatus:@"确认成功"];
        }
       
        if (weakSelf.myBlock) {
            if ([name isEqualToString:@"删除任务"]){
                weakSelf.myBlock(@"del");
            }else{
                weakSelf.model = [model result];
                weakSelf.myBlock(weakSelf.model.task_status);
            }
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 创建用户信息试图
-(void)createUserInfoView{
    self.userView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, 0, kScreenSize.width-25, 76) tag:0 color:@"#ffffff"];
    [self.scrollView addSubview:self.userView];

    UIButton *userHeaderButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 13.5, 48, 48) target:self sel:@selector(userHeaderButtonClick:) tag:0 image:nil title:@"sds" font:0];
    [userHeaderButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:self.model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRetryFailed];
    userHeaderButton.layer.masksToBounds = YES;
    userHeaderButton.layer.cornerRadius = 24;
    userHeaderButton.backgroundColor = [UIColor grayColor];
    [self.userView addSubview:userHeaderButton];
    
    UILabel *userNickLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(60, 20, 150, 15) text:self.model.user_nick font:12.5 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [self.userView addSubview:userNickLabel];
    
    UILabel *userSignLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(60, 35, 150, 30) text:self.model.user_sign font:10 alignment:@"left" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
    userSignLabel.numberOfLines = 2;
    [self.userView addSubview:userSignLabel];
    
    self.taskButton = [ODClassMethod creatButtonWithFrame:CGRectMake(self.userView.frame.size.width-68.5, 25, 68.5, 25) target:nil sel:nil tag:0 image:nil title:@"" font:12];
    self.taskButton.backgroundColor = [UIColor whiteColor];
    self.taskButton.layer.masksToBounds = YES;
    self.taskButton.layer.cornerRadius = 5;
    self.taskButton.layer.borderWidth = 1;
    self.taskButton.layer.borderColor = [UIColor colorGreyColor].CGColor;
    [self.taskButton addTarget:self action:@selector(taskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.userView addSubview:self.taskButton];

    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:self.open_id]) {
        if ([self.model.task_status isEqualToString:@"1"]) {
            [self.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
            [self.taskButton setTitle:@"删除任务" forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"2"]){
            [self.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
            [self.taskButton setTitle:@"已经派遣" forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"3"]){
            [self.taskButton setTitle:@"确认完成" forState:UIControlStateNormal];
            [self.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"4"]){
            [self.taskButton setTitle:@"已完成" forState:UIControlStateNormal];
            [self.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"-2"]){
            self.taskButton.userInteractionEnabled = NO;
            [self.taskButton setTitle:@"过期任务" forState:UIControlStateNormal];
            [self.taskButton setTitleColor:[UIColor colorGreyColor] forState:UIControlStateNormal];
        }
    }else{
        NSString *open_id = @"";
        NSString *apply_status = @"";
        for (NSInteger i = 0; i < self.picArray.count; i++) {
            ODBazaarDetailApplysModel *model = self.picArray[i];
            NSString *ID = model.open_id;
            NSString *status = [NSString stringWithFormat:@"%@",model.apply_status];
            if ([ID isEqualToString:[ODUserInformation sharedODUserInformation].openID] && [status isEqualToString:@"1"]) {
                open_id = ID;
                apply_status = @"1";
            }else if ([ID isEqualToString:[ODUserInformation sharedODUserInformation].openID] && [status isEqualToString:@"0"]){
                apply_status = @"0";
            }
        }
        if ([self.model.task_status isEqualToString:@"1"] && open_id.length == 0 && [apply_status isEqualToString:@"0"]) {
            [self.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
            [self.taskButton setTitle:@"待派遣" forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"1"] && open_id.length == 0 && [apply_status isEqualToString:@""]){
            [self.taskButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.taskButton.backgroundColor = [UIColor colorWithRGBString:@"#ffd801" alpha:1];
            [self.taskButton setTitle:@"接受任务" forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"2"] && open_id.length > 0){
            [self.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
            [self.taskButton setTitle:@"确认提交" forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"4"] && open_id.length > 0 ){
            [self.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
            [self.taskButton setTitle:@"已完成" forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"3"] && open_id.length > 0){
            [self.taskButton setTitleColor:[UIColor colorRedColor] forState:UIControlStateNormal];
            [self.taskButton setTitle:@"已提交" forState:UIControlStateNormal];
        }else if ([self.model.task_status isEqualToString:@"4"] && open_id.length == 0){
            [self.taskButton removeFromSuperview];
            userNickLabel.frame = CGRectMake(60, 10, self.userView.frame.size.width-60, 20);
            userSignLabel.frame = CGRectMake(60, 30, self.userView.frame.size.width-60, 40);
        }else if ([self.model.task_status isEqualToString:@"2"] && open_id.length == 0 ){
            [self.taskButton removeFromSuperview];
            userNickLabel.frame = CGRectMake(60, 10, self.userView.frame.size.width-60, 20);
            userSignLabel.frame = CGRectMake(60, 30, self.userView.frame.size.width-60, 40);
        }else if ([self.model.task_status isEqualToString:@"3"] && open_id.length == 0){
            [self.taskButton removeFromSuperview];
            userNickLabel.frame = CGRectMake(60, 10, self.userView.frame.size.width-60, 20);
            userSignLabel.frame = CGRectMake(60, 30, self.userView.frame.size.width-60, 40);
        }else if ([self.model.task_status isEqualToString:@"-2"]){
            self.taskButton.userInteractionEnabled = NO;
            [self.taskButton setTitle:@"过期任务" forState:UIControlStateNormal];
            [self.taskButton setTitleColor:[UIColor colorGreyColor] forState:UIControlStateNormal];
        }
    }
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 75.5, kScreenSize.width-25, 0.5) tag:0 color:@"#e6e6e6"];
    [self.userView addSubview:lineView];
}

-(void)createEvaluationView{
    self.evaluationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    self.evaluationView.backgroundColor = [UIColor colorWithRGBString:@"#ffffff" alpha:0.9];
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.evaluationView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 200, kScreenSize.width, 20)];
    label.text = @"发表评价 , 确认完成任务";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14];
    [self.evaluationView addSubview:label];
    
    self.evaluationTextView = [[UITextView alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(label.frame)+5, kScreenSize.width-80, 100)];
    self.evaluationTextView.textColor = [UIColor colorGreyColor];
    self.evaluationTextView.font = [UIFont systemFontOfSize:12];
    self.evaluationTextView .delegate = self;
    self.evaluationTextView.layer.masksToBounds = YES;
    self.evaluationTextView.layer.cornerRadius = 5;
    self.evaluationTextView.layer.borderColor = [UIColor lineColor].CGColor;
    self.evaluationTextView.layer.borderWidth = 0.5;
    [self.evaluationView addSubview:self.evaluationTextView];
    
    self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(label.frame)+15, 200, 10)];
    self.placeholderLabel.text = @"好评!任务完成的非常漂亮";
    self.placeholderLabel.textColor = [UIColor colorGreyColor];
    self.placeholderLabel.font = [UIFont systemFontOfSize:12];
    [self.evaluationView addSubview:self.placeholderLabel];
    
    UIButton *yesButton = [[UIButton alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(self.evaluationTextView.frame)+10, kScreenSize.width-80, 40)];
    yesButton.layer.masksToBounds = YES;
    yesButton.layer.cornerRadius = 5;
    yesButton.layer.borderColor = [UIColor lineColor].CGColor;
    yesButton.layer.borderWidth = 0.5;
    [yesButton setTitle:@"是的" forState:UIControlStateNormal];
    yesButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [yesButton setBackgroundColor:[UIColor themeColor]];
    [yesButton addTarget:self action:@selector(yesButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView addSubview:yesButton];
    
    UIButton *offButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenSize.width-30, 20, 20, 20)];
    [offButton setBackgroundImage:[UIImage imageNamed:@"分享页关闭icon"] forState:UIControlStateNormal];
    [offButton addTarget: self action:@selector(offButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.evaluationView addSubview:offButton];
}

#pragma mark - 创建TaskTopDetailView
-(void)createTaskTopDetailView{
    self.taskTopView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, CGRectGetMaxY(self.userView.frame), kScreenSize.width-25, 100) tag:0 color:@"#ffffff"];
    [self.scrollView addSubview:self.taskTopView];

    UILabel *taskTitleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, 17.5, kScreenSize.width-25, [ODHelp textHeightFromTextString:self.model.title width:kScreenSize.width-25 fontSize:12.5]) text:self.model.title font:12.5 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [self.taskTopView addSubview:taskTitleLabel];
    
    UILabel *contentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(taskTitleLabel.frame)+17.5, 60, 20) text:@"任务内容 :" font:11.5 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
    contentLabel.layer.borderColor = [UIColor themeColor].CGColor;
    [self.taskTopView addSubview:contentLabel];

    CGRect frame ;
    CGFloat height = [ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width-25 fontSize:12.5];
    if (height > 60) {
        frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame)+10, kScreenSize.width-25, 60);
    }else{
        frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame)+10,kScreenSize.width-25, [ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width-25 fontSize:12.5]);
    }
    self.taskContentLabel = [[UILabel alloc]initWithFrame:frame];
    self.taskContentLabel.text = self.model.content;
    self.taskContentLabel.font = [UIFont systemFontOfSize:12.5];
    self.taskContentLabel.textAlignment = NSTextAlignmentLeft;
    self.taskContentLabel.textColor = [UIColor colorGloomyColor];
    self.taskContentLabel.numberOfLines = 4;
    [self.taskTopView addSubview:self.taskContentLabel];
    self.taskTopView.frame = CGRectMake(12.5, CGRectGetMaxY(self.userView.frame), kScreenSize.width-25, self.taskContentLabel.frame.size.height+self.taskContentLabel.frame.origin.y);
}

#pragma mark - 创建TaskBottomDetailView
-(void)createTaskBottomDetailView{
    CGFloat height = [ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width-25 fontSize:12.5];
    self.taskBottomView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, CGRectGetMaxY(self.taskTopView.frame)+10, kScreenSize.width-25, 100) tag:0 color:@"#ffffff"];
    self.taskBottomView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.taskBottomView];
    
    CGFloat labelHeight;
    CGFloat buttonHeight;
    UILabel *rewardLabel;
    if (height < 60) {
       rewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.allView.frame)+7.5, 60, 20) text:@"任务奖励 :" font:11.5 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
       rewardLabel.layer.borderColor = [UIColor themeColor].CGColor;
    }else{
        labelHeight = 20;
        buttonHeight = 16;
        //显示全部内容
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allButtonClick)];
        self.allView = [[UIView alloc]initWithFrame:CGRectMake(self.taskBottomView.frame.size.width-130, 0, 130, labelHeight)];
        [self.allView addGestureRecognizer:gesture];
        [self.taskBottomView addSubview:self.allView];
        
        self.allLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(20, 0, 80, labelHeight) text:@"显示全部内容" font:11 alignment:@"right" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
        [self.allView addSubview:self.allLabel];
        
        self.allImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(110,1.5, 19, buttonHeight) imageName:@"任务详情下拉按钮" tag:0];
        [self.allView addSubview:self.allImageView];
        
        //任务奖励
        rewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(self.allView.frame)+10, 60, 20) text:@"任务奖励 :" font:11.5 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
        rewardLabel.layer.borderColor = [UIColor themeColor].CGColor;
    }
    [self.taskBottomView addSubview:rewardLabel];
    
    UILabel *taskRewardLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(rewardLabel.frame)+10, kScreenSize.width-25, [ODHelp textHeightFromTextString:self.model.reward_name width:kScreenSize.width-25 fontSize:15]) text:self.model.reward_name font:12.5 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
    if (self.model.reward_name.length==0) {
        taskRewardLabel.text = @"该任务没有奖励";
    }
    [self.taskBottomView addSubview:taskRewardLabel];
    
    UILabel *timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(taskRewardLabel.frame)+17.5,60, 20) text:@"任务时间 :" font:11.5 alignment:@"center" color:@"#484848" alpha:1 maskToBounds:YES];
    timeLabel.layer.borderColor = [UIColor themeColor].CGColor;
    [self.taskBottomView addSubview:timeLabel];
    
    NSString *startTime = [[self.model.task_datetime substringWithRange:NSMakeRange(5, 14)] stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    NSString *endTime = [[self.model.task_datetime substringFromIndex:24] stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    UILabel *dateTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame)+10, kScreenSize.width-25, [ODHelp textHeightFromTextString:self.model.task_datetime width:kScreenSize.width-25 fontSize:12.5]) text:[startTime stringByAppendingString:endTime] font:12.5 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
    [self.taskBottomView addSubview:dateTimeLabel];
    
    UILabel *createTimeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(0, CGRectGetMaxY(dateTimeLabel.frame)+10, kScreenSize.width-25, [ODHelp textHeightFromTextString:self.model.task_created_at width:kScreenSize.width fontSize:10]) text:[self.model.task_created_at stringByReplacingOccurrencesOfString:@"/" withString:@"-"] font:10 alignment:@"right" color:@"#d0d0d0" alpha:1 maskToBounds:NO];
    [self.taskBottomView addSubview:createTimeLabel];
    
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(0, CGRectGetMaxY(createTimeLabel.frame)+10.5, kScreenSize.width-25, 0.5) tag:0 color:@"#e6e6e6"];
    [self.taskBottomView addSubview:lineView];
    
    self.taskBottomView.frame = CGRectMake(12.5, CGRectGetMaxY(self.taskTopView.frame)+10, kScreenSize.width-25, lineView.frame.size.height+lineView.frame.origin.y);
}

-(void)showAllView{

    CGRect frame = self.taskContentLabel.frame;
    frame.size.height = [ODHelp textHeightFromTextString:self.model.content width:kScreenSize.width-25 fontSize:12.5];
    self.taskContentLabel.frame = frame;
    self.taskContentLabel.numberOfLines = 0;
    self.taskTopView.frame = CGRectMake(12.5, CGRectGetMaxY(self.userView.frame), kScreenSize.width-25, self.taskContentLabel.frame.size.height+self.taskContentLabel.frame.origin.y);
    frame = self.taskBottomView.frame;
    frame.origin.y = CGRectGetMaxY(self.taskTopView.frame)+10;
    self.taskBottomView.frame = frame;
    
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.taskBottomView.frame)+10, kScreenSize.width, 150);
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,self.userView.frame.size.height+self.taskTopView.frame.size.height+self.taskBottomView.frame.size.height+180);
}

-(void)hiddenPartView{
    CGRect frame = self.taskContentLabel.frame;
    frame.size.height = 60;
    self.taskContentLabel.frame = frame;
    self.taskContentLabel.numberOfLines = 4;
    self.taskTopView.frame = CGRectMake(12.5, CGRectGetMaxY(self.userView.frame), kScreenSize.width-25, self.taskContentLabel.frame.size.height+self.taskContentLabel.frame.origin.y);
    frame = self.taskBottomView.frame;
    frame.origin.y = CGRectGetMaxY(self.taskTopView.frame)+10;
    self.taskBottomView.frame = frame;
    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.taskBottomView.frame)+10, kScreenSize.width, 150);
    self.scrollView.contentSize = CGSizeMake(kScreenSize.width,self.userView.frame.size.height+self.taskTopView.frame.size.height+self.taskBottomView.frame.size.height+180);
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

#pragma mark - UICollectionViewDateSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ODBazaarDetailCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBazaarDetailCellId forIndexPath:indexPath];
    cell.model = self.picArray[indexPath.row];
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [UIColor colorGloomyColor].CGColor;
    cell.layer.borderWidth = 1;
    return cell;
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ODBazaarDetailApplysModel *model = self.picArray[indexPath.row];
    NSString *task_status = [NSString stringWithFormat:@"%@",self.model.task_status];
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:self.open_id]) {
        if ([task_status isEqualToString:@"1"] && self.num == 1) {
           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否委派" message:nil preferredStyle:UIAlertControllerStyleAlert];
            __weakSelf
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *parameter = @{@"task_id":weakSelf.task_id,@"apply_open_id":model.open_id};
                [ODHttpTool getWithURL:ODUrlTaskAccept parameters:parameter modelClass:[NSObject class] success:^(id model) {
                    [weakSelf.taskButton setTitle:@"已经派遣" forState:UIControlStateNormal];
                    [ODProgressHUD showInfoWithStatus:@"委派成功"];
                    [weakSelf.picArray removeAllObjects];
                    [weakSelf requestData];
                    weakSelf.num++;
                } failure:^(NSError *error) {
                }];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            
        }
    }
}

#pragma mark - UITextViewDelegate
NSString *evaluationContentText = @"";
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 300){
        textView.text = [textView.text substringToIndex:300];
    }else{
        evaluationContentText = textView.text;
    }
    
    if (textView.text.length == 0) {
        self.placeholderLabel.text = @"好评!任务完成的非常漂亮";
    }else{
        self.placeholderLabel.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.placeholderLabel.text = @"好评!任务完成的非常漂亮";
    }
}

#pragma mark - action
-(void)shareButtonClick:(UIButton *)button{
    if ([button.titleLabel.text isEqualToString:@"删除"]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除任务" message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weakSelf
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *parameter = @{@"id":weakSelf.task_id,@"type":@"2",@"open_id":[ODUserInformation sharedODUserInformation].openID};
            [weakSelf pushDataWithUrl:ODUrlBbsDel parameter:parameter withName:@"删除任务"];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [ODPublicTool shareAppWithTarget:self dictionary:self.model.share controller:self];
    }
}

-(void)userHeaderButtonClick:(UIButton *)button
{
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:self.open_id]) {
    }else{
        ODOthersInformationController *otherInfo = [[ODOthersInformationController alloc]init];
        otherInfo.open_id  = self.open_id;
        [self.navigationController pushViewController:otherInfo animated:YES];
    }
}

-(void)taskButtonClick:(UIButton *)button
{
    if ([ODUserInformation sharedODUserInformation].openID.length == 0) {
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
    }else{
        if ([button.titleLabel.text isEqualToString:@"删除任务"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除任务" message:nil preferredStyle:UIAlertControllerStyleAlert];
            __weakSelf
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *parameter = @{@"id":weakSelf.task_id,@"type":@"2"};
                [weakSelf pushDataWithUrl:ODUrlBbsDel parameter:parameter withName:@"删除任务"];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }else if ([button.titleLabel.text isEqualToString:@"接受任务"]){
            NSDictionary *parameter = @{@"task_id":self.task_id};
            [self pushDataWithUrl:ODUrlTaskApply parameter:parameter withName:@"接受任务"];
        }else if ([button.titleLabel.text isEqualToString:@"确认提交"]){
            NSDictionary *parameter = @{@"task_id":self.task_id};
            [self pushDataWithUrl:ODUrlTaskDelivery parameter:parameter withName:@"确认提交"];
        }else if ([button.titleLabel.text isEqualToString:@"确认完成"]){
            [self createEvaluationView];
        }
    }
}

-(void)allButtonClick{
    static BOOL buttonClicked = NO;
    if (buttonClicked) {
        [self.allImageView setImage:[UIImage imageNamed:@"任务详情下拉按钮"]];
        self.allLabel.text = @"显示全部内容";
        [self hiddenPartView];
        buttonClicked = NO;
    }else{
        [self.allImageView setImage:[UIImage imageNamed:@"任务详情上拉按钮"]];
        self.allLabel.text = @"隐藏部分内容";
        [self showAllView];
        buttonClicked = YES;
    }
}

-(void)yesButtonClick:(UIButton *)button{
    NSDictionary *parameter;
    if (self.evaluationTextView.text.length) {
        parameter = @{@"task_id":self.task_id,@"comment":self.evaluationTextView.text};
    }else{
        parameter = @{@"task_id":self.task_id,@"comment":@"好评!任务完成的非常漂亮"};
    }
    [self pushDataWithUrl:ODUrlTaskConfirm parameter:parameter withName:@"确认完成"];
}

-(void)offButtonClick:(UIButton *)button{
    [self.evaluationView removeFromSuperview];
}


@end
