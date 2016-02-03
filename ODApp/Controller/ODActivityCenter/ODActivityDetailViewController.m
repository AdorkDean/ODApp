//
//  ODActivityDetailViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "ODHttpTool.h"
#import "UIImageView+WebCache.h"
#import "ODActivityDetailModel.h"
#import "ODActivityDetailViewController.h"

#import "ODActivityBottomCell.h"
#import "ODActivityDetailHeadImgViewCell.h"
#import "ODActivityDetailInfoViewCell.h"
#import "ODActivityVIPCell.h"
#import "ODActivityDetailContentCell.h"

@interface ODActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
/**
 *  活动嘉宾
 */
@property (nonatomic, strong) NSArray *activityVIPs;
/**
 *  申请人
 */
@property (nonatomic, strong) NSArray *activityApplies;
/**
 *  从服务器获取到的数据
 */
@property (nonatomic, strong) ODActivityDetailModel *resultModel;


@end

@implementation ODActivityDetailViewController

static NSString * const detailInfoCell = @"detailInfoCell";
static NSString * const headImgCell = @"headImgCell";
static NSString * const VIPCell = @"VIPCell";
static NSString * const detailContentCell = @"detailContentCell";
static NSString * const bottomCell = @"bottomCell";

#pragma mark - lazyLoad

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView.estimatedRowHeight = 200;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailHeadImgViewCell class]) bundle:nil] forCellReuseIdentifier:headImgCell];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailInfoViewCell class]) bundle:nil] forCellReuseIdentifier:detailInfoCell];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityVIPCell class]) bundle:nil] forCellReuseIdentifier:VIPCell];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailContentCell class]) bundle:nil] forCellReuseIdentifier:detailContentCell];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityBottomCell class]) bundle:nil] forCellReuseIdentifier:bottomCell];
        _tableView = tableView;
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    [self.view addSubview:self.tableView];
    [self requestData];
}

-(void)requestData
{
    __weakSelf
    NSDictionary *parameter = @{@"activity_id":[@(self.acitityId)stringValue]};
    [ODHttpTool getWithURL:KActivityDetailUrl parameters:parameter modelClass:[ODActivityDetailModel class] success:^(id model)
     {
         weakSelf.resultModel = [model result];
         weakSelf.activityVIPs = weakSelf.resultModel.savants;
         weakSelf.activityApplies = weakSelf.resultModel.applies;
         [weakSelf.tableView reloadData];
     }
                   failure:^(NSError *error)
     {
         
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10 + self.activityVIPs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) // 图片
    {
        cell = [tableView dequeueReusableCellWithIdentifier:headImgCell];
        [(ODActivityDetailHeadImgViewCell *)cell setHeadImgUrl:self.resultModel.icon_url];
    }
    else if (indexPath.row == 1) // 活动名称
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, 0, cell.od_width - ODLeftMargin * 2, 50)];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = self.resultModel.content;
        [cell.contentView addSubview:label];
    }
    else if (indexPath.row == 2)//时间
    {
        cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
        [(ODActivityDetailInfoViewCell *)cell iconImgView].image = [UIImage imageNamed:@"icon_service time"];
        [(ODActivityDetailInfoViewCell *)cell detailInfoLabel].text = self.resultModel.time_str;
        [(ODActivityDetailInfoViewCell *)cell statusLabel].text = self.resultModel.apply_status_str;
        [(ODActivityDetailInfoViewCell *)cell statusLabel].hidden = NO;
    }
    else if (indexPath.row == 3)//地点
    {
        cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
        [(ODActivityDetailInfoViewCell *)cell iconImgView].image = [UIImage imageNamed:@"icon_service address"];
        [(ODActivityDetailInfoViewCell *)cell detailInfoLabel ].text = self.resultModel.store_address;
        [(ODActivityDetailInfoViewCell *)cell statusLabel].hidden = YES;
    }
    else if (indexPath.row == 4)//组织人
    {
        cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
        [(ODActivityDetailInfoViewCell *)cell iconImgView].image = [UIImage imageNamed:@"icon_Edit name"];
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"由 %@ 组织",self.resultModel.store_name]];
        [attributeString addAttributes:
         @{
           NSForegroundColorAttributeName : [UIColor colorWithHexString:@"3963b2" alpha:1]
           }range:NSMakeRange(2, attributeString.length - 5)];
        [(ODActivityDetailInfoViewCell *)cell detailInfoLabel].attributedText = attributeString;
        [(ODActivityDetailInfoViewCell *)cell statusLabel].hidden = YES;
    }
    else if (indexPath.row == 5 || indexPath.row == 5 + 2 + self.activityVIPs.count)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, 17.5, cell.od_width - ODLeftMargin * 2, 13.5)];
        label.font = [UIFont systemFontOfSize:13.5];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = indexPath.row == 5 ? @"活动嘉宾" : @"活动详情";
        [cell.contentView addSubview:label];
    }
    else if (indexPath.row <= 5 + self.activityVIPs.count) // 嘉宾信息
    {
        ODActivityDetailVIPModel *vipModel = self.resultModel.savants[indexPath.row - 6];
        cell = [tableView dequeueReusableCellWithIdentifier:VIPCell];
        [[(ODActivityVIPCell *)cell VIPHeadImgView] sd_setImageWithURL:[NSURL OD_URLWithString:[vipModel avatar]]];
        [[(ODActivityVIPCell *)cell VIPName]setText:vipModel.nick];
        [[(ODActivityVIPCell *)cell VIPInfoLabel]setText:vipModel.school_name];
        [[(ODActivityVIPCell *)cell VIPDutyLabel]setText:vipModel.profile];
        
    }
    else if (indexPath.row == 5 + 1 + self.activityVIPs.count) //报名人
    {
#warning 测试
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, 17.5, cell.od_width - ODLeftMargin * 2, 13.5)];
        label.font = [UIFont systemFontOfSize:13.5];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"活动详情";
        [cell.contentView addSubview:label];
        
    }
    else if (indexPath.row == 5 + 3 + self.activityVIPs.count)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:detailContentCell];
        [(ODActivityDetailContentCell *)cell contentLabel].text = self.resultModel.remark;
    }
    else if (indexPath.row == 5 + 4 + self.activityVIPs.count)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:bottomCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
ODActivityDetailContentCell *detailCell;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) // 图片
    {
        return 375 / 2;
    }
    else if (indexPath.row == 1) // 活动名称
    {
        return 50;
    }
    else if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4)//时间//地点//组织人
    {
        return 43;
    }
    else if (indexPath.row == 5 || indexPath.row == 5 + 2 + self.activityVIPs.count)
    {
        return 44;
    }
    else if (indexPath.row <= 5 + self.activityVIPs.count) // 嘉宾信息
    {
        return 58;
    }
    else if (indexPath.row == 5 + 1 + self.activityVIPs.count) //报名人
    {
        return 94;
    }
    else if (indexPath.row == 5 + 3 + self.activityVIPs.count)
    {
        if (!detailCell) {
            detailCell = [tableView dequeueReusableCellWithIdentifier:detailContentCell];
        }
        detailCell.contentLabel.text = self.resultModel.remark;
        return detailCell.height;
    }
    else if (indexPath.row == 5 + 4 + self.activityVIPs.count)
    {
        return 50;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 9)
    {
        return 100;
    }
    else
    {
        return 40;
    }
}
@end
