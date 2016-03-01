//
//  ODCommunityDetailViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "ODCommunityDetailViewController.h"
#import "WXApi.h"
@interface ODCommunityDetailViewController ()<UMSocialUIDelegate>

@end

@implementation ODCommunityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weakSelf
    self.count = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"话题详情";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(shareButtonClick) image:[UIImage imageNamed:@"话题详情-分享icon"] highImage:nil];
    
    [self createReplyButton];
    [self createRequest];
    [self joiningTogetherParmetersWithUserInfo:NO];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf joiningTogetherParmetersWithUserInfo:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
 
}

#pragma mark - 加载更多
-(void)loadMoreData
{
    self.count ++;
    NSDictionary *parameter = @{@"bbs_id":self.bbs_id,@"page":[NSString stringWithFormat:@"%ld",self.count]};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadTableDataWithUrl:kCommunityBbsReplyListUrl paramater:signParameter];
}

#pragma mark - 分享
-(void)shareButtonClick
{
       
    
        
        
        if ([WXApi isWXAppInstalled]) {
            
            
            [UMSocialConfig setFinishToastIsHidden:YES  position:UMSocialiToastPositionCenter];
            
            
            ODCommunityDetailModel *model = self.resultArray[0];
            NSString *url = model.share[@"icon"];
            NSString *content = model.share[@"desc"];
            NSString *link = model.share[@"link"];
            NSString *title = model.share[@"title"];
            
            
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
            
            [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
            
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:kGetUMAppkey
                                              shareText:content
                                             shareImage:nil
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                               delegate:self];
            
            
        }else{
            
            [ODProgressHUD showInfoWithStatus:@"没有安装微信"];
            
            
        }

 

}




-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.resultArray = [[NSMutableArray alloc]init];
    self.userArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmetersWithUserInfo:(BOOL)userInfo
{
    if (userInfo) {
        NSDictionary *parameter = @{@"id":self.bbs_id};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [self downLoadDataWithUrl:kCommunityBbsDetailUrl paramater:signParameter];
        NSLog(@"%@",signParameter);
    }else{
        self.count = 1;
        NSDictionary *parameter = @{@"bbs_id":self.bbs_id,@"page":[NSString stringWithFormat:@"%ld",self.count]};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [self downLoadTableDataWithUrl:kCommunityBbsReplyListUrl paramater:signParameter];
    }
}

#pragma mark - 请求发帖人信息
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)paramater
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:paramater success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
            if (responseObject) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSDictionary *result = dict[@"result"];
                ODCommunityDetailModel *resultModel = [[ODCommunityDetailModel alloc]init];
                [resultModel setValuesForKeysWithDictionary:result];
                [weakSelf.resultArray addObject:resultModel];
                
                NSDictionary *user = result[@"user"];
                ODCommunityDetailModel *userModel = [[ODCommunityDetailModel alloc]init];
                [userModel setValuesForKeysWithDictionary:user];
                [weakSelf.userArray addObject:userModel];
                [weakSelf createUserInfoView];
                [weakSelf createBBSDetailView];
               
            }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
    }];
}

-(void)downLoadTableDataWithUrl:(NSString *)url paramater:(NSDictionary *)paramater
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:paramater success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (responseObject) {

            if (weakSelf.count == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *result = dict[@"result"];
            for (NSDictionary *itemDict in result) {
                ODCommunityDetailModel *model = [[ODCommunityDetailModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
            }
            [weakSelf joiningTogetherParmetersWithUserInfo:YES];

            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            
            if (result.count == 0) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [ODProgressHUD showInfoWithStatus:@"网络异常"];
    }];
}

#pragma mark - 创建用户信息试图
-(void)createUserInfoView
{
    ODCommunityDetailModel *userModel = [self.userArray objectAtIndex:0];
    self.tabelHeaderView = [ODClassMethod creatViewWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, 100) tag:0 color:@"#ffffff"];
    self.userView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, 0, kScreenSize.width-25, 76) tag:0 color:@"#ffffff"];
    [self.tabelHeaderView addSubview:self.userView];
    
    //头像
    UIButton *userHeaderButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 17.5, 48, 48) target:self sel:@selector(userHeaderButtonClick:) tag:0 image:nil title:@"" font:0];
    [userHeaderButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:userModel.avatar_url] forState:UIControlStateNormal];
    userHeaderButton.layer.masksToBounds = YES;
    userHeaderButton.layer.cornerRadius = 24;
    userHeaderButton.backgroundColor = [UIColor grayColor];
    [self.userView addSubview:userHeaderButton];
    
    //昵称
    UILabel *userNickLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(60, 17, self.userView.frame.size.width-60, 13) text:userModel.nick font:13 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [self.userView addSubview:userNickLabel];
    
    //签名
    UILabel *userSignLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(60, 40, 150, 25) text:userModel.sign font:10 alignment:@"left" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
    [self.userView addSubview:userSignLabel];
    userSignLabel.numberOfLines = 2;
    
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 75.5, kScreenSize.width-25, 0.5) tag:0 color:@"#e6e6e6"];
    [self.userView addSubview:lineView];
}

-(void)userHeaderButtonClick:(UIButton *)button
{
    ODCommunityDetailModel *model = [self.userArray objectAtIndex:0];
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:model.open_id]) {
        
    }else{
        ODOthersInformationController *otherInfo = [[ODOthersInformationController alloc]init];
        otherInfo.open_id = model.open_id;
        [self.navigationController pushViewController:otherInfo animated:YES];
    }
}

#pragma marl - 创建bbs详情试图
-(void)createBBSDetailView
{
    ODCommunityDetailModel *resultModel = [self.resultArray objectAtIndex:0];
    ODCommunityDetailModel *userModel = [self.userArray objectAtIndex:0];
    self.bbsView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 76, kScreenSize.width, 100) tag:0 color:nil];
    [self.tabelHeaderView addSubview:self.bbsView];
    //bbs标题
    UILabel *bbsTitleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(12.5, 17.5, kScreenSize.width-25, [ODHelp textHeightFromTextString:resultModel.title width:kScreenSize.width-25 fontSize:12.5]) text:resultModel.title font:12.5 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [self.bbsView addSubview:bbsTitleLabel];
    
    //bbs内容
    UILabel *bbsContentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(12.5, CGRectGetMaxY(bbsTitleLabel.frame)+17.5,kScreenSize.width-25, [ODHelp textHeightFromTextString:resultModel.content width:kScreenSize.width-25 fontSize:12.5]) text:resultModel.content font:12.5 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
    [self.bbsView addSubview:bbsContentLabel];

    //创建时间
    NSString *time = [[resultModel.created_at substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    
    CGRect frame = bbsContentLabel.frame;
    UILabel *timeLabel = nil;
    UIButton *deleteButton = nil;
    UIView *lineView = nil;
    for (NSInteger i = 0; i < resultModel.imgs_big.count; i++) {
        NSDictionary *dict = resultModel.imgs_big[i];
        UIImageView *imageView = [[UIImageView alloc]init];
        CGFloat multiple = [dict[@"x"] floatValue]/[dict[@"y"]floatValue];
        if ([dict[@"y"]floatValue]==0) {
            imageView.frame = CGRectMake(10, CGRectGetMaxY(frame)+10, kScreenSize.width-20, 300);
        }else{
           imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(frame)+10, kScreenSize.width-20, (kScreenSize.width-20)/multiple)];
        }
        frame = imageView.frame;
        [imageView sd_setImageWithURL:[NSURL OD_URLWithString:dict[@"img_url"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error)
            {
                imageView.image = [UIImage imageNamed:@"errorplaceholderImage"];
            }

        }];
        [self.bbsView addSubview:imageView];
    }
    
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:userModel.open_id]){
        //删除按钮
        deleteButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width-50, CGRectGetMaxY(frame)+17.5, 40, 20) target:self sel:@selector(deleteButtonClick:) tag:0 image:nil title:@"删除" font:12];
        deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width-132.5-deleteButton.frame.size.width, CGRectGetMaxY(frame)+17.5, 120, 20) text:time font:12 alignment:@"right" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
        lineView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, CGRectGetMaxY(timeLabel.frame)+10, kScreenSize.width-25, 1) tag:0 color:@"#e6e6e6"];
        [self.bbsView addSubview:deleteButton];
    }else{
        timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width-132.5-deleteButton.frame.size.width, CGRectGetMaxY(frame)+17.5, 120, 20) text:time font:12 alignment:@"right" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
        lineView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, CGRectGetMaxY(timeLabel.frame)+10, kScreenSize.width-25, 1) tag:0 color:@"#e6e6e6"];
    }
    [self.bbsView addSubview:timeLabel];
    [self.bbsView addSubview:lineView];
    self.bbsView.frame = CGRectMake(0, 76, kScreenSize.width, lineView.frame.origin.y+lineView.frame.size.height);
    self.tabelHeaderView.frame = CGRectMake(0, 64, kScreenSize.width,self.userView.frame.size.height+self.bbsView.frame.size.height);
    self.tableView.tableHeaderView = self.tabelHeaderView;
}

-(void)deleteButtonClick:(UIButton *)button
{
    __weakSelf
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除话题" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *parameter = @{@"id":self.bbs_id,@"type":@"1",@"open_id":[ODUserInformation sharedODUserInformation].openID};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [weakSelf pushDataWithUrl:kDeleteReplyUrl parameter:signParameter isBbs:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 创建tableView
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64-50) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"ODCommunityDetailCell" bundle:nil] forCellReuseIdentifier:kCommunityDetailCellId];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODCommunityDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommunityDetailCellId];
    ODCommunityDetailModel *model = self.dataArray[indexPath.row];
   
    [cell.headButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:model.user[@"avatar_url"]] forState:UIControlStateNormal];
    [cell.headButton addTarget:self action:@selector(cellHeadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.replyButton addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.nickName.text = model.user[@"nick"];
    NSString *time = [[model.created_at substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@楼",time,[NSString stringWithFormat:@"%@",model.floor]];
    cell.replyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    //设置contentLabel显示不同的字体颜色
    CGFloat height;

    if ([model.content isEqualToString:@"该楼层已删除"]) {
        cell.contentLabel.text = model.content;
        height = [ODHelp textHeightFromTextString:model.content width:kScreenSize.width-26 fontSize:14];
        cell.contentLabelHeight.constant = height;
        cell.deleteButton.hidden = YES;
        cell.timeLabelSpace.constant = 13;
    }else{
        NSString *str = [NSString stringWithFormat:@"回复 %@ : %@",model.parent_user_nick,model.content];
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff6666" alpha:1] range:NSMakeRange(0, 2)];
        [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#000000" alpha:1] range:NSMakeRange(3, [model.parent_user_nick length])];
        cell.contentLabel.attributedText = noteStr;
        
        //根据内容的多少来设置contentLabel的高度
        height = [ODHelp textHeightFromTextString:str width:kScreenSize.width-26 fontSize:14];
        cell.contentLabelHeight.constant = height;
        if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:[NSString stringWithFormat:@"%@",model.user[@"open_id"]]]) {
            [cell.deleteButton setHidden:NO];
            cell.deleteButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
            cell.timeLabelSpace.constant = cell.timeLabelSpaceConstant;
        }else{
            [cell.deleteButton setHidden:YES];
            cell.timeLabelSpace.constant = 13;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.deleteButton addTarget:self action:@selector(cellDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.height = 40+height+22+26;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.height;
}

-(void)cellHeadButtonClick:(UIButton *)button
{
    ODCommunityDetailCell *cell = (ODCommunityDetailCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ODCommunityDetailModel *model = self.dataArray[indexPath.row];
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:model.user[@"open_id"]]) {
        
    }else{
        ODOthersInformationController *otherInfo = [[ODOthersInformationController alloc]init];
        otherInfo.open_id = [NSString stringWithFormat:@"%@",model.user[@"open_id"]];
        [self.navigationController pushViewController:otherInfo animated:YES];
    }
    
}

-(void)replyButtonClick:(UIButton *)button
{
    if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:@""]) {
        
        ODPersonalCenterViewController *personalCenter = [[ODPersonalCenterViewController alloc]init];
        [self.navigationController presentViewController:personalCenter animated:YES completion:nil];
        
    }else{
        
        ODCommunityDetailReplyViewController *detailReply = [[ODCommunityDetailReplyViewController alloc]init];
        detailReply.bbs_id = [NSString stringWithFormat:@"%@",self.bbs_id];
        if ([button.titleLabel.text isEqualToString:@"回复TA"]) {
            detailReply.parent_id = [NSString stringWithFormat:@"0"];
        }else{
            ODCommunityDetailCell *cell = (ODCommunityDetailCell *)button.superview.superview;
            NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
            ODCommunityDetailModel *model = self.dataArray[indexpath.row];
            detailReply.parent_id = [NSString stringWithFormat:@"%@",model.id];
        }
        __weakSelf
        detailReply.myBlock = ^(NSString *str,ODCommunityDetailModel *model){
            weakSelf.refresh = str;
        };
        [self.navigationController pushViewController:detailReply animated:YES];
    }
}

-(void)cellDeleteButtonClick:(UIButton *)button
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除回复" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weakSelf
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ODCommunityDetailCell *cell = (ODCommunityDetailCell *)button.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ODCommunityDetailModel *model = self.dataArray[indexPath.row];
        NSDictionary *parameter = @{@"id":[NSString stringWithFormat:@"%@",model.id],@"type":@"3",@"open_id":[ODUserInformation sharedODUserInformation].openID};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [weakSelf deleteDataWithUrl:kDeleteReplyUrl parameter:signParameter button:button];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - 删除回帖
-(void)deleteDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter button:(UIButton *)button
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    __weak typeof (self)weakSelf = self;
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([responseObject[@"status"]isEqualToString:@"success"]) {
            ODCommunityDetailCell *cell = (ODCommunityDetailCell *)button.superview.superview;
            NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:cell];
            ODCommunityDetailModel *model = weakSelf.dataArray[indexPath.row];
            model.content = @"该楼层已删除";
            [weakSelf.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            cell.deleteButton.hidden = YES;
            cell.timeLabelSpace.constant = 13;
            cell.contentLabel.text = @"该楼层已删除";
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];

}

#pragma mark－ 提交数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter isBbs:(BOOL)isBbs
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    __weak typeof (self)weakSelf = self;
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (isBbs) {
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                if (weakSelf.myBlock) {
                    weakSelf.myBlock(@"delSuccess");
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }else{
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建底部回复按钮
-(void)createReplyButton
{
    UIButton *button = [ODClassMethod creatButtonWithFrame:CGRectMake(0, kScreenSize.height-50-ODNavigationHeight, kScreenSize.width, 50) target:self sel:@selector(replyButtonClick:) tag:0 image:nil title:@"回复TA" font:16];
    button.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
    [button setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:button];
}


#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.refresh isEqualToString:@"refresh"]) {
        [self joiningTogetherParmetersWithUserInfo:NO];
        if (self.dataArray.count && self.tableView){
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.refresh = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
