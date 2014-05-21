//
//  LPOEcoPointManager.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOEcoPointManager.h"

@interface LPOEcoPointManager ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPOEcoPointManager

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

#pragma mark - CoreData

- (NSMutableArray *)selectAllCookingOilsOrderedByDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"EcoPoint" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *ecoPointArray = [[NSMutableArray alloc] init];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (EcoPoint *ecoPoint in fetchedObjects) {
        [ecoPointArray addObject:ecoPoint];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return [self orderContainers:ecoPointArray byDistanceFromLocation:currentLocation];
}

#pragma mark - Ordering Helpers

- (NSMutableArray *)orderContainers:(NSMutableArray *)ecoPoints byDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
{
    CLLocation *current = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
    for (int i = 0; i < ecoPoints.count; i++) {
        CLLocation *ecoPointLocation = [[CLLocation alloc]
                                          initWithLatitude:[[(EcoPoint *)[ecoPoints objectAtIndex:i] latitude] doubleValue]
                                          longitude:[[(EcoPoint *)[ecoPoints objectAtIndex:i] longitude] doubleValue]];
        [(EcoPoint *)[ecoPoints objectAtIndex:i] setDistance:[NSNumber numberWithDouble:[current distanceFromLocation:ecoPointLocation] / 1000]];
    }
    
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = @[distanceDescriptor];
    
    return [NSMutableArray arrayWithArray:[ecoPoints sortedArrayUsingDescriptors:sortDescriptors]];
}

@end
