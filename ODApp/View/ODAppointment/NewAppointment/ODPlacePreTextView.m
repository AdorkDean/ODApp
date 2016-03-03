//
//  ODPlacePreView.m
//  ODApp
//
//  Created by 刘培壮 on 16/3/3.
//  Copyright © 2016年 Odong Org. All rights reserved.
//

#import "ODPlacePreTextView.h"
#import "UIView+ODPlaceView.h"

static CGFloat const textFont = 13.5;

@interface ODPlacePreTextView ()
/** 占位标签 */
@property (nonatomic,strong) UILabel *placeHolderLabel;

@end

@implementation ODPlacePreTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUp];
}

- (void)setUp
{
    [self od_setBorder];
    self.font = [UIFont systemFontOfSize:textFont];
    self.textColor = [UIColor colorWithHexString:@"484848" alpha:1];
    
    __weakSelf
    [[NSNotificationCenter defaultCenter]addObserverForName:UITextViewTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note)
    {
        weakSelf.placeHolderLabel.hidden = weakSelf.text.length;
    }];
}

- (void)setFont:(UIFont*)font {
    
    [super setFont:font];
    
    self.placeHolderLabel.font= font;
    
    //重新计算子控件frame
    
    [self setNeedsLayout];
    
}
- (void)setPlaceholder_OD:(NSString *)placeholder_OD
{
    _placeholder_OD = placeholder_OD;
    self.placeHolderLabel.text = placeholder_OD;
}

- (UILabel *)placeHolderLabel
{
    if (!_placeHolderLabel)
    {
        _placeHolderLabel = [[UILabel alloc]init];
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.textColor = [UIColor colorWithHexString:@"d0d0d0" alpha:1];
        [self addSubview:_placeHolderLabel];
    }
    return _placeHolderLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat leftMargin = 8.5;
    CGFloat upMargin = 7.5;
    CGSize size = [self.placeholder_OD boundingRectWithSize:CGSizeMake(self.od_width - leftMargin * 2, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
    _placeHolderLabel.frame = CGRectMake(leftMargin, upMargin, size.width, size.height);

}
@end
