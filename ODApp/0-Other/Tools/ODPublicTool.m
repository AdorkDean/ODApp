//
//  ODPublicTool.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/11.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPublicTool.h"

@implementation ODPublicTool

+(void)shareAppWithTarget:(id)target dictionary:(NSDictionary *)dict controller:(UIViewController *)controller{
    @try {
        if ([WXApi isWXAppInstalled]) {
            [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
            
            NSString *url = [dict valueForKeyPath:@"icon"];
            NSString *content = [dict valueForKeyPath:@"desc"];
            NSString *link = [dict valueForKeyPath:@"link"];
            NSString *title = [dict valueForKeyPath:@"title"];
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
            [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
            [UMSocialSnsService presentSnsIconSheetView:controller
                                                 appKey:kGetUMAppkey
                                              shareText:content
                                             shareImage:nil
                                        shareToSnsNames:@[UMShareToWechatSession, UMShareToWechatTimeline]
                                               delegate:target];
        } else {
            [ODProgressHUD showInfoWithStatus:@"没有安装微信"];
        }
    }
    @catch (NSException *exception) {
        [ODProgressHUD showInfoWithStatus:@"网络异常无法分享"];
    }

}
@end
