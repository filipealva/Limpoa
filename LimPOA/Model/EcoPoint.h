//
//  EcoPoint.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/14/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EcoPoint : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * neighborhood;
@property (nonatomic, retain) NSString * telephone;

@end
