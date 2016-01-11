//
//  ODCommunityDetailViewController.m
//  ODApp
//
//  Created by Odong-YG on 15/12/25.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCommunityDetailViewController.h"

@interface ODCommunityDetailViewController ()

@end

@implementation ODCommunityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigationInit];
    [self createReplyButton];
    [self createRequest];
    [self joiningTogetherParmetersWithUserInfo:YES];
    
}

#pragma mark - 初始化导航
-(void)navigationInit
{
    self.navigationController.navigationBar.hidden = YES;
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    //标题
    UILabel *label = [ODClassMethod creatLabelWithFrame:CGRectMake((kScreenSize.width-80)/2, 28, 80, 20) text:@"话题详情" font:16 alignment:@"center" color:@"#000000" alpha:1 maskToBounds:NO];
    label.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:label];
    
    //返回按钮
    UIButton *backButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 28,32, 20) target:self sel:@selector(backButtonClick:) tag:0 image:nil title:@"返回" font:16];
    [backButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.headView addSubview:backButton];
    
    //分享按钮
    UIButton *shareButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width-37.5, 28, 20, 20) target:self sel:@selector(shareButtonClick:) tag:0 image:@"话题详情-分享icon" title:nil font:0];
    [self.headView addSubview:shareButton];
}

-(void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)shareButtonClick:(UIButton *)button
{
    
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
        [self downLoadDataWithUrl:kCommunityBbsDetailUrl paramater:signParameter withUserInfo:YES];
    }else{
        NSDictionary *parameter = @{@"bbs_id":self.bbs_id,@"page":@"1"};
        NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
        NSLog(@"%@",signParameter);
        [self downLoadDataWithUrl:kCommunityBbsReplyListUrl paramater:signParameter withUserInfo:NO];
    }
}

#pragma mark - 请求发帖人信息
-(void)downLoadDataWithUrl:(NSString *)url paramater:(NSDictionary *)paramater withUserInfo:(BOOL)userInfo
{
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:paramater success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (userInfo) {
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
                [self joiningTogetherParmetersWithUserInfo:NO];
            }
        }else{
            if (responseObject) {
                [self.dataArray removeAllObjects];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSArray *result = dict[@"result"];
                for (NSDictionary *itemDict in result) {
                    ODCommunityDetailModel *model = [[ODCommunityDetailModel alloc]init];
                    [model setValuesForKeysWithDictionary:itemDict];
                    [self.dataArray addObject:model];
                }
                
                [weakSelf.tableView reloadData];
                [weakSelf createTableView];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
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
    [userHeaderButton sd_setBackgroundImageWithURL:[NSURL URLWithString:userModel.avatar_url] forState:UIControlStateNormal];
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
    ODCommunityDetailReplyViewController *detailReply = [[ODCommunityDetailReplyViewController alloc]init];
    [self.navigationController pushViewController:detailReply animated:YES];
}

#pragma marl - 创建bbs详情试图
-(void)createBBSDetailView
{
    ODCommunityDetailModel *resultModel = [self.resultArray objectAtIndex:0];
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
            imageView = [ODClassMethod creatImageViewWithFrame:CGRectMake(0, CGRectGetMaxY(bbsContentLabel.frame)+17.5+(140+10)*i, kScreenSize.width, 140) imageName:nil tag:0];
            [imageView sd_setImageWithURL:[NSURL URLWithString:resultModel.bbs_imgs[i]]];
            [self.bbsView addSubview:imageView];
        }
        if ([self.open_id isEqualToString:@"123"]) {
            //删除按钮
            deleteButton = [ODClassMethod creatButtonWithFrame:CGRectMake(kScreenSize.width-50, CGRectGetMaxY(imageView.frame)+17.5, 40, 20) target:self sel:@selector(deleteButtonClick:) tag:0 image:nil title:@"删除" font:15];
            [self.bbsView addSubview:deleteButton];
        }else{
            
        }
        timeLabel = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width-142.5-deleteButton.frame.size.width, CGRectGetMaxY(imageView.frame)+17.5, 120, 20) text:time font:15 alignment:@"right" color:@"#b0b0b0" alpha:1 maskToBounds:NO];
        [self.bbsView addSubview:timeLabel];
      
    }else{
        if ([self.open_id isEqualToString:@"123"]) {
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
    self.tableView.tableHeaderView = self.tabelHeaderView;
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
   
    [cell.headButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.user[@"avatar_url"]] forState:UIControlStateNormal];
    [cell.replyButton addTarget:self action:@selector(replyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.nickName.text = model.user[@"nick"];
    NSString *time = [[model.created_at substringFromIndex:5] stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@ %ld楼",time,indexPath.row+1];
   
    //设置contentLabel显示不同的字体颜色
    NSString *str = [NSString stringWithFormat:@"回复 %@ : %@",model.parent_user_nick,model.content];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc]initWithString:str];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[ODColorConversion colorWithHexString:@"#ff6666" alpha:1] range:NSMakeRange(0, 2)];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[ODColorConversion colorWithHexString:@"#000000" alpha:1] range:NSMakeRange(3, [model.parent_user_nick length])];
    cell.contentLabel.attributedText = noteStr;

    //根据内容的多少来设置contentLabel的高度
    CGFloat height = [ODHelp textHeightFromTextString:str width:kScreenSize.width-26 fontSize:14];
    cell.contentLabelHeight.constant = height;
    
    [cell.deleteButton addTarget:self action:@selector(cellDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if ([self.open_id isEqualToString:@"11"]) {
        
    }else{
        [cell.deleteButton removeFromSuperview];
        cell.timeLabelSpace.constant = 13;

    }
    self.height = 40+height+22+26;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.height;
}

-(void)replyButtonClick:(UIButton *)button
{
    ODCommunityDetailReplyViewController *detailReply = [[ODCommunityDetailReplyViewController alloc]init];
    detailReply.bbs_id = [NSString stringWithFormat:@"%@",self.bbs_id];
    if ([button.titleLabel.text isEqualToString:@"回复TA"]) {
        detailReply.parent_id = [NSString stringWithFormat:@"0"];
    }else{
        detailReply.parent_id = [NSString stringWithFormat:@"3"];
    }
    [self.navigationController pushViewController:detailReply animated:YES];
}

-(void)cellDeleteButtonClick:(UIButton *)button
{
    
}

#pragma mark - 创建底部回复按钮
-(void)createReplyButton
{
    UIButton *button = [ODClassMethod creatButtonWithFrame:CGRectMake(0, kScreenSize.height - 50, kScreenSize.width, 50) target:self sel:@selector(replyButtonClick:) tag:0 image:nil title:@"回复TA" font:16];
    button.backgroundColor = [ODColorConversion colorWithHexString:@"#ffd801" alpha:1];
    [button setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

#pragma mark - 试图将要出现
-(void)viewWillAppear:(BOOL)animated
{
    [self joiningTogetherParmetersWithUserInfo:NO];
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
