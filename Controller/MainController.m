//
//  ViewController.m
//  AroundYou
//
//  Created by hesham on 2/5/19.
//  Copyright © 2019 hesham. All rights reserved.
//

#import "MainController.h"
#import <CoreLocation/CoreLocation.h>
#import "CategoryTableViewController.h"
#import "../Model/MainData.h"


NSString* const CELL_ID = @"category_cell";
NSString* const SEGUE_ID = @"to_category_details";


@interface MainController () <CLLocationManagerDelegate>

@property NSArray* categories;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    _categories = [MainData getCategories];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    cell.textLabel.text = _categories[indexPath.row];
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:SEGUE_ID])
    {
        // Get reference to the destination view controller
//        CategoryTableViewController* vc = (CategoryTableViewController*) segue.destinationViewController;
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSString* category = [_categories objectAtIndex:indexPath.row];
//        // Pass any objects to the view controller here, like...
//        [vc setNavBarTitle:category];
        
        UITabBarController* tabBarController = segue.destinationViewController;
        CategoryTableViewController* vc = (CategoryTableViewController *)[[tabBarController viewControllers] objectAtIndex:0];
//        CategoryTableViewController* controller = (CategoryTableViewController *)[[navigationController viewControllers] objectAtIndex:0];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString* category = [_categories objectAtIndex:indexPath.row];
        // Pass any objects to the view controller here, like...
        [vc setNavBarTitle:category];
    }

}

@end
