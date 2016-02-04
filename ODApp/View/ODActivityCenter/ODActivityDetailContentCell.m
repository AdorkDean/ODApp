//
//  ODActivityDetailContentCell.m
//  ODApp
//
//  Created by 刘培壮 on 16/2/2.
//  Copyright © 2016年 Odong Org. All rights reserved.
//


#import "ODActivityDetailContentCell.h"

@interface ODActivityDetailContentCell ()<UIWebViewDelegate>
/**
 *  webView
 */
@property(nonatomic, strong) UIWebView *webView;


@end

@implementation ODActivityDetailContentCell


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

- (CGFloat)height
{
    // 强制布局cell内部的所有子控件(label根据文字多少计算出自己最真实的尺寸)
//    [self layoutIfNeeded];
    // 计算cell的高度
    return CGRectGetMaxY(self.contentWebView.frame) + 12.5;
}

#pragma mark - WebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.contentWebView.od_height = [[self.contentWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
    //关闭webView上下滑动
    UIScrollView *tempView = (UIScrollView *)[self.contentWebView.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    [self layoutIfNeeded];
}

@end
