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
- (BOOL)hasAlpha;

- (UIImage *)imageWithAlpha;
- (UIImage *)borderMaskImageOfBorderSize:(NSUInteger)theBorderSize forImageSize:(CGSize)theImageSize;
- (UIImage *)imageWithTransparentBorderOfSize:(NSUInteger)theBorderSize;
- (UIImage *)imageWithAdditionalTransparentBorderOfSize:(NSUInteger)theBorderSize;

@end
