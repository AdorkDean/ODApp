//
//  ODClassMethod.m
//  ODApp
//
//  Created by Odong-YG on 15/12/17.
//  Copyright © 2015年 Odong-YG. All rights reserved.
//

#import "ODClassMethod.h"

@implementation ODClassMethod

+(UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text font:(NSInteger)size alignment:(NSString *)alignment color:(NSString *)color alpha:(float)opacity maskToBounds:(BOOL)maskToBounds
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [ODColorConversion colorWithHexString:color alpha:opacity];
    label.numberOfLines = 0;
    label.userInteractionEnabled = YES;
    
    if ([alignment isEqualToString:@"left"]) {
        label.textAlignment = NSTextAlignmentLeft;
    }else if ([alignment isEqualToString:@"center"]){
        label.textAlignment = NSTextAlignmentCenter;
    }else{
        label.textAlignment = NSTextAlignmentRight;
    }
    
    if (maskToBounds) {
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 5;
        label.layer.borderWidth = 1;
        label.layer.borderColor = [ODColorConversion colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    }
    return label;
}

+ (UIButton *)creatButtonWithFrame:(CGRect)frame target:(id)target sel:(SEL)sel tag:(NSInteger)tag image:(NSString *)name title:(NSString *)title font:(NSInteger)size 
{
    UIButton *button = nil;
    if (name) {
        //创建图片按钮
        //创建背景图片 按钮
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        if (title) {//图片标题按钮
            [button setTitle:title forState:UIControlStateNormal];
        }
        
    }else if (title) {
        //创建标题按钮
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:title forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    button.frame = frame;
    button.tag = tag;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame imageName:(NSString *)name tag:(NSInteger)tag{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image  = [UIImage imageNamed:name];
    imageView.tag = tag;
    return imageView;
}

+(UIView *)creatViewWithFrame:(CGRect)frame tag:(NSInteger)tag color:(NSString *)color
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.tag = tag;
    view.backgroundColor = [ODColorConversion colorWithHexString:color alpha:1];
    return view;
}
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)string delegate:(id<UITextFieldDelegate>)delegate tag:(NSInteger)tag
{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.placeholder = string;
    //设置代理
    textField.delegate = delegate;
    //设置tag值
    textField.tag = tag;
    textField.font = [UIFont systemFontOfSize:16];
    textField.backgroundColor = [UIColor whiteColor];
    textField.clearButtonMode = YES;
    return textField;
}

+(UITextView *)creatTextViewWithFrame:(CGRect)frame delegate:(id<UITextViewDelegate>)delegate tag:(NSInteger)tag font:(NSInteger)size color:(NSString *)color alpha:(float)opacity maskToBounds:(BOOL)maskToBounds
{
    UITextView *textView = [[UITextView alloc]initWithFrame:frame];
    //设置代理
    textView.delegate = delegate;
    //设置tag值
    textView.tag = tag;
    textView.font = [UIFont systemFontOfSize:size];
    textView.backgroundColor = [ODColorConversion colorWithHexString:color alpha:opacity];
    if (maskToBounds) {
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 5;
        textView.layer.borderWidth = 1;
        textView.layer.borderColor = [ODColorConversion colorWithHexString:@"8d8d8d" alpha:1].CGColor;
    }
    return textView;
}


+(UILabel *)setLayerWithRadius:(NSInteger)radius borderColor:(NSString *)color borderWidth:(NSInteger)width
{
    UILabel *label = [[UILabel alloc]init];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = radius;
    label.layer.borderColor = [ODColorConversion colorWithHexString:color alpha:1].CGColor;
    label.layer.borderWidth = width;
    return label;
}
@end
