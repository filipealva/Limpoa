//
//  LPOCookingOilManager.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LPOAppDelegate.h"
#import "CookingOil.h"

@interface LPOCookingOilManager : NSObject

- (NSMutableArray *)selectAllCookingOilsOrderedByDistanceFromLocation:(CLLocationCoordinate2D)currentLocation;

@end
