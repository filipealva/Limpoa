//
//  LPOContainerPointAnnotation.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 6/20/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Container.h"

@interface LPOContainerPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) Container *container;

@end
