//
//  NSString+MSCalendar.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 26/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "NSString+MSCalendar.h"

@implementation NSString (MSCalendar)
-(NSString *)dayFromDate
{
    return self;
}
-(NSUInteger)monthTypeWithDate:(NSDate *)currentDate
{
    return 0;
}
-(BOOL)isToday
{
    return false;
}
@end
