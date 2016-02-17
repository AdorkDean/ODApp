//
//  ODActivityDetailViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//
#import "ODHttpTool.h"
#import "masonry.h"
#import "UIImageView+WebCache.h"
#import "ODActivityDetailModel.h"
#import "ODActivityDetailViewController.h"

#import "ODActivityBottomCell.h"
#import "ODActivityDetailHeadImgViewCell.h"
#import "ODActivityDetailInfoViewCell.h"
#import "ODActivityVIPCell.h"
#import "ODActivityDetailContentCell.h"
#import "ODActivityPersonCell.h"

@interface ODActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    NSInteger bottonBtnHeight;
    CGFloat webCellHeight;
}
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

/**
 *  webView
 */
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation ODActivityDetailViewController


static NSString * const detailInfoCell = @"detailInfoCell";
static NSString * const headImgCell = @"headImgCell";
static NSString * const VIPCell = @"VIPCell";
static NSString * const detailContentCell = @"detailContentCell";
static NSString * const bottomCell = @"bottomCell";
static NSString * const activePersonCell = @"activePersonCell";

#pragma mark - lazyLoad
- (UIWebView *)webView
{
    if (!_webView)
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(17.5, 12.5, kScreenSize.width - 35, 10)];
        webView.delegate = self;
        webView.layer.masksToBounds = YES;
        webView.layer.cornerRadius = 5;
        webView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        webView.layer.borderWidth = 1;
        _webView = webView;
    }
    return _webView;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight - bottonBtnHeight) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableFooterView = [UIView new];
        _tableView = tableView;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    [self createBottomButton];
    [self registTableViewClass];
    [self requestData];
}

#pragma mark - init
- (void)createBottomButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"button_sign up"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
    }];
    [btn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
    [btn layoutIfNeeded];
    bottonBtnHeight = btn.od_height;
}

- (void)registTableViewClass
{
    self.tableView.estimatedRowHeight = 200;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailHeadImgViewCell class]) bundle:nil] forCellReuseIdentifier:headImgCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailInfoViewCell class]) bundle:nil] forCellReuseIdentifier:detailInfoCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityVIPCell class]) bundle:nil] forCellReuseIdentifier:VIPCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailContentCell class]) bundle:nil] forCellReuseIdentifier:detailContentCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityBottomCell class]) bundle:nil] forCellReuseIdentifier:bottomCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityPersonCell class]) bundle:nil] forCellReuseIdentifier:activePersonCell];
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

- (void)report:(UIButton *)btn
{
    
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
        [[(ODActivityVIPCell *)cell VIPHeadImgView] sd_setImageWithURL:[NSURL OD_URLWithString:[vipModel avatar]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             [[(ODActivityVIPCell *)cell VIPHeadImgView]setImage:[image OD_circleImage]];
        }];
        [[(ODActivityVIPCell *)cell VIPName]setText:vipModel.nick];
        [[(ODActivityVIPCell *)cell VIPInfoLabel]setText:vipModel.school_name];
        [[(ODActivityVIPCell *)cell VIPDutyLabel]setText:vipModel.profile];
    }
    else if (indexPath.row == 5 + 1 + self.activityVIPs.count) //报名人
    {
        cell = [tableView dequeueReusableCellWithIdentifier:activePersonCell];
        [(ODActivityPersonCell *)cell activePersonNumLabel].text = [NSString stringWithFormat:@"%d人已报名",self.resultModel.apply_cnt];
        [(ODActivityPersonCell *)cell setActivePersons:self.resultModel.applies];
    }
    else if (indexPath.row == 8 + self.activityVIPs.count)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.contentView addSubview:self.webView];
        [self.webView loadHTMLString:self.resultModel.remark baseURL:nil];
    }
    else if (indexPath.row == 5 + 4 + self.activityVIPs.count)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:bottomCell];
        [[(ODActivityBottomCell *)cell shareBtn]setTitle:[NSString stringWithFormat:@"分享 %d",self.resultModel.share_cnt] forState:UIControlStateNormal];
        [[(ODActivityBottomCell *)cell goodBtn]setTitle:[NSString stringWithFormat:@"赞 %d",self.resultModel.love_cnt] forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 3) {
      
            
            NSLog(@"_____%@" , self.resultModel.store_address);
            
      
    
    }
    
    
    
}
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
        return 137 / 2;
    }
    else if (indexPath.row == 5 + 1 + self.activityVIPs.count) //报名人
    {
        return 94;
    }
    else if (indexPath.row == 5 + 3 + self.activityVIPs.count)
    {
        return [[self.webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] floatValue];
//        CGFloat heitgh = [self evaluateJSWithHtmlContent:self.webView htmlStr:self.resultModel.remark JSStr:@""];
//        NSLog(@"%f",webCellHeight);
//        return webCellHeight;
    }
    else if (indexPath.row == 5 + 4 + self.activityVIPs.count)
    {
        return 50;
    }
    return 0;
}
#pragma mark - WebViewDelegate
UITableViewCell *detailCell;
BOOL hasReload = NO;
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    detailCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 + self.activityVIPs.count inSection:0]];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
    webView.od_height = height;
    webCellHeight = height;

    [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:8 + self.activityVIPs.count inSection:0]];
    if (!hasReload && height)
    {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:8 + self.activityVIPs.count inSection:0]] withRowAnimation:(UITableViewRowAnimationNone)];
        hasReload = YES;
    }
    //关闭webView上下滑动
    webView.scrollView.scrollEnabled = NO;
}
- (CGFloat)evaluateJSWithHtmlContent:(UIWebView *)webView htmlStr:(NSString *)str JSStr:(NSString *)JSStr
{
    NSString *re = [NSString stringWithFormat:@"document.body.innerHTML=\"%@\";document.getElementsByName(\"answer\").style.display=\"none\"",str];
    [webView stringByEvaluatingJavaScriptFromString:re];
    [webView stringByEvaluatingJavaScriptFromString:JSStr];
    float htmlHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"AllContent\").scrollHeight"]floatValue];
    webView.scrollView.contentSize = CGSizeMake(self.view.od_width, htmlHeight);
    CGSize size = webView.scrollView.contentSize;
    webView.frame = CGRectMake(17.5, 12.5, size.width - 17.5, size.width + 12.5);
    return size.height + 25;
}
@end
