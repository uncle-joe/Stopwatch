//
//  SleepPreventer.m
//  StopWatch
//
//  Created by Sergey Kaminski on 1/24/15.
//  Copyright (c) 2015 Sergey Kaminski. All rights reserved.
//


#import "SleepPreventer.h"

@implementation SleepPreventer
static IOPMAssertionID assertionID;
static IOReturn success;

+ (void)Start {
    CFStringRef* reasonForActivity= CFSTR("Describe Activity Type");
    
    
    success = IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep,
                                          kIOPMAssertionLevelOn, reasonForActivity, &assertionID);
    if (success == kIOReturnSuccess)
    {
    }
    
}

+ (void)Stop {
    success = IOPMAssertionRelease(assertionID);
}

@end
