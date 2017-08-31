//
//  NSDate+MSCalender.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 24/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "NSDate+MSCalender.h"

@implementation NSDate (MSCalender)


-(NSCalendarUnit)firstDayOfMonth
{
    return [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday fromDate:self];
}

-(NSUInteger)totalDays
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
}

-(NSDate *)firstDateOfMonth
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
    comp.day = 1;
    return  [[NSCalendar currentCalendar] dateFromComponents:comp];
}

-(NSString *)monthYYYYString
{
    NSArray *monthSymbols = [[NSCalendar currentCalendar] monthSymbols];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
    return [NSString stringWithFormat:@"%@ %ld",[monthSymbols objectAtIndex:comp.month-1],(long)comp.year];
}

-(NSString *)shortMonthStringForNextMonth
{
    NSArray *monthSymbols = [[NSCalendar currentCalendar] shortMonthSymbols];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
    comp.month = comp.month+1;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comp];
    comp = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    return [monthSymbols objectAtIndex:comp.month-1];

}

-(NSString *)shortMonthStringForCurrentMonth
{
    NSArray *monthSymbols = [[NSCalendar currentCalendar] shortMonthSymbols];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
    return [monthSymbols objectAtIndex:comp.month-1];

}
-(NSString *)dayFromDate
{
    return [NSString stringWithFormat:@"%ld",(long)[[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day]];
}

-(NSCalendarUnit)monthFromDate
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
    return comp.month;
}
-(BOOL)isToday
{
    return [[NSCalendar currentCalendar] isDateInToday:self];
}

-(MSCalendarMonthType)monthTypeWithDate:(NSDate *)currentDate
{
    NSDateComponents *comps1 = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self];
    NSDateComponents *comps2 = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:currentDate];
    MSCalendarMonthType type = MSCalendarSameMonth;
    if (comps1.year < comps2.year)
    {
        type = MSCalendarPreviousMonth;
    }
    else if(comps1.year > comps2.year)
    {
        type  =  MSCalendarNextMonth;
    }
    else if (comps1.year == comps2.year)
    {
        if (comps1.month < comps2.month)
        {
            type = MSCalendarPreviousMonth;
        }
        else if(comps1.month > comps2.month)
        {
            type = MSCalendarNextMonth;
        }
        else
        {
           type = MSCalendarSameMonth;
        }
    }

    return type;
}

+(NSInteger)daysBetweenDate:(NSDate *)date1 toDate:(NSDate *)date2
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComp = [calendar components:NSCalendarUnitDay fromDate:date1 toDate:date2 options:0];
    return dayComp.day;
}
@end
