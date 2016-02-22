//
//  ODDrawbackBuyerOneController.m
//  ODApp
//
//  Created by 代征钏 on 16/2/20.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODDrawbackBuyerOneController.h"

@interface ODDrawbackBuyerOneController ()

@end

@implementation ODDrawbackBuyerOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"退款";
    [self createScrollView];
}


- (void)createScrollView
{

    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ODTopY, kScreenSize.width, KControllerHeight - ODNavigationHeight)];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"#e6e6e6" alpha:1];
    [self.view addSubview:self.scrollView];
    
    float drawBackHeight = 43;
    
    
    self.drawbackMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, drawBackHeight)];
    self.drawbackMoneyLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackMoneyLabel.text = [NSString stringWithFormat:@"您的退款金额：%.1f元",self.darwbackMoney];
    self.drawbackMoneyLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.drawbackMoneyLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackMoneyLabel];
    
    self.drawbackReasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackMoneyLabel.frame), KScreenWidth, 22)];
    self.drawbackReasonLabel.text = @"退款原因";
    self.drawbackReasonLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.drawbackReasonLabel.font = [UIFont systemFontOfSize:12];
    self.drawbackReasonLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.drawbackReasonLabel];
    
    self.drawbackReasonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackReasonLabel.frame), KScreenWidth, drawBackHeight)];
    self.drawbackReasonContentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonContentView];
    
    self.drawbackReasonContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonLabel.frame), KScreenWidth, drawBackHeight)];
    self.drawbackReasonContentLabel.text = @"其它";
    self.drawbackReasonContentLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackReasonContentLabel.font = [UIFont systemFontOfSize:13.5];
    self.drawbackReasonContentLabel.textAlignment = NSTextAlignmentLeft;
//    self.drawbackReasonContentLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonContentLabel];
    
    self.drawbackStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonContentLabel.frame), KScreenWidth, 22)];
    self.drawbackStateLabel.text = @"退款说明";
    self.drawbackStateLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.drawbackStateLabel.font = [UIFont systemFontOfSize:12];
    self.drawbackStateLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.drawbackStateLabel];
    
    
    self.drawbackReasonContentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.drawbackStateLabel.frame), KScreenWidth, 150)];
    self.drawbackReasonContentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.drawbackReasonContentView];
    
    self.drawbackStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(ODLeftMargin, 0, KScreenWidth, 150)];
    self.drawbackStateTextView.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.drawbackStateTextView.font = [UIFont systemFontOfSize:12];
    self.drawbackStateTextView.delegate = self;
    [self.drawbackReasonContentView addSubview:self.drawbackStateTextView];
    
    self.contactServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.drawbackReasonContentView.frame), KScreenWidth, 22)];
    self.contactServiceLabel.text = @"联系客服";
    self.contactServiceLabel.textColor = [UIColor colorWithHexString:@"#8e8e8e" alpha:1];
    self.contactServiceLabel.font = [UIFont systemFontOfSize:12];
    self.contactServiceLabel.textAlignment = NSTextAlignmentLeft;
    [self.scrollView addSubview:self.contactServiceLabel];
    
    self.servicePhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.contactServiceLabel.frame), KScreenWidth, drawBackHeight)];
    self.servicePhoneView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.servicePhoneView];
    
    
    self.servicePhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, 0, 85, drawBackHeight)];
    self.servicePhoneLabel.text = @"客服电话：";
    self.servicePhoneLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.servicePhoneLabel.font = [UIFont systemFontOfSize:13.5];
    self.servicePhoneLabel.textAlignment = NSTextAlignmentLeft;
    self.servicePhoneLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.servicePhoneView addSubview:self.servicePhoneLabel];
    
    self.servicePhoneButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.servicePhoneLabel.frame), 0, 150, drawBackHeight)];
    [self.servicePhoneButton setTitle:@"4008-888-888" forState:UIControlStateNormal];
    self.servicePhoneButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
    self.servicePhoneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.servicePhoneButton setTitleColor:[UIColor colorWithHexString:@"#3c63a2" alpha:1] forState:UIControlStateNormal];
    [self.servicePhoneView addSubview:self.servicePhoneButton];
    
    self.serviceTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.servicePhoneView.frame) + 1, KScreenWidth, drawBackHeight)];
    self.serviceTimeView.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.serviceTimeView];
    
    self.serviceTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ODLeftMargin, CGRectGetMaxY(self.servicePhoneView.frame) + 1, KScreenWidth, drawBackHeight)];
    self.serviceTimeLabel.text = @"服务时间：周一至周五 早10:00-晚06:00";
    self.serviceTimeLabel.textColor = [UIColor colorWithHexString:@"#000000" alpha:1];
    self.serviceTimeLabel.font = [UIFont systemFontOfSize:13.5];
    self.serviceTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.serviceTimeLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff" alpha:1];
    [self.scrollView addSubview:self.serviceTimeLabel];
    

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
