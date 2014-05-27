//
//  LPODumpMapViewController.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/26/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LPODumpMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *dumps;

@end
