//
//  UIImage+Images.m
//  相册照片
//
//  Created by game912 on 2018/3/27.
//  Copyright © 2018年 john. All rights reserved.
//

#import "UIImage+Images.h"

@implementation UIImage (Images)
+(instancetype)circleOldImage:(UIImage *)originalImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    //原图片
    UIImage *oldImage = originalImage;
    
    //开启上下文
    CGFloat imageW = oldImage.size.width  + 2*borderWidth;
    CGFloat imageH = oldImage.size.height + 2*borderWidth;
    
    CGSize  imgSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imgSize, NO, 0.0);
    
    //获取上下文
    CGColorRef ctx = UIGraphicsGetCurrentContext();
    
    [borderColor set];
    CGFloat bigRadius = imageW*0.5; //半径
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI*2, 0);
}


@end
