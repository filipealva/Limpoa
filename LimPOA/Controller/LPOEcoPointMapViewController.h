//
//  LPOEcoPointMapViewController.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 6/23/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LPOEcoPointMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSMutableArray *ecoPoints;

@end
