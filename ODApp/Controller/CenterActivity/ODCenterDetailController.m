//
//  ODCenterDetailController.m
//  ODApp
//
//  Created by zhz on 15/12/24.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODCenterDetailController.h"
#import "ODCenderDetailView.h"
#import "ODAPIManager.h"
#import "AFNetworking.h"
#import "CenterDetailModel.h"
#import "UIImageView+WebCache.h"
#import "ODChoseCenterController.h"
#import "ODCenterYuYueController.h"
#import "CenterDetailCell.h"
#import "MJRefresh.h"
#import "CenterActivityModel.h"
#import "ODActivityDetailController.h"
#import "ODTabBarController.h"
#import "ODUserInformation.h"
#import "ODPersonalCenterViewController.h"
int pageNumnber = 0;

@interface ODCenterDetailController ()<UITableViewDataSource , UITableViewDelegate>


@property(nonatomic , strong) UIView *headView;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) ODCenderDetailView *centerDetailView;

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)AFHTTPRequestOperationManager *managers;
@property(nonatomic,strong)CenterDetailModel *model;

@property(nonatomic,strong)UIPageControl *pageControl;


@property (nonatomic , strong) UILabel *centerNameLabe;

@property(nonatomic,strong) NSTimer *myTimer;

@property(nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ODCenterDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
  
    
     [self getData];
  

     [self navigationInit];

  
    
    
   
    
}

#pragma mark - lifeCycle
- (void)viewWillAppear:(BOOL)animated
{
    
    pageNumnber = 0;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.myTimer forMode:NSRunLoopCommonModes];
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 0;

    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.myTimer invalidate];
    self.myTimer = nil;
    
    ODTabBarController *tabBar = (ODTabBarController *)self.navigationController.tabBarController;
    tabBar.imageView.alpha = 1;

   
}

#pragma mark - 点击事件
- (void)appointmentAction:(UIButton *)sender
{
    
    if ([ODUserInformation getData].openID == nil) {
        
        ODPersonalCenterViewController *vc = [[ODPersonalCenterViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        
    }else{
        ODCenterYuYueController *vc = [[ODCenterYuYueController alloc] init];
        
        
        vc.centerName = self.model.name;
        vc.storeId = self.storeId;
        vc.phoneNumber = self.centerDetailView.phoneLabel.text;
        [self.navigationController pushViewController:vc animated:YES];

    }
  }


-(void)fanhui:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)phoneAction:(UITapGestureRecognizer *)sender
{
    
    
    
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.centerDetailView.phoneLabel.text];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    
    
    
}


#pragma mark - 定时器
- (void)timerFired
{
    pageNumnber ++;
    if (pageNumnber == self.model.pics.count) {
        [self.centerDetailView.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];

        pageNumnber = 0;
    }else {
        
        [self.centerDetailView.scrollerView setContentOffset:CGPointMake(pageNumnber * kScreenSize.width, 0) animated:YES];

    }
    
    
    self.pageControl.currentPage = pageNumnber ;
    
    
    
}

#pragma mark - 请求数据
- (void)getDetailData
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc] init];
    
    
    NSDictionary *parameter = @{@"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.odong.com/1.0/store/apply/list";
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableArray *result = dict[@"result"];
            
            [weakSelf.dataArray removeAllObjects];
            
            for (NSDictionary *itemDict in result) {
                CenterActivityModel *model = [[CenterActivityModel alloc] initWithDict:itemDict];
                
                
                [weakSelf.dataArray addObject:model];
            }
           
            [weakSelf.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
    

}



- (void)getData
{
    
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *parameter = @{@"store_id":self.storeId};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    
    NSString *url = @"http://woquapi.odong.com/1.0/other/store/detail";
    
    __weak typeof (self)weakSelf = self;
    [self.manager GET:url parameters:signParameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *result = dict[@"result"];
            
          
            self.model = [[CenterDetailModel alloc] initWithDict:result];
            
          
                       [weakSelf createTableView];
            
                       [weakSelf.tableView reloadData];
           
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        
        
        
    }];
    
    
}


#pragma mark - 初始化

-(void)navigationInit
{
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];;
    self.navigationController.navigationBar.hidden = YES;
    
    self.headView = [ODClassMethod creatViewWithFrame:CGRectMake(0, 0, kScreenSize.width, 64) tag:0 color:@"f3f3f3"];
    [self.view addSubview:self.headView];
    
    // 中心活动label
    self.centerNameLabe = [ODClassMethod creatLabelWithFrame:CGRectMake(kScreenSize.width / 2 - 110, 28, 220, 20) text:@"中心详情" font:17 alignment:@"center" color:@"#000000" alpha:1];
    
    self.centerNameLabe.backgroundColor = [UIColor clearColor];
    [self.headView addSubview:self.centerNameLabe];
    
    
    
    
    
    
    // 返回button
<<<<<<< HEAD
    UIButton *fanhuiButton = [ODClassMethod creatButtonWithFrame:CGRectMake(-20, 28,90, 20) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:17];
    [fanhuiButton setTitleColor:[UIColor colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
=======
    UIButton *fanhuiButton = [ODClassMethod creatButtonWithFrame:CGRectMake(17.5, 16,44, 44) target:self sel:@selector(fanhui:) tag:0 image:nil title:@"返回" font:16];
    fanhuiButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [fanhuiButton setTitleColor:[ODColorConversion colorWithHexString:@"#000000" alpha:1] forState:UIControlStateNormal];
>>>>>>> ab9b6b0ccedcaaee159908d6427c4c8f0fa3d1a6
    [self.headView addSubview:fanhuiButton];
    
    
    
    
}

- (void)createTableView
{
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 , kScreenSize.width, kScreenSize.height - 64  - 4) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = self.centerDetailView;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];

    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
   
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterDetailCell" bundle:nil] forCellReuseIdentifier:@"item"];
    
    
      [self getDetailData];
    
    [self.view addSubview:self.tableView];
    
    
    
}




#pragma mark - 懒加载
- (ODCenderDetailView *)centerDetailView
{
    if (_centerDetailView == nil) {
        
        
        CGRect rect = [self.model.desc boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20,0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}
                                                    context:nil];
        
        self.centerDetailView = [ODCenderDetailView getView];
        
      
        
        if (iPhone4_4S) {
            self.centerDetailView.scrollerHeight.constant = 210;
            
        }else if (iPhone5_5s) {
            
            self.centerDetailView.scrollerHeight.constant = 210;
        }else if (iPhone6_6s) {
            
            self.centerDetailView.scrollerHeight.constant = 270;
            
        }else {
            self.centerDetailView.scrollerHeight.constant = 290;
        }
        
        
        if (iPhone4_4S) {
            self.centerDetailView.frame = CGRectMake(0, 0, kScreenSize.width, 230 + kScreenSize.height / 10 +  self.centerDetailView.scrollerHeight.constant +  rect.size.height);
            
        }else if (iPhone5_5s) {
            
            self.centerDetailView.frame = CGRectMake(0, 0, kScreenSize.width, 230 + kScreenSize.height / 12 +  self.centerDetailView.scrollerHeight.constant +  rect.size.height);
            
        }else if (iPhone6_6s) {
            
            self.centerDetailView.frame = CGRectMake(0, 0, kScreenSize.width, 230 + kScreenSize.height / 14 +  self.centerDetailView.scrollerHeight.constant +  rect.size.height);
            
            
        }else {
            self.centerDetailView.frame = CGRectMake(0, 0, kScreenSize.width, 230 + kScreenSize.height / 16 +  self.centerDetailView.scrollerHeight.constant +  rect.size.height);
            
        }
        
        
        
        self.centerDetailView.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];

        
        self.centerDetailView.detailTextView.layer.masksToBounds = YES;
        self.centerDetailView.detailTextView.layer.cornerRadius = 5;
        self.centerDetailView.detailTextView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.centerDetailView.detailTextView.layer.borderWidth = 1;
        self.centerDetailView.detailTextView.text = self.model.desc;
        self.centerDetailView.detailTextView.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
        self.centerDetailView.detailTextView.scrollEnabled = NO;
        
        self.centerDetailView.informationLabel.layer.masksToBounds = YES;
        self.centerDetailView.informationLabel.layer.cornerRadius = 5;
        self.centerDetailView.informationLabel.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        self.centerDetailView.informationLabel.layer.borderWidth = 1;

         self.centerDetailView.firstLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
         self.centerDetailView.secondLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
         self.centerDetailView.thirdLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
         self.centerDetailView.fourLabel.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];

        
        self.centerDetailView.centerNameLabel.text = self.model.name;
        self.centerDetailView.centerNameLabel.textColor = [UIColor colorWithHexString:@"#014cdb" alpha:1];
        
        
        self.centerDetailView.phoneLabel.text = self.model.tel;
        self.centerDetailView.phoneLabel.textColor = [UIColor colorWithHexString:@"#014cdb" alpha:1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneAction:)];
        
        
        [self.centerDetailView.phoneLabel addGestureRecognizer:tap];
        
        
        self.centerDetailView.addressLabel.text = self.model.address;
        self.centerDetailView.addressLabel.textColor = [UIColor colorWithHexString:@"#014cdb" alpha:1];
        
        self.centerDetailView.timeTextView.text = self.model.business_hours;
        self.centerDetailView.timeTextView.textColor = [UIColor colorWithHexString:@"#484848" alpha:1];
        self.centerDetailView.timeTextView.scrollEnabled = NO;
        
        
        [self.centerDetailView.appointmentButton setTitleColor:[UIColor colorWithHexString:@"#484848" alpha:1] forState:UIControlStateNormal];
        self.centerDetailView.appointmentButton.layer.masksToBounds = YES;
       self.centerDetailView.appointmentButton.layer.cornerRadius = 5;
        self.centerDetailView.appointmentButton.layer.borderColor = [UIColor colorWithHexString:@"b0b0b0" alpha:1].CGColor;
       self.centerDetailView.appointmentButton.layer.borderWidth = 1;
       self.centerDetailView.appointmentButton.backgroundColor = [UIColor colorWithHexString:@"#ffd801" alpha:1];
        [self.centerDetailView.appointmentButton addTarget:self action:@selector(appointmentAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        // 设置scrollerView的内容视图大小
        self.centerDetailView.scrollerView.contentSize = CGSizeMake(self.model.pics.count * kScreenSize.width,  self.centerDetailView.scrollerHeight.constant);
        // 设置整页滑动
         self.centerDetailView.scrollerView.pagingEnabled = YES;
        // 隐藏滚动条
        self.centerDetailView.scrollerView.showsHorizontalScrollIndicator = NO;
        self.centerDetailView.scrollerView.delegate = self;

        // 创建图片
        for (int i = 0; i < self.model.pics.count; i++) {
            
            
            // 创建imageView;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenSize.width, 0, kScreenSize.width, self.centerDetailView.scrollerHeight.constant)];
            
            NSString *url = self.model.pics[i];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
            
            
            // imageView添加到scroller上
            [self.centerDetailView.scrollerView addSubview:imageView];
            
            
        }
        
        
        // 创建pageControl
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.centerDetailView.scrollerHeight.constant - 30, 100, 20)];
        self.pageControl.backgroundColor = [UIColor clearColor];
        
        // 给pageControl设置点的个数
        self.pageControl.numberOfPages = self.model.pics.count;
        
        
        // 设置默认选中的点
        self.pageControl.currentPage = 0;
        
        // 当前选中点的颜色
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        
        // 未被选中点的颜色
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        
        
        self.pageControl.userInteractionEnabled = YES;
        
        
        
        [self.centerDetailView addSubview:self.pageControl];
        
        
        
        
    }
    return _centerDetailView;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     CenterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    
    
    if (iPhone4_4S) {
        cell.toRightSpace.constant = 210;
    }else if (iPhone5_5s){
        cell.toRightSpace.constant = 210;
    }else if (iPhone6_6s){
        cell.toRightSpace.constant = 260;
    }else{
        cell.toRightSpace.constant = 300;
        
    }

    cell.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];

    
    cell.coverImageView.layer.masksToBounds = YES;
    cell.coverImageView.layer.cornerRadius = 7;
    cell.coverImageView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
    cell.coverImageView.layer.borderWidth = 1;

    
    
    CenterActivityModel *model = self.dataArray[indexPath.section];
    
    cell.titleLabel.text = model.content;
    cell.timeLabel.text = model.date_str;
    cell.addressLabel.text = model.address;
    [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    
    cell.timeLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1" alpha:1];
    cell.addressLabel.textColor = [UIColor colorWithHexString:@"#b1b1b1" alpha:1];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CenterActivityModel *model = self.dataArray[indexPath.section];
    ODActivityDetailController *vc =  [[ODActivityDetailController alloc] init];
    vc.activityId = [NSString stringWithFormat:@"%ld" , (long)model.activity_id];
    vc.storeId = self.storeId;
   
    
     
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 100)];
    view.backgroundColor = [UIColor colorWithHexString:@"#d9d9d9" alpha:1];

    
    return view;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
