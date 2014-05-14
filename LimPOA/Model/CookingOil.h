//
//  CookingOil.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 14/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CookingOil : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * openHours;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
