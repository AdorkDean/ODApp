//
//  ODColorConversion.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ODColorConversion : NSObject

+(UIColor *)colorWithHexString:(NSString *)color alpha:(float)opacity;

@end
