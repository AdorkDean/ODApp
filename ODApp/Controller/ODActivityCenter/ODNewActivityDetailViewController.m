//
//  ODNewActivityDetailViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import "masonry.h"
#import "UIImageView+WebCache.h"
#import "ODActivityDetailModel.h"
#import "ODActivityDetailViewController.h"
#import "ODNewActivityDetailViewController.h"

#import "ODTitleLabelView.h"
#import "ODActivityVIPCell.h"
#import "ODActivitybottomView.h"
#import "ODActivityDetailInfoViewCell.h"

@interface ODNewActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

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
 *  底部ScrollView
 */
@property (nonatomic, strong) UIScrollView *baseScrollV;

/**
 *  头部ImageView
 */
@property (nonatomic, strong) UIImageView *headImageView;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  详细信息tableView
 */
@property (nonatomic, strong) UITableView *infoTableView;

/**
 *  活动嘉宾label
 */
@property (nonatomic, strong) ODTitleLabelView *VIPLabel;

/**
 *  活动嘉宾信息tableView
 */
@property (nonatomic, strong) UITableView *VIPTableView;

/**
 *  报名人数
 */
@property (nonatomic, strong) ODTitleLabelView *peopleNumLabel;

/**
 *  报名人数View
 */
@property (nonatomic, strong) UIView *activePeopleView;

/**
 *  活动内容label
 */
@property (nonatomic, strong) ODTitleLabelView *activeContentLabel;

/**
 *  活动内容webView
 */
@property(nonatomic, strong) UIWebView *webView;

/**
 *  分享点赞按钮View
 */
@property (nonatomic, strong) ODActivitybottomView *bottomButtonView;

/**
 *  立即报名按钮
 */
@property (nonatomic, strong) UIButton *reportButton;

@end

@implementation ODNewActivityDetailViewController

NSInteger const labelHeight = 44;

static NSString * const VIPCell = @"VIPCell";
static NSString * const detailInfoCell = @"detailInfoCell";

#pragma mark - lazyLoad

- (UIScrollView *)baseScrollV
{
    if (!_baseScrollV)
    {
        _baseScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight - self.reportButton.od_height)];
        [self.view addSubview:_baseScrollV];
    }
    return _baseScrollV;
}

- (UIImageView *)headImageView
{
    if (!_headImageView)
    {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.baseScrollV addSubview:imgV];
        _headImageView = imgV;
    }
    return _headImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.headImageView.frame), self.baseScrollV.od_width - ODLeftMargin * 2, 50)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.contentMode = UIViewContentModeCenter;
        [_titleLabel addLineOnBottom];
        [self.baseScrollV addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UITableView *)infoTableView
{
    if (!_infoTableView)
    {
        _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), KScreenWidth, 43 * 3) style:UITableViewStylePlain];
        _infoTableView.scrollEnabled = NO;
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.tableFooterView = [UIView new];
        [_infoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailInfoViewCell class]) bundle:nil] forCellReuseIdentifier:detailInfoCell];
        [_infoTableView addLineOnBottom];
        [self.baseScrollV addSubview:self.infoTableView];
    }
    return _infoTableView;
}

- (ODTitleLabelView *)VIPLabel
{
    if (!_VIPLabel)
    {
        ODTitleLabelView *label = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ODTitleLabelView class]) owner:nil options:nil][0];
        label.frame = CGRectMake(0, CGRectGetMaxY(self.infoTableView.frame), KScreenWidth, labelHeight);
        label.textLabel.text = @"活动嘉宾";
        label.textLabel.font = [UIFont systemFontOfSize:13.5];
        [label.textLabel addLineOnBottom];
        [self.baseScrollV addSubview:label];
        _VIPLabel = label;
    }
    return _VIPLabel;
}

- (UITableView *)VIPTableView
{
    if (!_VIPTableView)
    {
        _VIPTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.VIPLabel.frame), KScreenWidth, 0) style:UITableViewStylePlain];
        _VIPTableView.scrollEnabled = NO;
        _VIPTableView.delegate = self;
        _VIPTableView.dataSource = self;
        _VIPTableView.tableFooterView = [UIView new];
        [_VIPTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailInfoViewCell class]) bundle:nil] forCellReuseIdentifier:detailInfoCell];
        [_VIPTableView addLineOnBottom];
        [self.baseScrollV addSubview:_VIPTableView];
    }
    return _VIPTableView;
}

- (ODTitleLabelView *)peopleNumLabel
{
    if (!_peopleNumLabel)
    {
        ODTitleLabelView *label = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ODTitleLabelView class]) owner:nil options:nil][0];
        label.frame = CGRectMake(0, CGRectGetMaxY(self.VIPTableView.frame), KScreenWidth, labelHeight);
        label.textLabel.font = [UIFont systemFontOfSize:13.5];
        [self.baseScrollV addSubview:label];
        _peopleNumLabel = label;
    }
    return _peopleNumLabel;
}

- (UIView *)activePeopleView
{
    if (!_activePeopleView)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.peopleNumLabel.frame), KScreenWidth - ODLeftMargin * 2, 50)];
        [self.baseScrollV addSubview:view];
        _activePeopleView = view;
    }
    return _activePeopleView;
}

- (ODTitleLabelView *)activeContentLabel
{
    if (!_activeContentLabel)
    {
        ODTitleLabelView *label = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ODTitleLabelView class]) owner:nil options:nil][0];
        label.frame = CGRectMake(0, CGRectGetMaxY(self.activePeopleView.frame), KScreenWidth, labelHeight);
        label.textLabel.text = @"活动详情";
        [label layoutIfNeeded];
        NSLog(@"%@",NSStringFromCGRect(label.frame));
        [label addLineFromPoint:CGPointMake(0, label.od_y)];
        [label addLineFromPoint:CGPointMake(label.textLabel.od_x,label.od_height)];
        label.textLabel.font = [UIFont systemFontOfSize:13.5];
        [self.baseScrollV addSubview:label];
        _activeContentLabel = label;
    }
    return _activeContentLabel;
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.activeContentLabel.frame) + 12.5, kScreenSize.width - ODLeftMargin * 2, 10)];
        webView.delegate = self;
        webView.layer.masksToBounds = YES;
        webView.layer.cornerRadius = 5;
        webView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        webView.scrollView.showsHorizontalScrollIndicator = NO;
        webView.scrollView.scrollEnabled = NO;
        [self.baseScrollV addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (ODActivitybottomView *)bottomButtonView
{
    if (!_bottomButtonView)
    {
        ODActivitybottomView *view = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ODActivitybottomView class]) owner:nil options:nil][0];
        view.frame = CGRectMake(0, CGRectGetMaxY(self.webView.frame), KScreenWidth, 50);
        [view addLineOnBottom];
        [self.baseScrollV addSubview:view];
        self.baseScrollV.contentSize = CGSizeMake(KScreenWidth, CGRectGetMaxY(view.frame));
        _bottomButtonView = view;
    }
    return _bottomButtonView;
}

- (UIButton *)reportButton
{
    if (!_reportButton)
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
        _reportButton = btn;
    }
    return _reportButton;
}

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"活动详情";
    [self requestData];
}

-(void)requestData
{
    __weakSelf
    NSDictionary *parameter = @{@"activity_id":[@(self.acitityId)stringValue]};
    [ODHttpTool getWithURL:KActivityDetailUrl parameters:parameter modelClass:[ODActivityDetailModel class] success:^(id model)
     {
         weakSelf.resultModel = [model result];
         [weakSelf analyzeData];
     }
                   failure:^(NSError *error)
     {
         
     }];
}

- (void)analyzeData
{
    __weakSelf
    self.activityVIPs = self.resultModel.savants;
    self.activityApplies = self.resultModel.applies;
    [self.headImageView sd_setImageWithURL:[NSURL OD_URLWithString:self.resultModel.icon_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        [weakSelf.headImageView sizeToFit];
        [weakSelf.headImageView addLineOnBottom];
        weakSelf.titleLabel.text = weakSelf.resultModel.content;
        weakSelf.infoTableView.hidden = NO;
        weakSelf.VIPLabel.od_height = weakSelf.resultModel.savants.count ? labelHeight : 0;
        weakSelf.VIPTableView.od_height = weakSelf.resultModel.savants.count *
        137 / 2;
        weakSelf.peopleNumLabel.textLabel.text = [NSString stringWithFormat:@"%d人已报名",weakSelf.resultModel.apply_cnt];
//        [(ODActivityPersonCell *)cell setActivePersons:self.resultModel.applies];
        weakSelf.activePeopleView.od_height = weakSelf.resultModel.apply_cnt ? weakSelf.activePeopleView.od_height : 0 ;
        UIView *lastView = weakSelf.resultModel.apply_cnt ? weakSelf.activePeopleView : weakSelf.peopleNumLabel;
        [lastView addLineFromPoint:CGPointMake(- ODLeftMargin, lastView.od_height)];
        weakSelf.activeContentLabel.hidden = NO;
        [weakSelf.webView loadHTMLString:weakSelf.resultModel.remark baseURL:nil];
        
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.infoTableView)
    {
        return 3;
    }
    else if (tableView == self.VIPTableView)
    {
        return self.resultModel.savants.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.infoTableView)
    {
        ODActivityDetailInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
        if (indexPath.row == 0)//时间
        {
            cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
            [(ODActivityDetailInfoViewCell *)cell iconImgView].image = [UIImage imageNamed:@"icon_service time"];
            [(ODActivityDetailInfoViewCell *)cell detailInfoLabel].text = self.resultModel.time_str;
            [(ODActivityDetailInfoViewCell *)cell statusLabel].text = self.resultModel.apply_status_str;
            [(ODActivityDetailInfoViewCell *)cell statusLabel].hidden = NO;
        }
        else if (indexPath.row == 1)//地点
        {
            cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
            [(ODActivityDetailInfoViewCell *)cell iconImgView].image = [UIImage imageNamed:@"icon_service address"];
            [(ODActivityDetailInfoViewCell *)cell detailInfoLabel ].text = self.resultModel.store_address;
            [(ODActivityDetailInfoViewCell *)cell statusLabel].hidden = YES;
        }
        else if (indexPath.row == 2)//组织人
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

        return cell;
    }
    else if (tableView == self.VIPTableView)
    {
        ODActivityDetailVIPModel *vipModel = self.resultModel.savants[indexPath.row];
        ODActivityVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:VIPCell];
        [[cell VIPHeadImgView] sd_setImageWithURL:[NSURL OD_URLWithString:[vipModel avatar]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[(ODActivityVIPCell *)cell VIPHeadImgView]setImage:[image OD_circleImage]];
        }];
        [[cell VIPName]setText:vipModel.nick];
        [[cell VIPInfoLabel]setText:vipModel.school_name];
        [[cell VIPDutyLabel]setText:vipModel.profile];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.infoTableView)
    {
        return 43;
    }
    else if (tableView == self.VIPTableView)
    {
        return 137 / 2;
    }
    return 0;
}

#pragma mark - WebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString * clientheight_str = [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    webView.od_height = clientheight + 12.5;
    [self.baseScrollV addLineFromPoint:CGPointMake(0, CGRectGetMaxY(webView.frame))];
    self.bottomButtonView.hidden = NO;
}

#pragma mark - action
- (void)report:(UIButton *)btn
{
    
}
@end
