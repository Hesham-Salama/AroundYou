//
//  MapViewController.h
//  AroundYou
//
//  Created by hesham on 2/6/19.
//  Copyright © 2019 hesham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapViewController : UIViewController

-(void)setRegionInMap;
@property NSArray<MKPlacemark*>* placemarks;

@end

NS_ASSUME_NONNULL_END
