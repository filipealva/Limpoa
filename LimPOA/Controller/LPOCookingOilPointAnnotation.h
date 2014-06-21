//
//  LPOCookingOilPointAnnotation.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 6/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "CookingOil.h"

@interface LPOCookingOilPointAnnotation : MKPointAnnotation

@property (nonatomic, strong) CookingOil *cookingOil;

@end
