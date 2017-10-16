//
//  LPOCookingOilsTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 15/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOCookingOilsTableViewController.h"
#import "LPOCookingOilMapViewController.h"
#import "LPOCookingOilDetailTableViewController.h"
#import "LPOIntroViewController.h"
#import "LPOInfoViewController.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface LPOCookingOilsTableViewController ()

- (IBAction)infoButtonTapped:(UIBarButtonItem *)sender;
@property (nonatomic, strong) NSMutableArray *cookingOilPoints;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) LPOLocationManager *locationManager;
@property (nonatomic) BOOL shouldReload;

@end

@implementation LPOCookingOilsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"cooking_oil_list_title", nil);
    
    [self startLocationManager];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"]) {
        self.shouldReload = true;
        LPOIntroViewController *intro = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
        [self.navigationController presentViewController:intro animated:NO completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName
           value:@"Lista Óleo Vegetal"];
    
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.shouldReload && [[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"]) {
        self.cookingOilPoints = [[NSMutableArray alloc] initWithArray:[[LPOCookingOilManager new] selectAllCookingOilsOrderedByDistanceFromLocation:self.currentLocation]];
        self.shouldReload = false;
        [self.tableView reloadData];
    }
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma mark - Lazy Instantiation

- (NSMutableArray *)cookingOilPoints
{
    if (!_cookingOilPoints) {
        _cookingOilPoints = [[NSMutableArray alloc] initWithArray:[[LPOCookingOilManager new] selectAllCookingOilsOrderedByDistanceFromLocation:self.currentLocation]];
    }
    
    return _cookingOilPoints;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cookingOilPoints.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CookingOilCell" forIndexPath:indexPath];
    
    CookingOil *cookingOil = (CookingOil *)[self.cookingOilPoints objectAtIndex:indexPath.row];
    
    UILabel *cookingOilName = (UILabel *)[cell viewWithTag:100];
    UILabel *cookingOilAddress = (UILabel *)[cell viewWithTag:200];
    UILabel *distanceToCoookingOilPoint = (UILabel *)[cell viewWithTag:300];
    
    cookingOilName.text = cookingOil.name;
    cookingOilAddress.text = cookingOil.address;
    distanceToCoookingOilPoint.text = [NSString stringWithFormat:@"%.2fkm", [cookingOil.distance doubleValue]];
    
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
    info.type = @"CookingOil";
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
    if ([segue.identifier isEqualToString:@"showCookingOilMap"]) {
		LPOCookingOilMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.cookingOils = [NSMutableArray arrayWithArray:[self.cookingOilPoints subarrayWithRange:NSMakeRange(0, 10)]];
	}
    
    if ([segue.identifier isEqualToString:@"showDetails"]) {
		LPOCookingOilDetailTableViewController *mapViewController = segue.destinationViewController;
        
        CookingOil *cookingOilPoint = [self.cookingOilPoints objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        mapViewController.cookingOils = [NSArray arrayWithObject:cookingOilPoint];
	}
}

@end
