//
//  MSMonthViewModel.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 24/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSMonthViewModel.h"
#import "NSDate+MSCalender.h"
#import "MSEventDataStore.h"

@implementation MSMonthViewModel

+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(NSString *)monthTitle
{
    return [self.calendarMonth_Year monthYYYYString];
}

-(NSDate *)updateCalendarMonthToNextMonth:(BOOL)isMovingAhead
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.calendarMonth_Year];
    dateComps.day = 1;
    //While moving to next month if month value is 12 then move to next year with month value 1
    //While moving to previous month if month value is 1 then move to previous year with month value 12
    //Otherwise increase month value by 1..
    dateComps.month = dateComps.month + (isMovingAhead ? 1 : -1);
    self.calendarMonth_Year = [calendar dateFromComponents:dateComps];
    return self.calendarMonth_Year;
}

-(NSInteger)totalRowsInMonth
{
    NSInteger totalCount = 6;
    NSCalendar *currentCalender = [NSCalendar currentCalendar];
    
    NSDateComponents *compsCurrentMonth = [currentCalender components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.calendarMonth_Year];
    compsCurrentMonth.day = 1;
    NSInteger firstWeekDayOfCurrentMonth = [currentCalender component:NSCalendarUnitWeekday fromDate:[currentCalender dateFromComponents:compsCurrentMonth]];
    
    long currentMonthDayValuesCount = _calendarMonth_Year.totalDays;
    if ((firstWeekDayOfCurrentMonth+currentMonthDayValuesCount-1)> 7*5) {
        totalCount = 7;
    }
    return totalCount;
}

-(NSArray *)monthValuesForRows:(int)rows
{
    NSCalendar *currentCalender = [NSCalendar currentCalendar];
    //Append WeekSymbols to show header view for calendar grid
    NSMutableArray *m_DayValues = [NSMutableArray arrayWithArray:[[NSCalendar currentCalendar] veryShortWeekdaySymbols]];
    //Calculate values to show before 1st day of current month...
    
    //1. we will calculate total days in last month
    NSDateComponents *comps = [currentCalender components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.calendarMonth_Year];
    comps.month = comps.month-1;
    long previousMonthDays = [[currentCalender dateFromComponents:comps] totalDays];
    
    //2. get weekDay value of First day of current month
    NSDateComponents *compsCurrentMonth = [currentCalender components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.calendarMonth_Year];
    compsCurrentMonth.day = 1;
    NSInteger firstWeekDayOfCurrentMonth = [currentCalender component:NSCalendarUnitWeekday fromDate:[currentCalender dateFromComponents:compsCurrentMonth]];
    
    //3.get weekDay value of last day of current month
    long currentMonthDayValuesCount = _calendarMonth_Year.totalDays;
    
    for (int i=1; i<=(rows-1)*7; i++) {
        NSDateComponents *dateComp = [currentCalender components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:self.calendarMonth_Year];
        if (firstWeekDayOfCurrentMonth > i) {
            dateComp.month = dateComp.month-1;
            dateComp.day = (previousMonthDays-firstWeekDayOfCurrentMonth+i+1);
        }
        else if(i>=(currentMonthDayValuesCount+firstWeekDayOfCurrentMonth))
        {
            dateComp.month = dateComp.month+1;
            dateComp.day = (i - (currentMonthDayValuesCount + firstWeekDayOfCurrentMonth)+1);
        }
        else
        {
            dateComp.day = (i-firstWeekDayOfCurrentMonth+1);
        }
        [m_DayValues addObject:[currentCalender dateFromComponents:dateComp]];

    }
    
    return m_DayValues;
}

//returns month name is short style to show above date
-(NSString *)getShortMonthStringForIndex:(long)index day:(NSDate *)day
{
    NSString *monthValue = @"";
    if (day.dayFromDate.intValue==1)
    {
        monthValue = (index > 14)? self.calendarMonth_Year.firstDateOfMonth.shortMonthStringForNextMonth:self.calendarMonth_Year.firstDateOfMonth.shortMonthStringForCurrentMonth;
    }
    return monthValue;
}

//checks for a date if event exists in temp store
-(BOOL)isEventPlannedForDate:(NSDate *)date
{
    BOOL isPlanned = false;
    if ([date isKindOfClass:[NSDate class]]) {
        MSEventDataStore *dataStore = [MSEventDataStore sharedInstance];
        NSArray *eventList = [dataStore eventListForDate:date];
        if (eventList.count >0) {
            isPlanned = true;
        }
    }
    return isPlanned;
}
@end
