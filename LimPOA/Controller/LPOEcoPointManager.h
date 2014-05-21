//
//  LPOEcoPointManager.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LPOAppDelegate.h"
#import "EcoPoint.h"

@interface LPOEcoPointManager : NSObject

- (NSMutableArray *)selectAllEcoPointsWithLocation:(CLLocationCoordinate2D)currentLocation;
- (NSMutableArray *)selectAllEcoPointsOrderedByDistanceFromLocation:(CLLocationCoordinate2D)currentLocation;

@end
