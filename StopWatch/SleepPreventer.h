//
//  SleepPreventer.h
//  StopWatch
//
//  Created by Sergey Kaminski on 1/24/15.
//  Copyright (c) 2015 Sergey Kaminski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/pwr_mgt/IOPMLib.h>

@interface SleepPreventer : NSObject
+ (void)Start;
+ (void)Stop;
@end
