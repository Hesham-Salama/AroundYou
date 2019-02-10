//
//  MainData.m
//  AroundYou
//
//  Created by hesham on 2/8/19.
//  Copyright © 2019 hesham. All rights reserved.
//

#import "MainData.h"
#import <CoreLocation/CoreLocation.h>

static CLLocationCoordinate2D userLocationCoordinate;
static const CLLocationDistance LOCATION_DISTANCE = 5000.0;
NSString *const LOCATION_SERVICE_OFF_TITLE = @"Location service is OFF";
NSString *const LOCATION_SERVICE_OFF_MSG = @"Location service is needed to be enabled so the app can give you the available places.";
NSString *const AUTH_LOCATION_OFF_TITLE = @"Location services' access has been denied";
NSString *const AUTH_LOCATION_OFF_MSG = @"Please allow AroundYou app to access the services so the app can give you the available places.";
NSString *const AUTH_PARENTAL_OFF_TITLE = @"This app is not authorized to use location services";
NSString *const AUTH_PARENTAL_OFF_MSG = @"There are active restrictions such as parental controls being in place.";
NSString* const SEARCH_NOTHING_TITLE = @"Search has not succeeded to find this place near you.";
NSString* const SEARCH_PROGRESS_TITLE = @"Searching...";


@implementation MainData

+(CLLocationCoordinate2D)getUserLocationCoordinate {
    return userLocationCoordinate;
}

+(void)setUserLocationCoordinate:(CLLocationCoordinate2D) userLocation {
    userLocationCoordinate = userLocation;
}

+(CLLocationDistance)getUserLocationDistance {
    return LOCATION_DISTANCE;
}

+ (NSArray *)getCategories {
    NSArray *categories = @[@"ATM",
                    @"Bank",
                    @"Police",
                    @"Gas",
                    @"Bus",
                    @"Hospital",
                    @"Hotel",
                    @"Restaurant",
                    @"Cafe",
                    @"Park",
                    @"Cinema",
                    @"Pharmacy",
                    @"Market"];
    return categories;
}

@end
