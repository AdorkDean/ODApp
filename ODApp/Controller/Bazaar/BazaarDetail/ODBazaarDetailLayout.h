//
//  ODBazaarDetailLayout.h
//  ODApp
//
//  Created by Odong-YG on 16/1/8.
//  Copyright © 2016年 Odong-YG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HJCarouselAnim) {
    HJCarouselAnimLinear,
    HJCarouselAnimRotary,
    HJCarouselAnimCarousel,
    HJCarouselAnimCarousel1,
    HJCarouselAnimCoverFlow,
};

@interface ODBazaarDetailLayout : UICollectionViewLayout

- (instancetype)initWithAnim:(HJCarouselAnim)anim;

@property (readonly)  HJCarouselAnim carouselAnim;

@property (nonatomic) CGSize itemSize;
@property (nonatomic) NSInteger visibleCount;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;

@end
