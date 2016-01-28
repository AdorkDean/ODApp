//
//  MyPageControl.m
//  
//
//  Created by Mike Chen on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyPageControl.h"

@interface MyPageControl ()

@property (nonatomic , strong)UIImage *normalDotImage;
@property (nonatomic , strong)UIImage *highlightedDotImage;
@property (nonatomic , strong)NSMutableArray *dotsArray;
@property (nonatomic , assign)NSInteger pageNumbers;
@property (nonatomic , assign)float dotsSize;
@property (nonatomic , assign)NSInteger dotsGap;

- (void)dotsDidTouched:(UIView *)sender;

@end

@implementation MyPageControl

@synthesize normalDotImage = _normalDotImage;
@synthesize highlightedDotImage = _highlightedDotImage;
@synthesize dotsArray = __dotsArray;
@synthesize pageNumbers = __pageNumbers;
@synthesize dotsSize = __dotsSize;
@synthesize dotsGap = __dotsGap;
@synthesize delegate;


/*
 *pageNum是pageControl的页面总个数
 *size是单个dot的边长
*/
- (id)initWithFrame:(CGRect)frame normalImage:(UIImage *)nImage highlightedImage:(UIImage *)hImage dotsNumber:(NSInteger)pageNum sideLength:(NSInteger)size dotsGap:(NSInteger)gap
{
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.dotsGap = gap;
        self.dotsSize = size;
        self.dotsArray = [NSMutableArray array];
        self.normalDotImage = nImage ;
        self.highlightedDotImage = hImage ;
        self.pageNumbers = pageNum;
        for (int i = 0; i != __pageNumbers; ++ i) {
            UIImageView *dotsView = [[UIImageView alloc] init];
            dotsView.userInteractionEnabled = YES;
            dotsView.frame = CGRectMake((size + gap) * i, 0, size, size);
            dotsView.tag = 100 + i;
            if (i == 0) {
                
                dotsView.image = _highlightedDotImage;
                
               
            } else {

                
                  dotsView.image = _normalDotImage;
                
                
            }
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dotsDidTouched:)];
            [dotsView addGestureRecognizer:gestureRecognizer];
           
            [self addSubview:dotsView];
           
        }
    }
    return self;
}

- (void)dotsDidTouched:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(pageControlDidStopAtIndex:)]) {
        [delegate pageControlDidStopAtIndex:[[sender view] tag] - 100];
    }
}

- (void)setCurrentPage:(NSInteger)pages
{
    if (_normalDotImage || _highlightedDotImage) {
        for (int i = 0 ; i != __pageNumbers; ++ i) {
            if (i == pages) {
                
                UIImageView *imageView = (UIImageView *)[self viewWithTag:100 + i];
                [imageView setCenter:CGPointMake((0.5 + i) * __dotsSize + __dotsGap * i, 0.5 * __dotsSize)];
                imageView.image = _highlightedDotImage;
                
                
                
            } else {
                UIImageView *imageView = (UIImageView *)[self viewWithTag:100 + i];
                imageView.image = _normalDotImage;
            }
        }
    }
}

@end
