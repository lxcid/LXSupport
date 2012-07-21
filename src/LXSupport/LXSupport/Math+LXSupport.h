//
//  Math+LXSupport.h
//  Defind
//
//  Created by Stan Chang Khin Boon on 21/7/12.
//  Copyright (c) 2012 d--buzz. All rights reserved.
//

#ifndef MATH_LXSUPPORT_H_
#define MATH_LXSUPPORT_H_

#include <CoreGraphics/CGBase.h>

// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CoreAnimation_guide/Articles/Layers.html
CG_INLINE CGFloat
LXS_DegreesToRadians(CGFloat theDegrees)
{
    return theDegrees * M_PI / 180.0f;
}

CG_INLINE CGFloat
LXS_RadiansToDegrees(CGFloat theRadians)
{
    return theRadians * 180.0f / M_PI;
}

#endif /* MATH_LXSUPPORT_H_ */
