//
//  ODUserInformation.m
//  ODApp
//
//  Created by zhz on 16/1/13.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODUserInformation.h"
#import "ODAppConst.h"

@implementation ODUserInformation
Single_Implementation(ODUserInformation)

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}



- (void)updateUserCache:(ODUserModel *)user
{
    [ODUserInformation sharedODUserInformation].openID = user.open_id;
    [ODUserInformation sharedODUserInformation].mobile = user.mobile;
        
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:user.open_id forKey:KUserDefaultsOpenId];
    [userDefault setObject:user.avatar forKey:KUserDefaultsAvatar];
    [userDefault setObject:user.mobile forKey:KUserDefaultsMobile];
    
    [userDefault setObject:user.mj_keyValues forKey:kUserCache];
}


- (ODUserModel *)getUserCache
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [userDefault objectForKey:kUserCache];
    if (userDic == nil) {
        return  nil;
    } else {
        return [ODUserModel mj_objectWithKeyValues:userDic];
    }
}

@end
