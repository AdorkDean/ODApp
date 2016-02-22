//
//  ODBazaarReleaseSkillTimeViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "ODRoundTimeDrawView.h"
#import "ODBazaarReleaseSkillTimeViewController.h"

#define cellID @"ODBazaarReleaseSkillTimeViewCell"

@interface ODBazaarReleaseSkillTimeViewController ()
/**
 *  圆圈的数组
 */
@property (nonatomic, strong) NSMutableArray *roundViews;
@end

@implementation ODBazaarReleaseSkillTimeViewController
- (NSMutableArray *)roundViews
{
    if (!_roundViews)
    {
        _roundViews = [NSMutableArray array];
    }
    return _roundViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index1 = 1;
    self.index2 = 1;
    self.index3 = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    self.navigationItem.title = @"我的可服务时段";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(rightItmeClick:) color:[UIColor colorWithHexString:@"#000000" alpha:1] highColor:nil title:@"确定"];
    
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
    for (NSInteger i = 0; i < array.count; i++)
    {
        ODRoundTimeDrawView *imageView = [[ODRoundTimeDrawView alloc]initWithFrame:CGRectMake(15+(imgWidth+15)*i, 12.5, imgWidth, imgWidth)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imgWidth/2;
        [self.view addSubview:imageView];
        [self.roundViews addObject:imageView];
        
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
    self.mArray = [[NSMutableArray alloc]init];
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
            for (NSMutableDictionary *itemDict in result) {
                [weakSelf.dataArray addObject:itemDict];
            }
            for (NSInteger i = 0; i < 7; i++) {
                NSMutableArray *array = [NSMutableArray array];
                for (NSInteger j = 0; j < 3; j++) {
                    NSMutableDictionary *dict = [weakSelf.dataArray objectAtIndex:i*3+j];
                    [array addObject:dict];
                }
                [weakSelf.mArray addObject:array];
            }
            [weakSelf.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
    }];
}

-(void)createTableView
{
    CGFloat imgWidth = (kScreenSize.width-30-90)/7;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54+imgWidth, kScreenSize.width, kScreenSize.height-64-54-imgWidth) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ODBazaarReleaseSkillTimeViewCell" bundle:nil] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.mArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.mArray objectAtIndex:section]count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarReleaseSkillTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSMutableDictionary *dict = [[self.mArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    [cell.openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.openButton setBackgroundImage:[UIImage imageNamed:@"button_on_icon"] forState:UIControlStateNormal];
    cell.timeLabel.text = dict[@"display"];
    self.status = [NSString stringWithFormat:@"%@",dict[@"status"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 40)];
    view.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    
    NSArray *array = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreenSize.width-10, 10)];
    label.text = [array objectAtIndex:section];
    label.textColor = [UIColor colorWithHexString:@"#b0b0b0" alpha:1];
    label.font = [UIFont systemFontOfSize:10];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)openButtonClick:(UIButton *)button
{
    NSLog(@"%d",button.selected);
    button.selected = !button.isSelected;
    NSLog(@"%d",button.selected);
    ODBazaarReleaseSkillTimeViewCell *cell = (ODBazaarReleaseSkillTimeViewCell *)button.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ODRoundTimeDrawView *view = self.roundViews[indexPath.section];
    if (indexPath.row == 0)
    {
        view.firstTimeIsFree = !button.selected;
    }
    else if (indexPath.row == 1)
    {
        view.secondTimeIsFree = !button.selected;
    }
    else if (indexPath.row == 2)
    {
        view.thirdTimeIsFree = !button.selected;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
