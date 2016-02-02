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

#import "ODActivityDetailHeadImgViewCell.h"
#import "ODActivityDetailInfoViewCell.h"
#import "ODActivityVIPCell.h"
#import "ODActivityDetailContentCell.h"

@interface ODActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;

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
#pragma mark - lazyLoad
- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODTabBarHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        tableView.rowHeight = 98;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailHeadImgViewCell class]) bundle:nil] forCellReuseIdentifier:headImgCell];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailInfoViewCell class]) bundle:nil] forCellReuseIdentifier:detailInfoCell];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityVIPCell class]) bundle:nil] forCellReuseIdentifier:VIPCell];
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailContentCell class]) bundle:nil] forCellReuseIdentifier:detailContentCell];
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
         self.resultModel = [model result];
         [weakSelf.tableView reloadData];
     }
                   failure:^(NSError *error)
     {
         
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.row)
    {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:headImgCell];
            [(ODActivityDetailHeadImgViewCell *)cell setHeadImgUrl:self.resultModel.icon_url];
        }
            break;
        case 1:
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, 0, cell.od_width - ODLeftMargin * 2, 50)];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = self.resultModel.content;
            [cell.contentView addSubview:label];
        }
            break;
        case 2:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
            [(ODActivityDetailInfoViewCell *)cell iconImgView].image = [UIImage imageNamed:@"icon_service time"];
            [(ODActivityDetailInfoViewCell *)cell detailInfoLabel].text = self.resultModel.time_str;
            [(ODActivityDetailInfoViewCell *)cell statusLabel].text = self.resultModel.apply_status_str;
            [(ODActivityDetailInfoViewCell *)cell statusLabel].hidden = NO;
        }
            break;
        case 3:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
            [(ODActivityDetailInfoViewCell *)cell iconImgView].image = [UIImage imageNamed:@"icon_service address"];
            [(ODActivityDetailInfoViewCell *)cell detailInfoLabel ].text = self.resultModel.store_address;
            [(ODActivityDetailInfoViewCell *)cell statusLabel].hidden = YES;
        }
            break;
        case 4:
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
            break;
        case 5: //活动嘉宾
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, 17.5, cell.od_width - ODLeftMargin * 2, 13.5)];
            label.font = [UIFont systemFontOfSize:13.5];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"活动嘉宾";
            [cell.contentView addSubview:label];
        }
            break;
        case 6:
        {
#warning 缺少字段
            cell = [tableView dequeueReusableCellWithIdentifier:VIPCell];
            [[(ODActivityVIPCell *)cell VIPHeadImgView] sd_setImageWithURL:[NSURL OD_URLWithString:self.resultModel.icon_url]];
            [[(ODActivityVIPCell *)cell VIPName]setText:self.resultModel.contact_info];
            [[(ODActivityVIPCell *)cell VIPInfoLabel]setText:self.resultModel.store_name];
            [[(ODActivityVIPCell *)cell VIPDutyLabel]setText:self.resultModel.store_name];
        }
            break;
        case 7: //报名人
        {
#warning 测试
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, 17.5, cell.od_width - ODLeftMargin * 2, 13.5)];
            label.font = [UIFont systemFontOfSize:13.5];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"活动详情";
            [cell.contentView addSubview:label];

        }
            break;
        case 8:
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, 17.5, cell.od_width - ODLeftMargin * 2, 13.5)];
            label.font = [UIFont systemFontOfSize:13.5];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = @"活动详情";
            [cell.contentView addSubview:label];
        }
            break;
        case 9:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:detailContentCell];
            [(ODActivityDetailContentCell *)cell contentLabel].text = self.resultModel.remark;
        }
            break;
        case 10:
        {
            
        }
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            return 375 / 2;
        }
            break;
        case 1:
        {
            return 50;
        }
            break;
        case 2:
        {
            return 43;
        }
            break;
        case 3:
        {
            return 43;
        }
            break;
        case 4:
        {
            return 43;
        }
            break;
        case 5://活动嘉宾
        {
            return 44;
        }
            break;
        case 6: //带有头像
        {
            return 58;
        }
            break;
        case 7:// 报名人数
        {
            return 94;
        }
            break;
        case 8:// 活动详情 同 活动嘉宾
        {
            return 44;
        }
            break;
        case 9: // 活动详情内容
        {
            return [tableView cellForRowAtIndexPath:indexPath].od_height;
        }
            break;
        case 10: // 分享和赞
        {
            return 50;
        }
            break;
            
        default:
            break;
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
