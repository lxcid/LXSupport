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