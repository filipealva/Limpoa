//
//  LPOGeneralDataManager.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOGeneralDataManager.h"

@interface LPOGeneralDataManager ()

@end

@implementation LPOGeneralDataManager

#pragma mark - Getting data

- (NSMutableArray *)selectAllDataOrderedByDistanceFrom:(CLLocationCoordinate2D)currentLocation
{
    NSMutableArray *allData = [[NSMutableArray alloc] init];
    
    [allData addObjectsFromArray:[[LPODumpManager new] selectAllDumpsWithLocation:currentLocation]];
    [allData addObjectsFromArray:[[LPOContainerManager new] selectAllContainersWithLocation:currentLocation]];
    [allData addObjectsFromArray:[[LPOCookingOilManager new] selectAllCookingOilsWithLocation:currentLocation]];
    [allData addObjectsFromArray:[[LPOEcoPointManager new] selectAllEcoPointsWithLocation:currentLocation]];
    
    return [self orderAllData:allData byDistanceFromLocation:currentLocation];
}

#pragma mark - Ordering Helpers

- (NSMutableArray *)orderAllData:(NSMutableArray *)allData byDistanceFromLocation:(CLLocationCoordinate2D)currentLocation
{
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    NSArray *sortDescriptors = @[distanceDescriptor];
    
    return [NSMutableArray arrayWithArray:[allData sortedArrayUsingDescriptors:sortDescriptors]];
}

@end
