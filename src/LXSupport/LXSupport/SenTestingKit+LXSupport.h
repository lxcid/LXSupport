//
//  SenTestingKit+LXSupport.h
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 24/4/13.
//  Copyright (c) 2013 d--buzz. All rights reserved.
//

#ifndef SENTESTINGKIT_LXSUPPORT_H_
#define SENTESTINGKIT_LXSUPPORT_H_

#include <mach/mach.h>
#include <mach/mach_time.h>

#define LXS_ONE_SECOND_OF_NANOSECONDS 1000000000.0

typedef void (^LXSResumeBlock)(void);
typedef void (^LXSBlockToExerciseRunLoop)(LXSResumeBlock resume);
typedef void (^LXSBlockToCalculateElapsedTime)(void);

static inline uint64_t LXS_calculatesElapsedTimeInBlock(LXSBlockToCalculateElapsedTime block);

// Call resume() to stop the block from exercising the run loop and break out of the loop/block.
// Failure to call resume() will cause the test to hang indefinitely.
// This is useful to testing asynchronous actions like AFNetworking operations. See https://gist.github.com/2215212
// With some reference from https://github.com/icanzilb/MTTestSemaphore, I was able to simplify this method.
static inline void LXS_exercisesRunLoopInBlock(LXSBlockToExerciseRunLoop block, NSTimeInterval timeout) {
    __block BOOL keepRunning = YES;
    block(^{ keepRunning = NO; });
    int64_t timeoutInNanoseconds = (int64_t)(LXS_ONE_SECOND_OF_NANOSECONDS * timeout);
    while (keepRunning) {
        uint64_t elapsedNanoseconds = LXS_calculatesElapsedTimeInBlock(^{
            if (![[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.03]]) {
                keepRunning = NO;
            }
        });
        timeoutInNanoseconds -= elapsedNanoseconds;
        if (timeoutInNanoseconds < 0) {
            keepRunning = NO;
        }
    }
}

// http://developer.apple.com/library/mac/#qa/qa1398/_index.html
static inline uint64_t LXS_calculatesElapsedTimeInBlock(LXSBlockToCalculateElapsedTime block) {
    uint64_t        start;
    uint64_t        end;
    uint64_t        elapsed;
    uint64_t        elapsedNano;
    static mach_timebase_info_data_t    sTimebaseInfo;
    
    // Start the clock.
    
    start = mach_absolute_time();
    
    // Call block.
    block();
    
    // Previously call getpid, which will produce inaccurate results because
    // we're only making a single system call. For more accurate
    // results you should call getpid multiple times and average
    // the results.
    
    // Stop the clock.
    
    end = mach_absolute_time();
    
    // Calculate the duration.
    
    elapsed = end - start;
    
    // Convert to nanoseconds.
    
    // If this is the first time we've run, get the timebase.
    // We can use denom == 0 to indicate that sTimebaseInfo is
    // uninitialised because it makes no sense to have a zero
    // denominator is a fraction.
    
    if ( sTimebaseInfo.denom == 0 ) {
        (void) mach_timebase_info(&sTimebaseInfo);
    }
    
    // Do the maths. We hope that the multiplication doesn't
    // overflow; the price you pay for working in fixed point.
    
    elapsedNano = elapsed * sTimebaseInfo.numer / sTimebaseInfo.denom;
    
    return elapsedNano;
}

#endif /* SENTESTINGKIT_LXSUPPORT_H_ */
