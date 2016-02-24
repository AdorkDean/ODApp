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
    self.contentLabel.text = [NSString stringWithFormat:@"%@" , model.comment];
  
    
    
  
    
    
    
    
}


-(void)dealWithModel:(ODSecondEvaluationModel *)model
{
    
    
    
    
    if ([model.reason isEqualToString:@""]) {
        
        NSString *reason_num = [NSString stringWithFormat:@"%@" , model.reason_num];
        
        if ([reason_num isEqualToString:@"1"]) {
            
            self.contentLabel.text = @"非常不满意";
            
        }else if ([reason_num isEqualToString:@"2"]) {
            
             self.contentLabel.text = @"不满意";
            
        }else if ([reason_num isEqualToString:@"3"]) {
            
            self.contentLabel.text = @"一般";
            
        }else if ([reason_num isEqualToString:@"4"]) {
            
            self.contentLabel.text = @"满意";
            
        }else if ([reason_num isEqualToString:@"5"]) {
            
            self.contentLabel.text = @"非常满意";
            
        }

        
       
    self.contentLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, 20);
        
        
    }else{
        // 根据内容更改label的高度
        CGRect rect = [model.reason boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20,0)
                                                 options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                              attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                 context:nil];
        self.contentLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 20, rect.size.height);
        self.contentLabel.text = model.reason;

    }
    
    
    
   
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

+ (CGFloat)returnSecondHight:(ODSecondEvaluationModel *)model
{
    
    
    //根据内容计算,更改Label的高度
    if (![model.reason isEqualToString:@""]) {
        CGRect rect = [model.reason boundingRectWithSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 20, 0)
                                                  options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                               attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                                  context:nil];
        return (rect.size.height + 30);
    }else{
        
        return 40;
        
    }

    
    
    
}

@end
