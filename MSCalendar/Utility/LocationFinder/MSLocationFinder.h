//
//  MSLocationFinder.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 31/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol MSLocationManagerDelegate <NSObject>

-(void)locationUpdated:(CLLocation *)deviceLocation withCity:(NSString *)cityName;

@end

@interface MSLocationFinder : NSObject<CLLocationManagerDelegate>


@property (nonatomic,assign)id <MSLocationManagerDelegate> delegate;


@property (nonatomic,strong) CLLocation *deviceLocation;


+ (instancetype)sharedLocationFinder;

- (BOOL)requestLocation ;
@end
