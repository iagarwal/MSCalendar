//
//  NSDate+MSCalender.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 24/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    MSCalendarNoValue,
    MSCalendarSameMonth,
    MSCalendarPreviousMonth,
    MSCalendarNextMonth,
} MSCalendarMonthType;


@interface NSDate (MSCalender)

-(NSCalendarUnit)firstDayOfMonth;
-(NSUInteger)totalDays;
-(NSDate *) firstDateOfMonth;
-(NSString *)monthYYYYString;
-(NSString *)shortMonthStringForNextMonth;
-(NSString *)shortMonthStringForCurrentMonth;
-(NSString *)dayFromDate;
-(NSCalendarUnit)monthFromDate;
-(BOOL)isToday;
-(MSCalendarMonthType)monthTypeWithDate:(NSDate *)currentDate;
+(NSInteger)daysBetweenDate:(NSDate *)date1 toDate:(NSDate *)date2;

@end
