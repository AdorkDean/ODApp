//
//  ODBazaarReleaseSkillTimeViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODBazaarReleaseSkillTimeViewController.h"

#define cellID @"ODBazaarReleaseSkillTimeViewCell"

@interface ODBazaarReleaseSkillTimeViewController ()

@end

@implementation ODBazaarReleaseSkillTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    self.navigationItem.title = @"我的可服务时段";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(rightItmeClick:) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"保存"];
  
    [self createTimeView];
    [self createRequest];
    [self createTableView];
    [self joiningTogetherParmeters];
    
    
}

-(void)rightItmeClick:(UIButton *)button
{
    
}

-(void)createTimeView
{
    NSArray *array = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    CGFloat imgWidth = (kScreenSize.width-30-90)/7;
    CGFloat labelWidth = (kScreenSize.width-15)/7;
    for (NSInteger i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15+(imgWidth+15)*i, 10, imgWidth, imgWidth)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imgWidth/2;
        imageView.image = [UIImage imageNamed:@"time4_icon"];
        [self.view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(7.5+labelWidth*i, CGRectGetMaxY(imageView.frame)+9, labelWidth, 20)];
        label.text = array[i];
        label.textColor = [UIColor colorWithHexString:@"#ff6666" alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
}

-(void)createRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.dataArray = [[NSMutableArray alloc]init];
}
#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    NSDictionary *parameter = @{};
    NSDictionary *signParameter = [ODAPIManager signParameters:parameter];
    [self downLoadDataWithUrl:kBazaarReleaseSkillTimeUrl parameter:signParameter];
}

-(void)downLoadDataWithUrl:(NSString *)url parameter:(NSDictionary *)parameter
{
    __weakSelf;
    [self.manager GET:url parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = dict[@"result"];
            for (NSDictionary *itemDict in result) {
                ODBazaarReleaseSkillTimeModel *model = [[ODBazaarReleaseSkillTimeModel alloc]init];
                [model setValuesForKeysWithDictionary:itemDict];
                [weakSelf.dataArray addObject:model];
                [weakSelf.tableView reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, kScreenSize.width, kScreenSize.height-64-70)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ODBazaarReleaseSkillTimeViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarReleaseSkillTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    ODBazaarReleaseSkillTimeModel *model = [[ODBazaarReleaseSkillTimeModel alloc]init];
    if (indexPath.section == 0) {
        for (NSInteger i = 0; i < 3;i++) {
          model = [self.dataArray objectAtIndex:i];
        }
    }else if (indexPath.section == 1){
        for (NSInteger i = 3; i < 6;i++) {
            model = [self.dataArray objectAtIndex:i];
        }
    }else if (indexPath.section == 2){
        for (NSInteger i = 6; i < 9;i++) {
            model = [self.dataArray objectAtIndex:i];
        }
    }else if (indexPath.section == 3){
        for (NSInteger i = 9; i < 12;i++) {
            model = [self.dataArray objectAtIndex:i];
        }
    }else if (indexPath.section == 4){
        for (NSInteger i = 12; i < 15;i++) {
            model = [self.dataArray objectAtIndex:i];
        }
    }else if (indexPath.section == 5){
        for (NSInteger i = 15; i < 18;i++) {
            model = [self.dataArray objectAtIndex:i];
        }
    }else if (indexPath.section == 6){
        for (NSInteger i = 18; i < 21;i++) {
            model = [self.dataArray objectAtIndex:i];
        }
    }
    [cell showDataWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *array = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreenSize.width-10, 20)];
    label.text = [array objectAtIndex:section];
    label.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    label.font = [UIFont systemFontOfSize:14];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 50;
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
