//
//  ODUserInformation.m
//  ODApp
//
//  Created by zhz on 16/1/13.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserInformation.h"
#import "ODAppConst.h"
#import "JPUSHService.h"

@implementation ODUserInformation
Single_Implementation(ODUserInformation)

//- (NSString *)openID
//{
//    return [self getUserCache].open_id;
//}

- (void)updateUserCache:(ODUserModel *)user
{
    [ODUserInformation sharedODUserInformation].openID = user.open_id;
    [ODUserInformation sharedODUserInformation].mobile = user.mobile;
    [ODUserInformation sharedODUserInformation].avatar = user.avatar;
        
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:user.open_id forKey:KUserDefaultsOpenId];
    [userDefault setObject:user.avatar forKey:KUserDefaultsAvatar];
    [userDefault setObject:user.mobile forKey:KUserDefaultsMobile];
    
    [userDefault setObject:user.mj_keyValues forKey:kUserCache];
    [userDefault synchronize];
    
    [JPUSHService setAlias:user.open_id callbackSelector:@selector(setTags:alias:fetchCompletionHandle:) object:nil];
}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (ODUserModel *)getUserCache{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDefault objectForKey:kUserCache];
    if (userDic == nil) {
        return  nil;
    } else {
        return [ODUserModel mj_objectWithKeyValues:userDic];
    }
}

- (void)updateConfigCache:(ODOtherConfigInfoModel *)config
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:config.mj_keyValues forKey:kConfigCache];
    [userDefault synchronize];
}

- (ODOtherConfigInfoModel *)getConfigCache
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *configDic = [userDefault objectForKey:kConfigCache];
    if (configDic == nil) {
        return  nil;
    } else {
        return [ODOtherConfigInfoModel mj_objectWithKeyValues:configDic];
    }
}


@end
