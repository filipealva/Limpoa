//
//  LPOEcoPointsTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/15/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOEcoPointsTableViewController.h"

@interface LPOEcoPointsTableViewController ()

@property (nonatomic, strong) NSMutableArray *ecoPoints;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) LPOLocationManager *locationManager;

@end

@implementation LPOEcoPointsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLocationManager];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)ecoPoints
{
    if (!_ecoPoints) {
        _ecoPoints = [[NSMutableArray alloc] initWithArray:[[LPOEcoPointManager new] selectAllCookingOilsOrderedByDistanceFromLocation:self.currentLocation]];
    }
    
    return _ecoPoints;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ecoPoints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EcoPointCell" forIndexPath:indexPath];
    
    EcoPoint *ecoPoint = (EcoPoint *)[self.ecoPoints objectAtIndex:indexPath.row];
    
    UILabel *ecoPointName = (UILabel *)[cell viewWithTag:100];
    UILabel *ecoPointAddress = (UILabel *)[cell viewWithTag:200];
    UILabel *distanceToEcoPoint = (UILabel *)[cell viewWithTag:300];
    
    ecoPointName.text = [@"EcoPonto " stringByAppendingString:ecoPoint.neighborhood];
    ecoPointAddress.text = ecoPoint.address;
    distanceToEcoPoint.text = [NSString stringWithFormat:@"%.2fkm", [ecoPoint.distance doubleValue]];
    
    return cell;
}

#pragma mark - Actions

- (void)startLocationManager
{
	if (!self.locationManager) {
		[self setLocationManager:[LPOLocationManager sharedManager]];
		[self.locationManager addDelegate:self];
	}
}

#pragma mark - LPOLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    CLLocation *current = [[CLLocation alloc] initWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
    
    if ([current distanceFromLocation:location] > 100) {
        self.currentLocation = location.coordinate;
    }
}

@end
