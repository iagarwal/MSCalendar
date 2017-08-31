//
//  ForcastAPIService.h
//  MSCalendar
//
//  Created by Ishita Agarwal on 31/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ForcastAPIService : NSObject


+(void)fetchWeatherInfoForLocation:(CLLocation *)location withCompletion:(void(^)(NSDictionary *reponse))completion;

@end
