//
//  LPOContainersTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/14/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOContainersTableViewController.h"
#import "LPOContainerMapViewController.h"
#import "LPOContainerDetailTableViewController.h"

@interface LPOContainersTableViewController ()

@property (nonatomic, strong) NSMutableArray *containers;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) LPOLocationManager *locationManager;

@end

@implementation LPOContainersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLocationManager];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)containers
{
    if (!_containers) {
        _containers = [[NSMutableArray alloc] initWithArray:[[LPOContainerManager new] selectAllContainersOrderedByDistanceFromLocation:self.currentLocation]];
    }
    
    return _containers;
}

- (CLLocationCoordinate2D) currentLocation
{
    if (_currentLocation.latitude == 0 && _currentLocation.longitude == 0) {
        _currentLocation = [[self.locationManager lastLocation] coordinate];
    }
    
    return _currentLocation;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.containers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContainerCell" forIndexPath:indexPath];
    
    Container *container = (Container *)[self.containers objectAtIndex:indexPath.row];
    
    UILabel *containerAddress = (UILabel *)[cell viewWithTag:100];
    UILabel *distanceToContainer = (UILabel *)[cell viewWithTag:200];
    
    containerAddress.text = container.address;
    distanceToContainer.text = [NSString stringWithFormat:@"%.2fkm", [container.distance doubleValue]];
    
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showContainersMap"]) {
		LPOContainerMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.containers = [NSMutableArray arrayWithArray:[self.containers subarrayWithRange:NSMakeRange(0, 9)]];
	}
    
    if ([segue.identifier isEqualToString:@"showDetails"]) {
		LPOContainerDetailTableViewController *detailViewController = segue.destinationViewController;
        
        Container *container = [self.containers objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        detailViewController.containers = [NSArray arrayWithObject:container];

	}
}


@end
