//
//  SenTestingKit+LXSupportTests.m
//  LXSupport
//
//  Created by Stan Chang Khin Boon on 24/4/13.
//  Copyright (c) 2013 d--buzz. All rights reserved.
//

#import "SenTestingKit+LXSupportTests.h"
#import "SenTestingKit+LXSupport.h"

@interface SenTestingKit_LXSupportTests ()

@property (assign, nonatomic, getter = hasExecuted) BOOL executed;
@property (copy, nonatomic) LXSResumeBlock resume;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation SenTestingKit_LXSupportTests

- (void)testExercisesRunLoopInBlock {
    // The workaround with testRunLoopInBlock method...
    self.executed = NO;
    LXS_exercisesRunLoopInBlock(^(LXSResumeBlock resume) {
        self.resume = resume;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(toBeExecuted) userInfo:nil repeats:NO];
    }, 1.0);
    STAssertTrue(self.hasExecuted, @"Method should have been executed.");
}

- (void)toBeExecuted {
    self.executed = YES;
}

- (void)testCalculatesElapsedTimeInBlock {
    {
        NSTimeInterval expectedTimeInterval = 1.0;
        uint64_t expectedElapsedNanoseconds = expectedTimeInterval * LXS_ONE_SECOND_OF_NANOSECONDS;
        uint64_t elapsedNanoseconds = LXS_calculatesElapsedTimeInBlock(^{
            [NSThread sleepForTimeInterval:expectedTimeInterval];
        });
        STAssertTrue(elapsedNanoseconds > expectedElapsedNanoseconds, @"Must have elapsed %f second", expectedTimeInterval);
    }
    
    {
        NSTimeInterval expectedTimeInterval = 3.0;
        uint64_t expectedElapsedNanoseconds = expectedTimeInterval * LXS_ONE_SECOND_OF_NANOSECONDS;
        uint64_t elapsedNanoseconds = LXS_calculatesElapsedTimeInBlock(^{
            [NSThread sleepForTimeInterval:expectedTimeInterval];
        });
        STAssertTrue(elapsedNanoseconds > expectedElapsedNanoseconds, @"Must have elapsed %f second", expectedTimeInterval);
    }
}

@end
