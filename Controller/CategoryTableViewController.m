//
//  CategoryTableViewController.m
//  AroundYou
//
//  Created by hesham on 2/6/19.
//  Copyright © 2019 hesham. All rights reserved.
//

#import "CategoryTableViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <SVProgressHUD.h>
#import <MapKit/MapKit.h>
#import "../Model/MainData.h"
#import "MapViewController.h"

NSString *const CELL_TABLE_ID = @"location_cell";

@interface CategoryTableViewController () <CLLocationManagerDelegate>
// This property does NOT retain its delegate.
@property CLLocationManager* locationManager;
@property (nonatomic)NSArray<MKMapItem*>* places;
-(void)getCategories;
-(void)updateTableWithLocations;
-(void)checkLocationServices;
-(void)setupLocationManager;
-(void)checkLocationAuthorization;
-(void)showSimpleAlert:(NSString*)message :(NSString*)title :(void (^)(UIAlertAction*))alertBlock;
-(void)openLocationServiceMenu;
-(void)setPlacemarksArr:(NSArray<MKPlacemark*>*) placeMarks;
@end

@implementation CategoryTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:UIColor.lightGrayColor];
    [SVProgressHUD showWithStatus:SEARCH_PROGRESS_TITLE];
    [self setLocationManager:[[CLLocationManager alloc]init]];
    [self checkLocationServices];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController setTitle:self.navBarTitle];
//    [self.tabBarController setSelectedIndex:1];
}

-(void)checkLocationServices {
    if (CLLocationManager.locationServicesEnabled) {
        [self setupLocationManager];
        [self checkLocationAuthorization];
    } else {
        [self showSimpleAlert:LOCATION_SERVICE_OFF_TITLE :LOCATION_SERVICE_OFF_MSG :^(UIAlertAction * alertAction) {
            [self.navigationController popViewControllerAnimated:YES];
            [self openLocationServiceMenu];
        }];
    }
}

-(void)setupLocationManager {
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(void)checkLocationAuthorization {
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied: {
            [self showSimpleAlert:AUTH_LOCATION_OFF_TITLE :AUTH_LOCATION_OFF_MSG :^(UIAlertAction * alertAction) {
                [self.navigationController popViewControllerAnimated:YES];
                [self openLocationServiceMenu];
            }];
            [SVProgressHUD dismiss];
            break;
        }
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted: {
            [self showSimpleAlert:AUTH_PARENTAL_OFF_TITLE :AUTH_PARENTAL_OFF_MSG :^(UIAlertAction * alertAction) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [SVProgressHUD dismiss];
            break;
        }
        default:
            break;
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* lastLocation = (CLLocation*) locations.lastObject;
    if (lastLocation) {
        [MainData setUserLocationCoordinate:lastLocation.coordinate];
        //Stopping updating location is NOT enough.
        [self.locationManager stopUpdatingLocation];
        _locationManager = nil;
        [self getCategories];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self checkLocationAuthorization];
}


-(void)getCategories {
    MKLocalSearchRequest* request = [[MKLocalSearchRequest alloc] init];
    CLLocationDistance distance = [MainData getUserLocationDistance];
    request.region = MKCoordinateRegionMakeWithDistance([MainData getUserLocationCoordinate], distance, distance);
    request.naturalLanguageQuery = _navBarTitle;
    MKLocalSearch* localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"local search has begun!!!");
        if(error){
            NSLog(@"LocalSearch failed with error: %@", error);
        } else {
            self->_places = response.mapItems;
            NSMutableArray<MKPlacemark*>* placemarksArr = [NSMutableArray new];
            for (MKMapItem* mapItem in response.mapItems) {
                [placemarksArr addObject:mapItem.placemark];
            }
            [self setPlacemarksArr:[placemarksArr copy]];
        }
        [self updateTableWithLocations];
    }];
}

-(void)showSimpleAlert:(NSString*)message :(NSString*)title :(void (^)(UIAlertAction*))alertBlock {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:alertBlock];
    
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openLocationServiceMenu {
    NSURL *url = [NSURL URLWithString:[UIApplicationOpenSettingsURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [UIApplication.sharedApplication openURL:url options:@{} completionHandler:nil];
}

- (void)updateTableWithLocations {
    if (_places.count != 0) {
        [self.tableView reloadData];
    } else {
        [self showSimpleAlert:SEARCH_NOTHING_TITLE :@"" :^(UIAlertAction * alertBlock) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    [SVProgressHUD dismiss];
}

#pragma mark - Table view data source
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _places.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_TABLE_ID forIndexPath:indexPath];
    cell.textLabel.text = _places[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray<MKPlacemark*>* placemarkArr = [[NSArray alloc] initWithObjects:_places[indexPath.row].placemark, nil];
    [self setPlacemarksArr:placemarkArr];
    [self.tabBarController setSelectedIndex:1];
}

-(void)setPlacemarksArr:(NSArray<MKPlacemark*>*) placeMarks {
    MapViewController* mapVC = (MapViewController*) self.tabBarController.viewControllers[1];
    [mapVC setPlacemarks:placeMarks];
}
@end
