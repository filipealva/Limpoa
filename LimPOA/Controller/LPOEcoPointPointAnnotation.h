//
//  LPOEcoPointPointAnnotation.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 6/23/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "EcoPoint.h"

@interface LPOEcoPointPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) EcoPoint *ecoPoint;

@end
