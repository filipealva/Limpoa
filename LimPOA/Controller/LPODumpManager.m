//
//  LPODumpManager.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/20/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPODumpManager.h"

@interface LPODumpManager ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPODumpManager

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

#pragma mark - CoreData

- (NSMutableArray *)selectAllDumpsWithLocation:(CLLocationCoordinate2D)currentLocation
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dump" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *dumpsArray = [[NSMutableArray alloc] init];
    CLLocation *current = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (Dump *dump in fetchedObjects) {
        CLLocation *dumpLocation = [[CLLocation alloc]
                                    initWithLatitude:[dump.latitude doubleValue] longitude:[dump.longitude doubleValue]];
        dump.distance = [NSNumber numberWithDouble:[current distanceFromLocation:dumpLocation] / 1000];
        
        [dumpsArray addObject:dump];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return dumpsArray;
}

- (NSMutableArray *)selectAllDumpsOrderedByDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
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
    
    return [self orderDumps:dumpsArray byDistanceFromLocation:currentLocation];
}

#pragma mark - Ordering Helpers

- (NSMutableArray *)orderDumps:(NSMutableArray *)dumps byDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
{
    CLLocation *current = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
    for (int i = 0; i < dumps.count; i++) {
        CLLocation *dumpLocation = [[CLLocation alloc]
                                    initWithLatitude:[[(Dump *)[dumps objectAtIndex:i] latitude] doubleValue]
                                    longitude:[[(Dump *)[dumps objectAtIndex:i] longitude] doubleValue]];
        [(Dump *)[dumps objectAtIndex:i] setDistance:[NSNumber numberWithDouble:
                                                      [current distanceFromLocation:dumpLocation] / 1000]];
    }
    
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = @[distanceDescriptor];

    return [NSMutableArray arrayWithArray:[dumps sortedArrayUsingDescriptors:sortDescriptors]];
}

@end
