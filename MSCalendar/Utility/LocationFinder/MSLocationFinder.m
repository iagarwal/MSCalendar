//
//  MSLocationFinder.m
//  MSCalendar
//
//  Created by Ishita Agarwal on 31/08/17.
//  Copyright © 2017 Ishita Agarwal. All rights reserved.
//

#import "MSLocationFinder.h"
#import "MSAppDelegate.h"

@interface MSLocationFinder ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@end

@implementation MSLocationFinder


+ (instancetype)sharedLocationFinder
{
    static MSLocationFinder *locationFinder;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        locationFinder = [[MSLocationFinder alloc] init];
    });
    return locationFinder;
    
}
- (instancetype)init {
    return [self initWithLocationManager:[[CLLocationManager alloc] init]];
}

- (instancetype)initWithLocationManager:(CLLocationManager *)locationManager {
    NSParameterAssert(locationManager != nil);
    
    if (self = [super init]) {
        _locationManager = locationManager;
        [_locationManager setDelegate:self];
        _locationManager.distanceFilter = 1000.0;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

- (BOOL)requestLocation {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([[self locationManager] respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            // iOS 8+
            if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
                [[self locationManager] requestAlwaysAuthorization];
            }
            if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways || authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse )
            {
                // user said "no"
            }
        }
        else {
            // iOS 7. nothing special needed
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationInForeground:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationInBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    });
    [_locationManager startUpdatingLocation];
    return (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways || authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse);
}
#pragma mark - Application state Notififications

- (void)applicationInForeground:(NSNotification*)notification {
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationInBackground:(NSNotification*)notification {
    [self.locationManager stopMonitoringSignificantLocationChanges];
    
}
#pragma mark - Location Manager delegate methods
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.deviceLocation = location;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             //Crashlytics 3173:#66
             if (placemark && placemark.ISOcountryCode) {
                 NSString *city = [[[NSString alloc]initWithString:placemark.locality] uppercaseString];
                 //Obtains a locale identifier. This will handle every language
                 // set this value n preferred language.
                 [self.delegate locationUpdated:location withCity:city];
             }
             
         }
         else
         {
             [self.delegate locationUpdated:location withCity:@""];

         }
     }];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.delegate locationUpdated:nil withCity:@""];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)locationUpdated:(CLLocation *)deviceLocation withCity:(NSString *)cityName
{
    
}

@end
