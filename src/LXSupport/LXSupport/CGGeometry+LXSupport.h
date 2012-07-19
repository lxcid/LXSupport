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

#endif /* CGGEOMETRY_LXSUPPORT_H_ */