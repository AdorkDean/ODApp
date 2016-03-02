//
//  ODNewActivityDetailViewController.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/15.
//  Copyright © 2016年 Odong Org. All rights reserved.
//
#import <UMengAnalytics-NO-IDFA/MobClick.h>
#import "masonry.h"
#import "UIImageView+WebCache.h"
#import "ODActivityDetailModel.h"
#import "ODNewActivityDetailViewController.h"
#import "ODPersonalCenterViewController.h"
#import "ODNewActivityCenterViewController.h"

#import "ODActivePersonInfoView.h"
#import "ODTitleLabelView.h"
#import "ODActivityVIPCell.h"
#import "ODActivitybottomView.h"
#import "ODActivityDetailInfoViewCell.h"

#import "ODCenterPactureController.h"
#import "UMSocial.h"
#import "ODCenterDetailController.h"
#import "ODApplyListViewController.h"
#import "WXApi.h"

@interface ODNewActivityDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, UMSocialUIDelegate, ODPersonalCenterVCDelegate, UMSocialDataDelegate> {
    BOOL hasload;
    NSInteger sharedTimes;
    NSInteger loveNum;
    UIView *activePeopleLineView;
}

/**
 *  活动嘉宾
 */
@property(nonatomic, strong) NSArray *activityVIPs;

/**
 *  申请人
 */
@property(nonatomic, strong) NSArray *activityApplies;

/**
 *  从服务器获取到的数据
 */
@property(nonatomic, strong) ODActivityDetailModel *resultModel;

/**
 *  底部ScrollView
 */
@property(nonatomic, strong) UIScrollView *baseScrollV;

/**
 *  头部ImageView
 */
@property(nonatomic, strong) UIImageView *headImageView;

/**
 *  标题
 */
@property(nonatomic, strong) UILabel *titleLabel;

/**
 *  详细信息tableView
 */
@property(nonatomic, strong) UITableView *infoTableView;

/**
 *  活动嘉宾label
 */
@property(nonatomic, strong) ODTitleLabelView *VIPLabel;

/**
 *  活动嘉宾信息tableView
 */
@property(nonatomic, strong) UITableView *VIPTableView;

/**
 *  报名人数
 */
@property(nonatomic, strong) ODTitleLabelView *peopleNumLabel;

/**
 *  报名人数View
 */
@property(nonatomic, strong) ODActivePersonInfoView *activePeopleView;

/**
 *  活动内容label
 */
@property(nonatomic, strong) ODTitleLabelView *activeContentLabel;

/**
 *  webView的底部view
 */
@property(nonatomic, strong) UIView *webBaseView;

/**
 *  活动内容webView
 */
@property(nonatomic, strong) UIWebView *webView;

/**
 *  分享点赞按钮View
 */
@property(nonatomic, strong) ODActivitybottomView *bottomButtonView;

/**
 *  立即报名按钮
 */
@property(nonatomic, strong) UIButton *reportButton;

@property(nonatomic, assign) NSInteger love_id;

@end

@implementation ODNewActivityDetailViewController

NSInteger const labelHeight = 44;

static NSString *const VIPCell = @"VIPCell";
static NSString *const detailInfoCell = @"detailInfoCell";

#pragma mark - lazyLoad

- (UIScrollView *)baseScrollV {
    if (!_baseScrollV) {
        _baseScrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, KScreenWidth, KControllerHeight - ODNavigationHeight - self.reportButton.od_height)];
        [self.view addSubview:_baseScrollV];
    }
    return _baseScrollV;
}


- (UIImageView *)headImageView {
    if (!_headImageView) {
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.baseScrollV addSubview:imgV];
        _headImageView = imgV;
    }
    return _headImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.headImageView.frame), self.baseScrollV.od_width - ODLeftMargin * 2, 50)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.contentMode = UIViewContentModeCenter;
        [_titleLabel addLineOnBottom];
        [self.baseScrollV addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UITableView *)infoTableView {
    if (!_infoTableView) {
        _infoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), KScreenWidth, 43 * 3) style:UITableViewStylePlain];
        _infoTableView.scrollEnabled = NO;
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.tableFooterView = [UIView new];
        [_infoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityDetailInfoViewCell class]) bundle:nil] forCellReuseIdentifier:detailInfoCell];
        _infoTableView.separatorColor = [UIColor lineColor];
        _infoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [_infoTableView addLineOnBottom];
        [self.baseScrollV addSubview:self.infoTableView];
    }
    return _infoTableView;
}

- (ODTitleLabelView *)VIPLabel {
    if (!_VIPLabel) {
        ODTitleLabelView *label = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ODTitleLabelView class]) owner:nil options:nil][0];
        label.frame = CGRectMake(0, CGRectGetMaxY(self.infoTableView.frame), KScreenWidth, labelHeight);
        label.textLabel.text = @"活动嘉宾";
        label.textLabel.font = [UIFont systemFontOfSize:13.5];
        [label.textLabel addLineOnBottom];
        [self.baseScrollV addSubview:label];
        _VIPLabel = label;
    }
    return _VIPLabel;
}

- (UITableView *)VIPTableView {
    if (!_VIPTableView) {
        _VIPTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.VIPLabel.frame), KScreenWidth, 0) style:UITableViewStylePlain];
        _VIPTableView.scrollEnabled = NO;
        _VIPTableView.delegate = self;
        _VIPTableView.dataSource = self;
        _VIPTableView.tableFooterView = [UIView new];
        _VIPTableView.separatorColor = [UIColor lineColor];
        [_VIPTableView registerNib:[UINib nibWithNibName:NSStringFromClass([ODActivityVIPCell class]) bundle:nil] forCellReuseIdentifier:VIPCell];
        [_VIPTableView addLineOnBottom];
        [self.baseScrollV addSubview:_VIPTableView];
    }
    return _VIPTableView;
}

- (ODTitleLabelView *)peopleNumLabel {
    if (!_peopleNumLabel) {
        ODTitleLabelView *label = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ODTitleLabelView class]) owner:nil options:nil][0];
        label.frame = CGRectMake(0, CGRectGetMaxY(self.VIPTableView.frame), KScreenWidth, labelHeight);
        label.textLabel.font = [UIFont systemFontOfSize:13.5];
        [self.baseScrollV addSubview:label];
        _peopleNumLabel = label;
    }
    return _peopleNumLabel;
}

- (ODActivePersonInfoView *)activePeopleView {
    if (!_activePeopleView) {
        ODActivePersonInfoView *view = [[ODActivePersonInfoView alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.peopleNumLabel.frame), KScreenWidth - ODLeftMargin * 2, 0)];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *applyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(applyAction)];
        [view addGestureRecognizer:applyTap];
        activePeopleLineView = [view addLineFromPoint:CGPointMake(-ODLeftMargin, view.od_height)];
        [self.baseScrollV addSubview:view];
        _activePeopleView = view;
    }
    return _activePeopleView;
}

- (ODTitleLabelView *)activeContentLabel {
    if (!_activeContentLabel) {
        ODTitleLabelView *label = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ODTitleLabelView class]) owner:nil options:nil][0];
        label.frame = CGRectMake(0, CGRectGetMaxY(self.activePeopleView.frame), KScreenWidth, labelHeight);
        label.textLabel.text = @"活动详情";
        label.textLabel.font = [UIFont systemFontOfSize:13.5];
        [label addLineFromPoint:CGPointMake(0, label.od_y)];
        [label addLineFromPoint:CGPointMake(label.textLabel.od_x, label.od_height)];
        [self.baseScrollV addSubview:label];
        _activeContentLabel = label;
    }
    return _activeContentLabel;
}

- (UIView *)webBaseView
{
    if (!_webBaseView)
    {
        _webBaseView = [[UIView alloc]init];
        [self.baseScrollV addSubview:_webBaseView];
    }
    return _webBaseView;
}

- (UIWebView *)webView {
    if (!_webView) {
        hasload = NO;
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(ODLeftMargin, 12.5, kScreenSize.width - ODLeftMargin * 2, 10)];
        webView.delegate = self;
        webView.layer.masksToBounds = YES;
        webView.layer.cornerRadius = 5;
        webView.layer.borderColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1].CGColor;
        webView.backgroundColor = [UIColor whiteColor];
        webView.scrollView.showsHorizontalScrollIndicator = NO;
        webView.scrollView.scrollEnabled = NO;

        [self.webBaseView addSubview:webView];
        _webView = webView;
    }
    return _webView;
}

- (ODActivitybottomView *)bottomButtonView {
    if (!_bottomButtonView) {
        ODActivitybottomView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ODActivitybottomView class]) owner:nil options:nil][0];
        [view.shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [view.goodBtn addTarget:self action:@selector(clickGood:) forControlEvents:UIControlEventTouchUpInside];
        view.frame = CGRectMake(0, CGRectGetMaxY(self.webView.frame), KScreenWidth, 50);
        view.backgroundColor = [UIColor whiteColor];
        [self.baseScrollV addSubview:view];
        [self.baseScrollV bringSubviewToFront:_bottomButtonView];
        _bottomButtonView = view;
    }
    return _bottomButtonView;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    self.navigationItem.title = @"活动详情";
    [ODNewActivityCenterViewController sharedODNewActivityCenterViewController].needRefresh = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem OD_itemWithTarget:self action:@selector(share:) image:[UIImage imageNamed:@"话题详情-分享icon"] highImage:nil];

    [self requestData];
}

- (void)requestData {
    __weakSelf
    NSDictionary *parameter = @{@"activity_id" : [@(self.acitityId) stringValue]};
    [ODHttpTool getWithURL:ODUrlActivityDetail parameters:parameter modelClass:[ODActivityDetailModel class] success:^(id model) {
                weakSelf.resultModel = [model result];
                [weakSelf analyzeData];
            }
                   failure:^(NSError *error) {
                   }];
}

- (void)analyzeData {
    __weakSelf
    self.activityVIPs = self.resultModel.savants;
    self.activityApplies = self.resultModel.applies;
    self.reportButton.enabled = (self.resultModel.apply_status != 1) && (self.resultModel.apply_status != -6) && (self.resultModel.apply_status != -4);
    [self.headImageView sd_setImageWithURL:[NSURL OD_URLWithString:self.resultModel.icon_url] placeholderImage:[UIImage imageNamed:@"placeholderImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [ODProgressHUD dismiss];
        if (!image) {
            weakSelf.headImageView.od_height = 0;
        }
        else {
            weakSelf.headImageView.od_width = KScreenWidth;
            weakSelf.headImageView.od_height = image.size.height * KScreenWidth / image.size.width;
            [weakSelf.headImageView addLineOnBottom];
        }
        weakSelf.titleLabel.text = weakSelf.resultModel.content;
        [weakSelf.infoTableView reloadData];
        weakSelf.VIPLabel.od_height = weakSelf.resultModel.savants.count ? labelHeight : 0;
        weakSelf.VIPTableView.od_height = weakSelf.resultModel.savants.count *
                137 / 2;
        if (weakSelf.resultModel.apply_cnt) {
            weakSelf.peopleNumLabel.textLabel.text = [NSString stringWithFormat:@"%d人已报名", weakSelf.resultModel.apply_cnt];
            [weakSelf.activePeopleView setActivePersons:self.resultModel.applies];
            weakSelf.peopleNumLabel.od_height = labelHeight;
            weakSelf.activePeopleView.od_y = CGRectGetMaxY(weakSelf.peopleNumLabel.frame);
            weakSelf.activePeopleView.od_height = 50;
        }
        else {
            weakSelf.peopleNumLabel.od_height = 0;
            weakSelf.activePeopleView.od_height = 0;
        }
        activePeopleLineView.od_y = weakSelf.activePeopleView.od_height - .5;
        weakSelf.activeContentLabel.od_y = CGRectGetMaxY(weakSelf.activePeopleView.frame);

        weakSelf.webView.od_y = CGRectGetMaxY(weakSelf.activeContentLabel.frame) + 12.5;
        [weakSelf.webView loadHTMLString:weakSelf.resultModel.remark baseURL:nil];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.infoTableView) {
        return 3;
    }
    else if (tableView == self.VIPTableView) {
        return self.resultModel.savants.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.infoTableView) {
        ODActivityDetailInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0)//时间
        {
            cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell iconImgView].image = [UIImage imageNamed:@"icon_service time"];
            [cell detailInfoLabel].text = self.resultModel.time_str;
            [cell statusLabel].text = self.resultModel.apply_status_str;
            [cell statusLabel].hidden = NO;
        }
        else if (indexPath.row == 1)//地点
        {
            cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell iconImgView].image = [UIImage imageNamed:@"icon_service address"];
            [cell detailInfoLabel].text = self.resultModel.store_address;
            [cell statusLabel].hidden = YES;
        }
        else if (indexPath.row == 2)//组织人
        {
            cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCell];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell iconImgView].image = [UIImage imageNamed:@"icon_Edit name"];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"由 %@ 组织", self.resultModel.organization_name]];
            [attributeString addAttributes:
                    @{
                            NSForegroundColorAttributeName : [UIColor colorWithHexString:@"3963b2" alpha:1]
                    }                range:NSMakeRange(2, attributeString.length - 5)];
            [cell detailInfoLabel].attributedText = attributeString;
            [cell statusLabel].hidden = YES;
        }

        return cell;
    }
    else if (tableView == self.VIPTableView) {
        ODActivityDetailVIPModel *vipModel = self.resultModel.savants[indexPath.row];
        ODActivityVIPCell *cell = [tableView dequeueReusableCellWithIdentifier:VIPCell];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [[cell VIPHeadImgView] sd_setImageWithURL:[NSURL OD_URLWithString:[vipModel avatar]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[(ODActivityVIPCell *) cell VIPHeadImgView] setImage:[image OD_circleImage]];
        }];
        [[cell VIPName] setText:vipModel.nick];
        [[cell VIPInfoLabel] setText:vipModel.school_name];
        [[cell VIPDutyLabel] setText:vipModel.profile];
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.infoTableView) {
        if (indexPath.row == 1) {
            if (self.resultModel.is_online == 1) {
                [ODProgressHUD showInfoWithStatus:@"亲，这个是线上活动噢！"];
            }
            else {
                if (self.resultModel.store_id > 0) {
                    ODCenterDetailController *vc = [[ODCenterDetailController alloc] init];
                    vc.storeId = [NSString stringWithFormat:@"%d", self.resultModel.store_id];
                    vc.activityID = [NSString stringWithFormat:@"%ld", (long)self.resultModel.activity_id];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else {
                    ODCenterPactureController *vc = [[ODCenterPactureController alloc] init];
                    NSString *webUrl = [NSString stringWithFormat:@"http://h5.odong.com/map/search?lng=%@&lat=%@", self.resultModel.lng, self.resultModel.lat];
                    vc.webUrl = webUrl;
                    vc.activityName = self.resultModel.store_address;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
        }
    }
    else if (tableView == self.VIPTableView) {
        ODOthersInformationController *vc = [[ODOthersInformationController alloc] init];
        vc.open_id = [self.resultModel.savants[indexPath.row] open_id];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.infoTableView) {
        return 43;
    }
    else if (tableView == self.VIPTableView) {
        return 137 / 2;
    }
    return 0;
}

#pragma mark - WebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *clientheight_str = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"];
    float clientheight = [clientheight_str floatValue];
    self.webBaseView.frame = CGRectMake(0, CGRectGetMaxY(self.activeContentLabel.frame), KScreenWidth, clientheight + 25);
    webView.frame = CGRectMake(ODLeftMargin, 12.5, KScreenWidth - ODLeftMargin * 2, clientheight);
    self.bottomButtonView.od_y = CGRectGetMaxY(self.webBaseView.frame);
    if (!hasload) {
        [self.baseScrollV addLineFromPoint:CGPointMake(0, CGRectGetMaxY(self.webBaseView.frame))];
        [self.bottomButtonView addLineOnBottom];
        hasload = YES;
    }
    sharedTimes = self.resultModel.share_cnt;
    [[self.bottomButtonView shareBtn] setTitle:[NSString stringWithFormat:@"分享 %d", self.resultModel.share_cnt] forState:UIControlStateNormal];
    [[self.bottomButtonView goodBtn] setTitle:[NSString stringWithFormat:@"赞 %d", self.resultModel.love_cnt] forState:UIControlStateNormal];
    self.bottomButtonView.goodBtn.OD_selectedState = self.resultModel.love_id != 0;
    self.love_id = self.resultModel.love_id;
    loveNum = self.resultModel.love_cnt;
    self.baseScrollV.contentSize = CGSizeMake(0, CGRectGetMaxY(self.bottomButtonView.frame));
}

#pragma mark - ODPersonalCenterVCDelegate

- (void)personalHasLoginSuccess {
    [self reportRequest];
}

#pragma mark - action

- (void)applyAction {
    ODApplyListViewController *vc = [[ODApplyListViewController alloc] init];
    vc.activity_id = [NSString stringWithFormat:@"%ld", (long)self.resultModel.activity_id];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)share:(UIButton *)sender {

    if ([WXApi isWXAppInstalled]) {


        [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];


        NSString *url = self.resultModel.share[@"icon"];
        NSString *content = self.resultModel.share[@"desc"];
        NSString *link = self.resultModel.share[@"link"];
        NSString *title = self.resultModel.share[@"title"];

        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:kGetUMAppkey
                                          shareText:content
                                         shareImage:nil
                                    shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                           delegate:self];


    } else {

        [ODProgressHUD showInfoWithStatus:@"没有安装微信"];


    }


}

- (void)clickGood:(ODActivityDetailBtn *)btn {
    BOOL isAdd = self.love_id == 0;
    NSDictionary *dic = isAdd ? @{@"type" : @"3", @"obj_id" : [@(self.resultModel.activity_id) stringValue]} : @{@"love_id" : [@(self.love_id) stringValue]};
    [ODHttpTool getWithURL:isAdd ? ODUrlLoveAdd : ODUrlLoveDelete parameters:dic modelClass:[NSObject class] success:^(id model) {
                NSDictionary *dic = model;
                self.love_id = [dic[@"love_id"] integerValue];
                if (self.love_id != 0) {
                    loveNum++;
                }
                else if (!dic) {
                    loveNum--;
                }
                btn.OD_selectedState = !btn.OD_selectedState;
                [[self.bottomButtonView goodBtn] setTitle:[NSString stringWithFormat:@"赞 %zd", loveNum] forState:UIControlStateNormal];

            }
                   failure:^(NSError *error) {

                   }];
}

- (void)report:(ODActivityDetailBtn *)btn {
    NSString *openId = [ODUserInformation sharedODUserInformation].openID;
    if (openId.length == 0) {
        ODPersonalCenterViewController *perV = [[ODPersonalCenterViewController alloc] init];
        [self presentViewController:perV animated:YES completion:nil];
    }
    else {
        [self reportRequest];
    }
}

- (void)reportRequest {
    NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[@(self.resultModel.activity_id) stringValue], @"activity_id", nil];
    [ODHttpTool getWithURL:ODUrlActivityApply parameters:infoDic modelClass:[NSObject class] success:^(id model) {
                [self requestData];
                self.reportButton.enabled = NO;


                [ODProgressHUD showInfoWithStatus:@"报名成功"];
                [ODNewActivityCenterViewController sharedODNewActivityCenterViewController].needRefresh = YES;
            }
                   failure:^(NSError *error) {
                       [ODProgressHUD dismiss];
                   }];
}


- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {

    if (response.responseCode == UMSResponseCodeSuccess) {


        sharedTimes++;
        [[self.bottomButtonView shareBtn] setTitle:[NSString stringWithFormat:@"分享 %zd", sharedTimes] forState:UIControlStateNormal];


        NSDictionary *infoDic = [NSDictionary dictionaryWithObjectsAndKeys:[@(self.resultModel.activity_id) stringValue], @"obj_id", @"4", @"type", @"微信", @"share_platform", nil];
        [ODHttpTool getWithURL:ODUrlShareCallBack parameters:infoDic modelClass:[NSObject class] success:^(id model) {

                }
                       failure:^(NSError *error) {

                       }];


    }
}

- (void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

@end
