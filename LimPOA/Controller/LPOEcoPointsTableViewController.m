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
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPOEcoPointsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", self.ecoPoints);
}

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

- (NSMutableArray *)ecoPoints
{
    if (!_ecoPoints) {
        _ecoPoints = [[NSMutableArray alloc] initWithArray:[self selectAllEcoPoints]];
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
    
    NSLog(@"%@", ecoPoint);
    
    UILabel *ecoPointName = (UILabel *)[cell viewWithTag:100];
    UILabel *ecoPointAddress = (UILabel *)[cell viewWithTag:200];
    UILabel *distanceToEcoPoint = (UILabel *)[cell viewWithTag:300];
    
    ecoPointName.text = [@"EcoPonto " stringByAppendingString:ecoPoint.neighborhood];
    ecoPointAddress.text = ecoPoint.address;
    distanceToEcoPoint.text = @"0.2km";
    
    return cell;
}

#pragma mark - CoreData

- (NSMutableArray *)selectAllEcoPoints
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"EcoPoint" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *ecoPointsArray = [[NSMutableArray alloc] init];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (EcoPoint *ecoPoint in fetchedObjects) {
        [ecoPointsArray addObject:ecoPoint];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return ecoPointsArray;
}

@end
