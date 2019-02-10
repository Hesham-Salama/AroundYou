//
//  MainData.h
//  AroundYou
//
//  Created by hesham on 2/6/19.
//  Copyright © 2019 hesham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



NS_ASSUME_NONNULL_BEGIN

extern NSString* const LOCATION_SERVICE_OFF_TITLE;
extern NSString* const LOCATION_SERVICE_OFF_MSG;
extern NSString* const AUTH_LOCATION_OFF_TITLE;
extern NSString* const AUTH_LOCATION_OFF_MSG;
extern NSString* const AUTH_PARENTAL_OFF_TITLE;
extern NSString* const AUTH_PARENTAL_OFF_MSG;
extern NSString* const SEARCH_NOTHING_TITLE;
extern NSString* const SEARCH_PROGRESS_TITLE;


@interface MainData : NSObject

+(CLLocationCoordinate2D)getUserLocationCoordinate;
+(void)setUserLocationCoordinate:(CLLocationCoordinate2D) userLocation;
+(NSArray *)getCategories;
+(CLLocationDistance)getUserLocationDistance;
@end

NS_ASSUME_NONNULL_END
