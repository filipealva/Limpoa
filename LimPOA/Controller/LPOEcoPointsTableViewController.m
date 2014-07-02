//
//  LPOEcoPointsTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/15/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOEcoPointsTableViewController.h"
#import "LPOEcoPointMapViewController.h"
#import "LPOEcoPointDetailTableViewController.h"
#import "LPOInfoViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface LPOEcoPointsTableViewController ()

- (IBAction)infoButtonTapped:(UIBarButtonItem *)sender;
@property (nonatomic, strong) NSMutableArray *ecoPoints;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) LPOLocationManager *locationManager;

@end

@implementation LPOEcoPointsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"ecopoint_list_title", nil);
    
    [self startLocationManager];
}

- (void)viewDidAppear:(BOOL)animated
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Lista de EcoPontos"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Lazy Instantiation

- (NSMutableArray *)ecoPoints
{
    if (!_ecoPoints) {
        _ecoPoints = [[NSMutableArray alloc] initWithArray:[[LPOEcoPointManager new] selectAllEcoPointsOrderedByDistanceFromLocation:self.currentLocation]];
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

- (IBAction)infoButtonTapped:(UIBarButtonItem *)sender
{
    UINavigationController *navigation = [self.storyboard instantiateViewControllerWithIdentifier:@"Info"];
    LPOInfoViewController *info = (LPOInfoViewController *)[navigation.viewControllers objectAtIndex:0];
    info.type = @"EcoPoint";
    [self.navigationController presentViewController:navigation animated:YES completion:nil];
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
    if ([segue.identifier isEqualToString:@"showMap"]) {
		LPOEcoPointMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.ecoPoints = [NSMutableArray arrayWithArray:[self.ecoPoints subarrayWithRange:NSMakeRange(0, self.ecoPoints.count)]];
	}
    
    if ([segue.identifier isEqualToString:@"showDetails"]) {
		LPOEcoPointDetailTableViewController *detailViewControler = segue.destinationViewController;
        
        EcoPoint *ecoPoint = [self.ecoPoints objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        detailViewControler.ecoPoints = [NSArray arrayWithObject:ecoPoint];
	}
}

@end
