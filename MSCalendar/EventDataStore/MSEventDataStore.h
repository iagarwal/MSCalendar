//
//  MSEventDataStore.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 27/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSEventDataStore : NSObject
@property (nonatomic,strong) NSDictionary *eventList;

+(instancetype) sharedInstance;

-(void)readDummyEventListFromPlist;
-(NSArray *)eventListForDate:(NSDate *)date;

@end
