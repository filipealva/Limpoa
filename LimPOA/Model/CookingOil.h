//
//  CookingOil.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BaseEntity.h"


@interface CookingOil : BaseEntity

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * openHours;
@property (nonatomic, retain) NSString * telephone;

@end
