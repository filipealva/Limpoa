//
//  LPOGeneralTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOGeneralTableViewController.h"

@interface LPOGeneralTableViewController ()

@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) LPOLocationManager *locationManager;

@end

@implementation LPOGeneralTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLocationManager];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)allData
{
    if (!_allData) {
        _allData = [[NSMutableArray alloc] initWithArray:[[LPOGeneralDataManager new] selectAllDataOrderedByDistanceFrom:self.currentLocation]];
    }
    
    return _allData;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralCell" forIndexPath:indexPath];
    
    UILabel *name = (UILabel *)[cell viewWithTag:100];
    UILabel *address = (UILabel *)[cell viewWithTag:200];
    UILabel *distanceTo = (UILabel *)[cell viewWithTag:300];
    UIImageView *typeImage = (UIImageView *)[cell viewWithTag:400];
    
    if ([[self.allData objectAtIndex:indexPath.row] isKindOfClass:[Dump class]]) {
        Dump *dump = (Dump *)[self.allData objectAtIndex:indexPath.row];
        
        name.text = @"Lixeira";
        address.text = dump.address;
        distanceTo.text = [NSString stringWithFormat:@"%.2fkm", [dump.distance doubleValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            typeImage.image = [UIImage imageNamed:@"Buzz-Trash-icon"];
        });
    } else if ([[self.allData objectAtIndex:indexPath.row] isKindOfClass:[Container class]]) {
        Container *container = (Container *)[self.allData objectAtIndex:indexPath.row];
        
        name.text = @"Container";
        address.text = container.address;
        distanceTo.text = [NSString stringWithFormat:@"%.2fkm", [container.distance doubleValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            typeImage.image = [UIImage imageNamed:@"Buzz-Trash-icon"];
        });
    } else if ([[self.allData objectAtIndex:indexPath.row] isKindOfClass:[CookingOil class]]) {
        CookingOil *cookingOil = (CookingOil *)[self.allData objectAtIndex:indexPath.row];
        
        name.text = cookingOil.name;
        address.text = cookingOil.address;
        distanceTo.text = [NSString stringWithFormat:@"%.2fkm", [cookingOil.distance doubleValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            typeImage.image = [UIImage imageNamed:@"Buzz-Trash-icon"];
        });
    } else if ([[self.allData objectAtIndex:indexPath.row] isKindOfClass:[EcoPoint class]]) {
        EcoPoint *ecoPoint = (EcoPoint *)[self.allData objectAtIndex:indexPath.row];
        
        name.text = [@"EcoPonto " stringByAppendingString:ecoPoint.neighborhood];
        address.text = ecoPoint.address;
        distanceTo.text = [NSString stringWithFormat:@"%.2fkm", [ecoPoint.distance doubleValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            typeImage.image = [UIImage imageNamed:@"Buzz-Trash-icon"];
        });
    }

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
