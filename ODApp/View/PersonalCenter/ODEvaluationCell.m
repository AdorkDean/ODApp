//
//  ODEvaluationCell.m
//  ODApp
//
//  Created by zhz on 16/1/18.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import "ODEvaluationCell.h"

@implementation ODEvaluationCell


-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addViews];
    }
    return self;
}


- (void)addViews
{
    self.contentLabel = [[UILabel alloc] init];
    
//     self.contentLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, 20);
     self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
     self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];

}


- (void)setModel:(ODEvaluationModel *)model
{
    
    if (_model != model) {
       
        _model = model;
    }
    
    
    
      // 根据内容更改label的高度
    CGRect rect = [model.comment boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20,0)
                                             options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                             context:nil];
    self.contentLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, rect.size.height);
    self.contentLabel.text = model.comment;
    
  
    
    
    self.contentLabel.text = model.comment;
    
    
    
    
}

+(CGFloat)returnHight:(ODEvaluationModel *)model
{
    //根据内容计算,更改Label的高度
    if (model.comment) {
        CGRect rect = [model.comment boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 20, 0)
                                                        options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                        context:nil];
        return (rect.size.height + 30);
    }else{
        
        return 30;

    }
    
    
}



@end
