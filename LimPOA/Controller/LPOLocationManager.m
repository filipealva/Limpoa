//
//  LPOLocationManager.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 20/05/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOLocationManager.h"

@interface LPOLocationManager ()

@property (nonatomic, strong) NSMutableArray *delegates;

@end

@implementation LPOLocationManager

+ (LPOLocationManager *)sharedManager
{
	static LPOLocationManager *_default = nil;
	static dispatch_once_t safer;
	
	if (_default != nil) {
		return _default;
	}
	
	dispatch_once(&safer, ^(void) {
		_default = [[LPOLocationManager alloc] initSingleton];
	});
	
	return _default;
}

- (instancetype)initSingleton
{
    if (self = [super init]) {
        [self.manager setDelegate:self];
		[self.manager setDesiredAccuracy:kCLLocationAccuracyBest];
		[self.manager setDistanceFilter:10];
		[self.manager startUpdatingLocation];
    }
    
    return self;
}

#pragma mark - Lazy Instantiation

- (CLLocationManager *)manager
{
	if (!_manager) {
		_manager = [[CLLocationManager alloc] init];
	}
	
	return _manager;
}

- (NSMutableArray *)delegates
{
	if (!_delegates) {
		_delegates = [[NSMutableArray alloc] init];
	}
	
	return _delegates;
}

#pragma mark - Delegate Getters/Setters

- (void)addDelegate:(id <LPOLocationManagerDelegate>)object
{
	NSValue *pointerToDelegate = [NSValue valueWithPointer:CFBridgingRetain(object)];
	[self.delegates addObject:pointerToDelegate];
	
	if ([self lastLocation] && [object respondsToSelector:@selector(locationManager:didUpdateLocation:)]) {
		[object locationManager:self.manager didUpdateLocation:[self lastLocation]];
	}
}

- (void)removeDelegate:(id <LPOLocationManagerDelegate>)object
{
	NSValue *pointerToDelegate = [NSValue valueWithPointer:CFBridgingRetain(object)];
    [self.delegates removeObject:pointerToDelegate];
}

#pragma mark - Getters

- (CLLocation *)lastLocation
{
	return [self.manager location];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    for (NSValue *val in self.delegates) {
        id <LPOLocationManagerDelegate> delegate = [val pointerValue];
		
		if ([delegate respondsToSelector:@selector(locationManager:didFailWithError:)]) {
			[delegate locationManager:manager didFailWithError:error];
		}
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
	
	for (NSValue *val in self.delegates) {
        id <LPOLocationManagerDelegate> delegate = [val pointerValue];
		
		if ([delegate respondsToSelector:@selector(locationManager:didUpdateLocation:)]) {
			[delegate locationManager:manager didUpdateLocation:location];
		}
    }
}

#pragma mark - Handle errors correctly

- (NSString *)humanErrorMessage
{
	if (CLLocationManager.locationServicesEnabled && CLLocationManager.authorizationStatus != kCLAuthorizationStatusDenied) {
		return @"Location disabled";
	} else if (CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied) {
		return @"Location denied";
	}
	
	return @"Some location error ocurred";
}

@end