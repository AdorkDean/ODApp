//
//  ODClassMethod.h
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ODColorConversion.h"
@interface ODClassMethod : NSObject


/*
 这个类就可以为我们专门来创建一些基本的控件，那么如果要创建Label button textField 就可以通过这个类来创建
 这个类好像一个工厂一样专门生产一些基本控件
 类似于工厂设计模式
 */


+(UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text font:(NSInteger)size alignment:(NSString *)alignment color:(NSString *)color alpha:(float)opacity ODExtensionDeprecated("请不要再使用这个方法创建控件，谢谢");



//创建label
+ (UILabel *)creatLabelWithFrame:(CGRect)frame
                            text:(NSString *)text
                            font:(NSInteger)size
                       alignment:(NSString *)alignment
                           color:(NSString *)color
                           alpha:(float)opacity
                    maskToBounds:(BOOL)maskToBounds ODExtensionDeprecated("请不要再使用这个方法创建控件，谢谢");


//创建button可以创建 标题按钮和 图片按钮
+ (UIButton *)creatButtonWithFrame:(CGRect)frame
                            target:(id)target
                               sel:(SEL)sel
                               tag:(NSInteger)tag
                             image:(NSString *)name
                             title:(NSString *)title
                              font:(NSInteger)size ODExtensionDeprecated("请不要再使用这个方法创建控件，谢谢");
//创建UIImageView
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame
                               imageName:(NSString *)name tag:(NSInteger)tag ODExtensionDeprecated("请不要再使用这个方法创建控件，谢谢");

//创建UIView
+(UIView *)creatViewWithFrame:(CGRect)frame tag:(NSInteger)tag color:(NSString *)color ODExtensionDeprecated("请不要再使用这个方法创建控件，谢谢");

//创建UITextField
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame
                             placeHolder:(NSString *)string
                                delegate:(id <UITextFieldDelegate>)delegate
                                     tag:(NSInteger)tag ODExtensionDeprecated("请不要再使用这个方法创建控件，谢谢");

//创建UITextView
+(UITextView *)creatTextViewWithFrame:(CGRect)frame
                             delegate:(id<UITextViewDelegate>)delegate
                                  tag:(NSInteger)tag
                                 font:(NSInteger)size
                                color:(NSString *)color
                                alpha:(float)opacity
                         maskToBounds:(BOOL)maskToBounds ODExtensionDeprecated("请不要再使用这个方法创建控件，谢谢");


@end
