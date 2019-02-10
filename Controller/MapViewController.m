//
//  MapViewController.m
//  AroundYou
//
//  Created by hesham on 2/6/19.
//  Copyright © 2019 hesham. All rights reserved.
//

#import "MapViewController.h"
#import "../Model/MainData.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",@"MapView Loaded");
    [self setRegionInMap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self placeAnnotations];
}

-(void)setRegionInMap {
    CLLocationCoordinate2D coordinate = [MainData getUserLocationCoordinate];
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        CLLocationDistance regionDistance = [MainData getUserLocationDistance];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, regionDistance, regionDistance);
        [_mapView setRegion:region animated:true];
    }
}

-(void) placeAnnotations {
    // erase all then draw.
    [_mapView removeAnnotations:_mapView.annotations];
    for (MKPlacemark* placemark in _placemarks) {
        [_mapView addAnnotation:placemark];
    }
}

@end
