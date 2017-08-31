//
//  ForcastAPIService.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 31/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "ForcastAPIService.h"
#import "MSCalendarConstants.h"

@interface ForcastAPIService()
@end

@implementation ForcastAPIService


+(void)fetchWeatherInfoForLocation:(CLLocation *)location withCompletion:(void(^)(NSDictionary *response))completion
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%f,%f",FORCAST_API_GET_URL,FORCAST_API_KEY,location.coordinate.latitude,location.coordinate.longitude]]];
        [request setHTTPMethod:@"GET"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            completion(responseDictionary);
        }
        else
        {
            completion(nil);
        }
    }];
    [dataTask resume];
}

@end
