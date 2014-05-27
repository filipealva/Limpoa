//
//  LPODumpPointAnnotation.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/26/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Dump.h"

@interface LPODumpPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) Dump *dump;

@end
