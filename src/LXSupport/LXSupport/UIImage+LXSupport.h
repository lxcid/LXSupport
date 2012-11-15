//
//  UIImage+LXSupport.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 26/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LXSupport)

// http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
#pragma mark - Alpha
+ (UIImage *)borderMaskImageOfBorderSize:(CGFloat)theBorderSize forImageSize:(CGSize)theImageSize scale:(CGFloat)theScale orientation:(UIImageOrientation)theOrientation;

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)imageWithTransparentBorderOfSize:(CGFloat)theBorderSize;
- (UIImage *)imageWithAdditionalTransparentBorderOfSize:(CGFloat)theBorderSize;
- (UIImage *)imageWithBorderOfSize:(CGFloat)theBorderSize color:(UIColor *)theBorderColor;

#pragma mark - Resize
+ (CGAffineTransform)affineTransformForSize:(CGSize)theSize withImageOrientation:(UIImageOrientation)theImageOrientation;

- (UIImage *)croppedImageToBounds:(CGRect)theBounds;
- (UIImage *)resizedImageWithSize:(CGSize)theSize affineTransform:(CGAffineTransform)theAffineTransform drawTransposed:(BOOL)theDrawTransposed interpolationQuality:(CGInterpolationQuality)theInterpolationQuality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)theContentMode size:(CGSize)theSize interpolationQuality:(CGInterpolationQuality)theInterpolationQuality;

@end
