//
//  LPODumpManager.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/20/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LPOAppDelegate.h"
#import "Dump.h"

@interface LPODumpManager : NSObject

- (NSMutableArray *)selectAllDumpsWithLocation:(CLLocationCoordinate2D)currentLocation;
- (NSMutableArray *)selectAllDumpsOrderedByDistanceFromLocation:(CLLocationCoordinate2D)currentLocation;

@end
