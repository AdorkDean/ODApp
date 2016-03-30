//
//  ODBazaarReleaseSkillTimeViewController.m
//  ODApp
//
//  Created by Odong-YG on 16/2/5.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "ODRoundTimeDrawView.h"
#import "ODBazaarReleaseSkillTimeViewController.h"
#import "ODBazaarReleaseSkillTimeModel.h"
#import <MJExtension.h>

#define cellID @"ODBazaarReleaseSkillTimeViewCell"

@interface ODBazaarReleaseSkillTimeViewController ()
/**
 *  圆圈的数组
 */
@property (nonatomic, strong) NSMutableArray *roundViews;


@end



@implementation ODBazaarReleaseSkillTimeViewController
@synthesize dataArray = _dataArray;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的可服务时段";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(rightItmeClick:) color:[UIColor blackColor] highColor:nil title:@"确定"];
    
    [self createTimeView];
    [self createTableView];
    [self joiningTogetherParmeters];
}

-(void)rightItmeClick:(UIButton *)button
{
    __weakSelf;
    if(self.myBlock) {
        NSMutableArray *array = [ODBazaarReleaseSkillTimeModel mj_keyValuesArrayWithObjectArray:weakSelf.dataArray];
        weakSelf.myBlock(array);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
        label.textColor = [UIColor colorRedColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];
    }
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count)
    {
        dataArray = [ODBazaarReleaseSkillTimeModel mj_objectArrayWithKeyValuesArray:dataArray];
    }
    
    _dataArray = dataArray;
}

#pragma mark - 拼接参数
-(void)joiningTogetherParmeters
{
    // 拼接参数
    NSDictionary *parameter;
    if (self.swap_id) {
        parameter = @{@"swap_id":self.swap_id};
    }else{
        parameter = @{@"swap_id":@"0"};
    }
    
    __weakSelf;
    // 发送请求
    [ODHttpTool getWithURL:ODUrlSwapSchedule parameters:parameter modelClass:[ODBazaarReleaseSkillTimeModel class] success:^(id model) {
        
        if ( !weakSelf.dataArray.count ) {
//            NSArray *array = [model result];
            [weakSelf.dataArray addObjectsFromArray:[model result]];
        }
        
        for (NSInteger i = 0; i < weakSelf.roundViews.count; i++)
        {
            ODRoundTimeDrawView *view = weakSelf.roundViews[i];
            
            ODBazaarReleaseSkillTimeModel *firstTime = weakSelf.dataArray[i * 3];
            view.firstTimeIsFree = [firstTime.status boolValue];
            
            ODBazaarReleaseSkillTimeModel *secondTime = weakSelf.dataArray[i * 3 + 1];
            view.secondTimeIsFree = [secondTime.status boolValue];
            
            ODBazaarReleaseSkillTimeModel *thirdTime = weakSelf.dataArray[i * 3 + 2];
            view.thirdTimeIsFree = [thirdTime.status boolValue];
        }
        [weakSelf.tableView reloadData];

    } failure:^(NSError *error) {
        
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
    return self.dataArray.count ? 7 : 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count ? 3 : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ODBazaarReleaseSkillTimeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    ODBazaarReleaseSkillTimeModel *timeModel = self.dataArray[indexPath.section * 3 + indexPath.row];
    [cell.openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    if ([timeModel isKindOfClass:[NSDictionary class]])
//    {
//        timeModel = [ODBazaarReleaseSkillTimeModel mj_objectWithKeyValues:timeModel];
//    }
    
    cell.timeLabel.text = timeModel.display;
    cell.status = [timeModel.status boolValue];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, 40)];
    view.backgroundColor = [UIColor lineColor];
    
    NSArray *array = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, kScreenSize.width-10, 10)];
    label.text = [array objectAtIndex:section];
    label.textColor = [UIColor colorGreyColor];
    label.font = [UIFont systemFontOfSize:12];
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
    NSDictionary *dict = self.dataArray[indexPath.section * 3 + indexPath.row];
    [dict setValue:[NSString stringWithFormat:@"%d",!button.selected] forKeyPath:@"status"];
    
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
