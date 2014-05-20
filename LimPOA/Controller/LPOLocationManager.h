//
//  LPOLocationManager.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 20/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LPOLocationManagerDelegate <NSObject>
@optional

- (void)locationManager:(CLLocationManager *)manager didUpdateLocation:(CLLocation *)location;
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

@end

@interface LPOLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id <LPOLocationManagerDelegate> delegate;
@property (nonatomic, strong) CLLocationManager *manager;

+ (LPOLocationManager *)sharedManager;

- (CLLocation *)lastLocation;

- (void)addDelegate:(id <LPOLocationManagerDelegate>)object;
- (void)removeDelegate:(id <LPOLocationManagerDelegate>)object;

- (NSString *)humanErrorMessage;

@end
