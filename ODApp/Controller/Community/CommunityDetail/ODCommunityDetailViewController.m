//
//  ODCommunityDetailViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityDetailViewController.h"
#import "UMSocial.h"
@interface ODCommunityDetailViewController ()<UMSocialUIDelegate>

@end

@implementation ODCommunityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationInit];
    [self createReplyButton];
    [self createRequest];
    [self createTableView];
    [self joiningTogetherParmetersWithUserInfo:NO];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self joiningTogetherParmetersWithUserInfo:NO];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
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

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"话题详情" font:17 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //返回按钮
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];

    [self.headView addSubview:backButton];
    
    //分享按钮
    UIButton *shareButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width-37.5, 16, 44, 44) target:self sel:@selector(shareButtonClick:) tag:0 image:@"" title:nil font:0];
    UIImageView *shareImageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(kScreenSize.width-37.5, 28, 20, 20) imageName:@"话题详情-分享icon" tag:0];
    [self.headView addSubview:shareImageView];
    [self.headView addSubview:shareButton];
}

-(void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)shareButtonClick:(UIButton *)button
{
    ODCommunityDetailModel *model = self.resultArray[0];
    
    
    NSString *url = model.share[@"icon"];
    NSString *content = model.share[@"desc"];
    NSString *link = model.share[@"link"];
    NSString *title = model.share[@"title"];
    
    
    
    
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:url];
    
    
    
    
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"569dda54e0f55a994f0021cf"
                                      shareText:content
                                      shareImage:nil
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];

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
                weakSelf.tableView.tableHeaderView = weakSelf.tabelHeaderView;
                [weakSelf.tableView reloadData];
                if (weakSelf.dataArray.count)
                {
                    [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.dataArray.count - 1 inSection:0]atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }

    
                
            }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];
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
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
            if (result.count == 0) {
                [weakSelf.tableView.mj_footer noticeNoMoreData];
            }
        }

    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf createProgressHUDWithAlpha:1.0f withAfterDelay:0.8f title:@"网络异常"];
    }];
}

#pragma mark - 创建用户信息试图
-(void)createUserInfoView
{
    ODCommunityDetailModel *userModel = [self.userArray objectAtIndex:0];
    self.tabelHeaderView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 64, kScreenSize.width, 100) tag:0 color:@"#ffffff"];
    self.userView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, 0, kScreenSize.width-25, 76) tag:0 color:@"#ffffff"];
    [self.tabelHeaderView addSubview:self.userView];
    
    //头像
    UIButton *userHeaderButton = [ODClassMethod creatButtonWithFrame:CGRectMake(0, 13.5, 48, 48) target:self sel:@selector(userHeaderButtonClick:) tag:0 image:nil title:@"sds" font:0];
    [userHeaderButton sd_setBackgroundImageWithURL:[NSURL OD_URLWithString:userModel.avatar_url] forState:UIControlStateNormal];
    userHeaderButton.layer.masksToBounds = YES;
    userHeaderButton.layer.cornerRadius = 24;
    userHeaderButton.backgroundColor = [UIColor grayColor];
    [self.userView addSubview:userHeaderButton];
    
    //昵称
    UILabel *userNickLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(60, 10, 100, 20) text:userModel.nick font:15 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [self.userView addSubview:userNickLabel];
    
    //签名
    UILabel *userSignLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(60, 30, 150, 40) text:userModel.sign font:13 alignment:@"left" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
    [self.userView addSubview:userSignLabel];
    userSignLabel.numberOfLines = 2;
    
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 75, kScreenSize.width-25, 1) tag:0 color:@"#e6e6e6"];
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
    UILabel *bbsTitleLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(12.5, 17.5, kScreenSize.width-25, [ODHelp textHeightFromTextString:resultModel.title width:kScreenSize.width-25 fontSize:15]) text:resultModel.title font:15 alignment:@"left" color:@"#000000" alpha:1 maskToBounds:NO];
    [self.bbsView addSubview:bbsTitleLabel];
    
    //bbs内容
    UILabel *bbsContentLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(12.5, CGRectGetMaxY(bbsTitleLabel.frame)+17.5,kScreenSize.width-25, [ODHelp textHeightFromTextString:resultModel.content width:kScreenSize.width-25 fontSize:15]) text:resultModel.content font:14 alignment:@"left" color:@"#484848" alpha:1 maskToBounds:NO];
    [self.bbsView addSubview:bbsContentLabel];

    UIImageView *imageView = nil;
    UILabel *timeLabel = nil;
    UIButton *deleteButton = nil;
    //创建时间
    NSString *time = [[resultModel.created_at substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    if (resultModel.bbs_imgs.count) {
        //图片
        for (NSInteger i = 0; i < resultModel.bbs_imgs.count; i++) {
            imageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, CGRectGetMaxY(bbsContentLabel.frame)+17.5+(300+10)*i, kScreenSize.width, 300) imageName:nil tag:0];
            [imageView sd_setImageWithURL:[NSURL OD_URLWithString:resultModel.bbs_imgs[i]]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.bbsView addSubview:imageView];
        }
        if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:userModel.open_id]) {
            //删除按钮
            deleteButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width-50, CGRectGetMaxY(imageView.frame)+17.5, 40, 20) target:self sel:@selector(deleteButtonClick:) tag:0 image:nil title:@"删除" font:15];
            [self.bbsView addSubview:deleteButton];
        }else{
            
        }
        timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width-142.5-deleteButton.frame.size.width, CGRectGetMaxY(imageView.frame)+17.5, 120, 20) text:time font:15 alignment:@"right" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
        [self.bbsView addSubview:timeLabel];
      
    }else{
        if ([[ODUserInformation sharedODUserInformation].openID isEqualToString:userModel.open_id]) {
            deleteButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width-50, CGRectGetMaxY(bbsContentLabel.frame)+17.5, 40, 20) target:self sel:@selector(deleteButtonClick:) tag:0 image:nil title:@"删除" font:15];
            [self.bbsView addSubview:deleteButton];
        }else{
            
        }
        timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width-142.5-deleteButton.frame.size.width, CGRectGetMaxY(bbsContentLabel.frame)+17.5, 120, 20) text:time font:15 alignment:@"right" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
        [self.bbsView addSubview:timeLabel];
    }
    UIView *lineView = [ODClassMethod creatViewWithFrame:CGRectMake(12.5, CGRectGetMaxY(timeLabel.frame)+10, kScreenSize.width-25, 1) tag:0 color:@"#e6e6e6"];
    [self.bbsView addSubview:lineView];
    self.bbsView.frame = CGRectMake(0, 76, kScreenSize.width, lineView.frame.origin.y+lineView.frame.size.height);
    self.tabelHeaderView.frame = CGRectMake(0, 64, kScreenSize.width,self.userView.frame.size.height+self.bbsView.frame.size.height);
}

-(void)deleteButtonClick:(UIButton *)button
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除话题" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *parameter = @{@"id":self.bbs_id,@"type":@"1",@"open_id":[ODUserInformation sharedODUserInformation].openID};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [self pushDataWithUrl:kDeleteReplyUrl parameter:signParameter isBbs:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - 创建tableView
-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenSize.width, kScreenSize.height-64-50) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ODCommunityDetailCell" bundle:nil] forCellReuseIdentifier:kCommunityDetailCellId];
    [self.view addSubview:self.tableView];
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
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %ld楼",time,indexPath.row+1];
   
    //设置contentLabel显示不同的字体颜色
    CGFloat height;
    if ([model.content isEqualToString:@"该楼层已删除"]) {
        cell.contentLabel.text = model.content;
        height = [ODHelp textHeightFromTextString:model.content width:kScreenSize.width-26 fontSize:14];
        cell.contentLabelHeight.constant = height;
        [cell.deleteButton removeFromSuperview];
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
            
        }else{
            [cell.deleteButton removeFromSuperview];
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
            detailReply.parent_id = [NSString stringWithFormat:@"3"];
        }
        detailReply.myBlock = ^(NSString *str){
            self.refresh = str;
        };
        [self.navigationController pushViewController:detailReply animated:YES];
    }
}

-(void)cellDeleteButtonClick:(UIButton *)button
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否删除回复" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ODCommunityDetailCell *cell = (ODCommunityDetailCell *)button.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ODCommunityDetailModel *model = self.dataArray[indexPath.row];
        NSDictionary *parameter = @{@"id":[NSString stringWithFormat:@"%@",model.id],@"type":@"3",@"open_id":[ODUserInformation sharedODUserInformation].openID};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        [self pushDataWithUrl:kDeleteReplyUrl parameter:signParameter isBbs:NO];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark－ 提交数据
-(void)pushDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter isBbs:(BOOL)isBbs
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    __weak typeof (self)weakSelf = self;
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (isBbs) {
            NSLog(@"%@",responseObject);
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                if (weakSelf.myBlock) {
                    weakSelf.myBlock(@"refresh");
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }else{
            NSLog(@"%@",responseObject);
            if ([responseObject[@"status"]isEqualToString:@"success"]) {
                [weakSelf joiningTogetherParmetersWithUserInfo:NO];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 创建底部回复按钮
-(void)createReplyButton
{
    UIButton *button = [ODClassMethod creatButtonWithFrame:CGRectMake(0, kScreenSize.height - 50, kScreenSize.width, 50) target:self sel:@selector(replyButtonClick:) tag:0 image:nil title:@"回复TA" font:16];
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
    }
    self.navigationController.navigationBar.hidden = YES;

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
@end
