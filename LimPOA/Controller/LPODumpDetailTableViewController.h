//
//  LPODumpDetailTableViewController.h
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/28/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Dump.h"

@interface LPODumpDetailTableViewController : UITableViewController <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *dumps;

@end
