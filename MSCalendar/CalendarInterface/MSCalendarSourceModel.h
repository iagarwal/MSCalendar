//
//  MSCalendarSourceModel.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 29/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSLocationFinder.h"


typedef enum : NSUInteger {
    MonthViewExpanded,
    MonthViewContracted,
} MonthViewState;

@protocol MSListUpdateProtocol <NSObject>

-(void)eventListDateChangedTo:(NSDate *)scrolledDate withMinimizedView:(MonthViewState)state height:(float)superViewHeight;

@end

@protocol MSPageUpdateProtocol <NSObject>

-(void)calendarPageDateChangedTo:(NSDate *)selectedDate;
-(void)startedFetchingForcast:(BOOL)fetching forCity:(NSString *)cityName;
-(void)fetchedWeatherForcast:(NSDictionary *)weatherInfo ForCity:(NSString *)cityName;

@end


@interface MSCalendarSourceModel : NSObject <MSLocationManagerDelegate>

@property (nonatomic, weak) id<MSListUpdateProtocol> listDelegate;
@property (nonatomic, weak) id<MSPageUpdateProtocol> pageDelegate;
@property (nonatomic, assign) MonthViewState calendarViewState;

+(instancetype) sharedInstance;

-(void)selectCalendarDateInMonthView:(NSDate *)date;

-(void)dateScrolledInCalendarView:(NSDate *)date withMinimizedView:(MonthViewState)state height:(float)superViewHeight;

-(BOOL)isScrolledDateWithInRange:(NSDate *)scrolledDate;

@end
