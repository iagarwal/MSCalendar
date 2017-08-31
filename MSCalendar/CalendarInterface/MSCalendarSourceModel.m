//
//  MSCalendarSourceModel.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 29/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSCalendarSourceModel.h"
#import "MSMonthViewModel.h"
#import "ForcastAPIService.h"

@interface MSCalendarSourceModel()
@end

@implementation MSCalendarSourceModel

+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)selectCalendarDateInMonthView:(NSDate *)date
{
    if (_pageDelegate && [_pageDelegate respondsToSelector:@selector(calendarPageDateChangedTo:)])
    {
        [_pageDelegate calendarPageDateChangedTo:date];
    }
}

-(void)dateScrolledInCalendarView:(NSDate *)date withMinimizedView:(MonthViewState)state height:(float)superViewHeight
{
    if (_listDelegate && [_listDelegate respondsToSelector:@selector(eventListDateChangedTo:withMinimizedView:height:)])
    {
        [_listDelegate eventListDateChangedTo:date withMinimizedView:state height:superViewHeight];
    }
}

//checks if date scrolled is within range of month dates shown in month view
//else delegate request to monthviewcontroller to turn page
-(BOOL)isScrolledDateWithInRange:(NSDate *)scrolledDate
{
    NSArray *dayValuesArray = [[MSMonthViewModel sharedInstance] monthValuesForRows:6];
    BOOL inRange = NO;
    if ([dayValuesArray containsObject:scrolledDate])
    {
        inRange = YES;
    }
    return inRange;
}
//Delegate method called when location gets updated
-(void)locationUpdated:(CLLocation *)deviceLocation withCity:(NSString *)cityName
{
    if (deviceLocation)
    {
        [_pageDelegate startedFetchingForcast:YES forCity:cityName];
        //request for weather info from DarkSky APIs
        [ForcastAPIService fetchWeatherInfoForLocation:deviceLocation withCompletion:^(NSDictionary *response)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (response)
                {
                    [_pageDelegate fetchedWeatherForcast:response ForCity:cityName];
                }
                else
                {
                    [_pageDelegate fetchedWeatherForcast:response ForCity:cityName];
                }
            });
            
        }];
    }
    else
    {
        [_pageDelegate startedFetchingForcast:NO forCity:@""];
    }
   
}
@end
