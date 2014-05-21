//
//  LPOContainerManager.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 21/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOContainerManager.h"

@interface LPOContainerManager ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPOContainerManager

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

#pragma mark - CoreData

- (NSMutableArray *)selectAllContainersWithLocation:(CLLocationCoordinate2D)currentLocation
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Container" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *containersArray = [[NSMutableArray alloc] init];
    CLLocation *current = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (Container *container in fetchedObjects) {
        CLLocation *containerLocation = [[CLLocation alloc]
                                    initWithLatitude:[container.latitude doubleValue] longitude:[container.longitude doubleValue]];
        container.distance = [NSNumber numberWithDouble:[current distanceFromLocation:containerLocation] / 1000];
        
        [containersArray addObject:container];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return containersArray;
}

- (NSMutableArray *)selectAllContainersOrderedByDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Container" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *containersArray = [[NSMutableArray alloc] init];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (Container *container in fetchedObjects) {
        [containersArray addObject:container];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return [self orderContainers:containersArray byDistanceFromLocation:currentLocation];
}

#pragma mark - Ordering Helpers

- (NSMutableArray *)orderContainers:(NSMutableArray *)containers byDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
{
    CLLocation *current = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
    for (int i = 0; i < containers.count; i++) {
        CLLocation *containerLocation = [[CLLocation alloc]
                                    initWithLatitude:[[(Container *)[containers objectAtIndex:i] latitude] doubleValue]
                                    longitude:[[(Container *)[containers objectAtIndex:i] longitude] doubleValue]];
        [(Container *)[containers objectAtIndex:i] setDistance:[NSNumber numberWithDouble:
                                                      [current distanceFromLocation:containerLocation] / 1000]];
    }
    
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = @[distanceDescriptor];
    
    return [NSMutableArray arrayWithArray:[containers sortedArrayUsingDescriptors:sortDescriptors]];
}

@end
