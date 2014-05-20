//
//  LPODumpsTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/13/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPODumpsTableViewController.h"

@interface LPODumpsTableViewController ()

@property (nonatomic, strong) NSMutableArray *dumps;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, strong) LPOLocationManager *locationManager;

@end

@implementation LPODumpsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startLocationManager];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"]) {
        LPOIntroViewController *intro = [self.storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
        [self.navigationController presentViewController:intro animated:NO completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%8f %8f", self.currentLocation.latitude, self.currentLocation.longitude);
}

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

- (NSMutableArray *)dumps
{
    if (!_dumps) {
        _dumps = [[NSMutableArray alloc] initWithArray:[self updateDumpList]];
    }
    
    return _dumps;
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
    return self.dumps.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DumpCell" forIndexPath:indexPath];
    
    Dump *dump = (Dump *)[self.dumps objectAtIndex:indexPath.row];
    
    NSLog(@"%@", dump);
    NSLog(@"%@", [[LPOLocationManager sharedManager] lastLocation]);
    
    UILabel *dumpAddress = (UILabel *)[cell viewWithTag:100];
    UILabel *distanceToDump = (UILabel *)[cell viewWithTag:200];
    
    dumpAddress.text = dump.address;
    distanceToDump.text = @"0.2km";
    
    return cell;
}

#pragma mark - CoreData

- (NSMutableArray *)updateDumpList
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dump" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *dumpsArray = [[NSMutableArray alloc] init];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (Dump *dump in fetchedObjects) {
        [dumpsArray addObject:dump];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return dumpsArray;
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
