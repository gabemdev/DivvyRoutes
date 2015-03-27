//
//  StationsListViewController.m
//  CodeChallenge3
//
//  Created by Vik Denic on 10/16/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "StationsListViewController.h"
#import "CustomTableViewCell.h"
#import "MapViewController.h"
#import "BikeData.h"
#import "BikeModel.h"

@interface StationsListViewController () <UITabBarDelegate, UITableViewDataSource, BikeDataDelegate, CLLocationManagerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property CLLocationManager *locationManager;
@property CLLocation *userLocation;
@property NSMutableArray *stationArray;
@property NSMutableArray *searchArray;
@property BikeData *bikeData;

@end

@implementation StationsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:[NSString stringWithFormat:@"Divvy Directions"]];

    self.bikeData = [BikeData new];
    self.bikeData.delegate = self;
    self.stationArray = [NSMutableArray new];
    self.searchArray = [NSMutableArray new];
    self.locationManager = [CLLocationManager new];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}


#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO:
    if (self.searchBar.text.length != 0) {
        return self.searchArray.count;
    }
    return self.stationArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO:
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (self.searchBar.text.length != 0) {
        BikeModel *model = [self.searchArray objectAtIndex:indexPath.row];
        cell.stationLabel.text = model.title;
        cell.statusStation.text = model.status;
        cell.bikesAvailableLabel.text = [NSString stringWithFormat:@"Bikes Available: %@", model.availableBikes];
        cell.distanceStation.text = [NSString stringWithFormat:@"Distance: %.2f MI", model.distance/1000];
        cell.stationNumber.text = [NSString stringWithFormat:@"%@", model.stationID];

        if ([model.status isEqualToString:@"Not Available"]) {
            cell.statusStation.textColor = [UIColor redColor];
        }
    } else {
        BikeModel *model = [self.stationArray objectAtIndex:indexPath.row];
        cell.stationLabel.text = model.title;
        cell.statusStation.text = model.status;
        cell.bikesAvailableLabel.text = [NSString stringWithFormat:@"Bikes Available: %@", model.availableBikes];
        cell.distanceStation.text = [NSString stringWithFormat:@"Distance: %.2f MI", model.distance/1000];
        cell.stationNumber.text = [NSString stringWithFormat:@"%@", model.stationID];

        if ([model.status isEqualToString:@"Not Available"]) {
            cell.statusStation.textColor = [UIColor redColor];
        }
    }
    return cell;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        if (location.horizontalAccuracy < 500 && location.verticalAccuracy < 500) {
            self.userLocation = location;
            [self.bikeData getBikeStationLocation:self.userLocation];
            [self.locationManager stopUpdatingLocation];
            break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to get your location"
                                                    message:@"Please make sure you have enabled location in your device settings"
                                                   delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Model Delegate
- (void)didGetArrayOfBikeResults:(NSMutableArray *)stops {
    self.stationArray = stops;
    [self.tableView reloadData];
}

#pragma mark - SearchBar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //Thanks Cocoanetics!!
    // https://www.cocoanetics.com/2010/03/filtering-fun-with-predicates/
    //
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.title CONTAINS[c] %@", searchText];
    self.searchArray = [NSMutableArray arrayWithArray:[self.stationArray filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
}


#pragma mark - Actions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell {
    MapViewController *vc = segue.destinationViewController;

    if (self.searchBar.text.length != 0) {
        vc.selectedBike = self.searchArray[[[self.tableView indexPathForCell:cell] row]];
    } else {
        vc.selectedBike = self.stationArray[[[self.tableView indexPathForCell:cell] row]];
    }
    MKPointAnnotation *user = [MKPointAnnotation new];
    user.coordinate = self.userLocation.coordinate;
}

@end
