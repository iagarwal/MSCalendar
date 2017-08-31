//
//  MSAgendaViewModel.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 27/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSAgendaViewModel.h"
#import "NSDate+MSCalender.h"
#import "MSCalendarConstants.h"
#import "MSEventDataStore.h"

@implementation MSAgendaViewModel

+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(instancetype) init
{
    if (self = [super init])
    {
        _totalVisibleYears = 10*365;
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
        _yearRange = NSMakeRange(comp.year*365 - (_totalVisibleYears/2) , comp.year*365 + (_totalVisibleYears/2));
    }
    return self;
}
-(NSInteger )addYearsForEventsInFuture:(BOOL)inFuture
{
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate distantPast] toDate:[NSDate distantFuture] options:0];
    NSInteger addedIndexes = VISIBLE_DAYS_ADD_CONSTANT;
    if ((_totalVisibleYears + VISIBLE_DAYS_ADD_CONSTANT)<= comp.day)
    {
        _totalVisibleYears = _totalVisibleYears + VISIBLE_DAYS_ADD_CONSTANT;
    }
    else
    {
        NSInteger totalYears = _totalVisibleYears;
        _totalVisibleYears = totalYears + (comp.day - totalYears);
        addedIndexes = (comp.day - totalYears);
    }
    if (inFuture) {
        _yearRange = NSMakeRange(_yearRange.location, _yearRange.length+VISIBLE_DAYS_ADD_CONSTANT);
    }
    else
    {
        _yearRange = NSMakeRange(_yearRange.location-VISIBLE_DAYS_ADD_CONSTANT, _yearRange.length);
    }
    return addedIndexes;
}
-(NSInteger) numberOfSections
{
    //Total number of days from 0 to 9999 years
    return _totalVisibleYears;
}


-(NSInteger)indexOfDate:(NSDate *)date
{
    NSInteger numberOfDays = [NSDate daysBetweenDate:[NSDate distantPast] toDate:date];
    NSInteger indexInRange = numberOfDays - _yearRange.location;
    return indexInRange;
}

-(NSString *)dateStringForIndex:(NSInteger)index
{
    NSInteger indexInRange = _yearRange.location + index;
    NSDate *date = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:indexInRange toDate:[NSDate distantPast] options:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setCalendar:[NSCalendar currentCalendar]];
    //TODO : Remove year & add Today/tomorrow/yesterday
    [formatter setDateFormat:@"EEEE,yyyy MMMM dd"];
    return [formatter stringFromDate:date];
}
-(NSDate *)dateForIndex:(NSInteger)index
{
    NSInteger indexInRange = _yearRange.location + index;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitDay value:indexInRange toDate:[NSDate distantPast] options:0];
    NSDateComponents *comps = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:date];
    return [calendar dateFromComponents:comps];
}

-(NSArray *)eventsForSection:(NSInteger)section
{
    NSDate *date = [self dateForIndex:section];
    NSArray *list = [[MSEventDataStore sharedInstance] eventListForDate:date];
    return list;
}
@end
