//
//  CGGeometry+LXSupport.c
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 19/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#ifndef CGGEOMETRY_LXSUPPORT_H_
#define CGGEOMETRY_LXSUPPORT_H_

#include <CoreGraphics/CGGeometry.h>

CG_INLINE CGSize
LXS_CGSizeAdd(CGSize theSize1, CGSize theSize2)
{
    return CGSizeMake(theSize1.width + theSize2.width, theSize1.height + theSize2.height);
}

CG_INLINE CGSize
LXS_CGSizeMultiplyByScalar(CGSize theSize, CGFloat theScalar) {
    return CGSizeMake(theSize.width * theScalar, theSize.height * theScalar);
}

CG_INLINE CGPoint
LXS_CGPointAdd(CGPoint thePoint1, CGPoint thePoint2) {
    return CGPointMake(thePoint1.x + thePoint2.x, thePoint1.y + thePoint2.y);
}

// The default coordinate system in UIKit has its origin in the top-left corner and has axes that extend down and to the right from the origin point. http://developer.apple.com/library/ios/#documentation/windowsviews/conceptual/viewpg_iphoneos/WindowsandViews/WindowsandViews.html#//apple_ref/doc/uid/TP40009503-CH2-SW5

// This method start at the right (1.0f, 0.0f) and turn counter-clockwise as the radian increases.
// http://en.wikipedia.org/wiki/File:Degree-Radian_Conversion.svg
//
// Will suffer from floating point precision problem: http://stackoverflow.com/a/1610346/379604
// Should be neglectable in most cases.
// TODO: (khinboon@d--buzz.com) Resolve the precision problem.
CG_INLINE CGSize
LXS_CGSizeFromAngleAndDistance(CGFloat theAngleInRadian, CGFloat theDistance) {
    return LXS_CGSizeMultiplyByScalar(CGSizeMake(cosf(theAngleInRadian), -sinf(theAngleInRadian)), theDistance);
}

// The opposite to LXS_CGSizeFromAngleAndDistance. Similar to how photoshop calculate drop shadow, where the angle define the location of the light source.
CG_INLINE CGSize
LXS_CGSizeOfShadowFromAngleAndDistance(CGFloat theAngleInRadian, CGFloat theDistance) {
    return LXS_CGSizeMultiplyByScalar(CGSizeMake(-cosf(theAngleInRadian), sinf(theAngleInRadian)), theDistance);
}

CG_INLINE CGRect
LXS_CGRectFromCGPointAndCGSize(CGPoint theOrigin, CGSize theSize)
{
    return CGRectMake(theOrigin.x, theOrigin.y, theSize.width, theSize.height);
}

CG_INLINE CGFloat
LXS_CGRectGetAlignedLeftEdgeX(CGRect theRect1, CGRect theRect2)
{
    return CGRectGetMinX(theRect1);
}

CG_INLINE CGFloat
LXS_CGRectGetAlignedHorizontalCenterX(CGRect theRect1, CGRect theRect2)
{
    return CGRectGetMinX(theRect1) + ((CGRectGetWidth(theRect1) - CGRectGetWidth(theRect2)) * 0.5f);
}

CG_INLINE CGFloat
LXS_CGRectGetAlignedRightEdgeX(CGRect theRect1, CGRect theRect2)
{
    return CGRectGetMaxX(theRect1) - CGRectGetWidth(theRect2);
}

CG_INLINE CGFloat
LXS_CGRectGetAlignedTopEdgeY(CGRect theRect1, CGRect theRect2)
{
    return CGRectGetMinY(theRect1);
}

CG_INLINE CGFloat
LXS_CGRectGetAlignedVerticalCenterY(CGRect theRect1, CGRect theRect2)
{
    return CGRectGetMinY(theRect1) + ((CGRectGetHeight(theRect1) - CGRectGetHeight(theRect2)) * 0.5f);
}

CG_INLINE CGFloat
LXS_CGRectGetAlignedBottomEdgeY(CGRect theRect1, CGRect theRect2)
{
    return CGRectGetMaxY(theRect1) - CGRectGetHeight(theRect2);
}

#endif /* CGGEOMETRY_LXSUPPORT_H_ */