//
//  MSAgendaViewModel.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 27/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSAgendaViewModel : NSObject

@property (nonatomic, assign) NSInteger totalVisibleYears;
@property (nonatomic,assign) NSRange yearRange;

+(instancetype) sharedInstance;
-(NSInteger) numberOfSections;
-(NSInteger)indexOfDate:(NSDate *)date;
-(NSString *)dateStringForIndex:(NSInteger)index;

-(NSInteger )addYearsForEventsInFuture:(BOOL)inFuture;
-(NSDate *)dateForIndex:(NSInteger)index;

-(NSArray *)eventsForSection:(NSInteger)section;
@end
