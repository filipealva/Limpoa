//
//  LPOCookingOilManager.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOCookingOilManager.h"

@interface LPOCookingOilManager ()

@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPOCookingOilManager

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

#pragma mark - CoreData

- (NSMutableArray *)selectAllCookingOilsWithLocation:(CLLocationCoordinate2D)currentLocation
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"CookingOil" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *cookingOils = [[NSMutableArray alloc] init];
    CLLocation *current = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (CookingOil *cookingOil in fetchedObjects) {
        CLLocation *cookingOilLocation = [[CLLocation alloc]
                                         initWithLatitude:[cookingOil.latitude doubleValue] longitude:[cookingOil.longitude doubleValue]];
        cookingOil.distance = [NSNumber numberWithDouble:[current distanceFromLocation:cookingOilLocation] / 1000];
        
        [cookingOils addObject:cookingOil];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return cookingOils;
}

- (NSMutableArray *)selectAllCookingOilsOrderedByDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"CookingOil" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *cookingOilArray = [[NSMutableArray alloc] init];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (CookingOil *cookingOil in fetchedObjects) {
        [cookingOilArray addObject:cookingOil];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return [self orderCookingOils:cookingOilArray byDistanceFromLocation:currentLocation];
}

#pragma mark - Ordering Helpers

- (NSMutableArray *)orderCookingOils:(NSMutableArray *)cookingOils byDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
{
    CLLocation *current = [[CLLocation alloc] initWithLatitude:currentLocation.latitude longitude:currentLocation.longitude];
    
    for (int i = 0; i < cookingOils.count; i++) {
        CLLocation *cookingOilLocation = [[CLLocation alloc]
                                         initWithLatitude:[[(CookingOil *)[cookingOils objectAtIndex:i] latitude] doubleValue]
                                         longitude:[[(CookingOil *)[cookingOils objectAtIndex:i] longitude] doubleValue]];
        [(CookingOil *)[cookingOils objectAtIndex:i] setDistance:[NSNumber numberWithDouble:
                                                                [current distanceFromLocation:cookingOilLocation] / 1000]];
    }
    
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = @[distanceDescriptor];
    
    return [NSMutableArray arrayWithArray:[cookingOils sortedArrayUsingDescriptors:sortDescriptors]];
}

@end
