//
//  LPOContainerManager.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 21/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LPOAppDelegate.h"
#import "Container.h"

@interface LPOContainerManager : NSObject

- (NSMutableArray *)selectAllContainersOrderedByDistanceFromLocation:(CLLocationCoordinate2D)currentLocation;

@end
