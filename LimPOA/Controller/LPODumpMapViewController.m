//
//  LPODumpMapViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/26/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPODumpMapViewController.h"
#import "LPODumpPointAnnotation.h"
#import "Dump.h"

@interface LPODumpMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation LPODumpMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateAnnotationsWithPlaces:self.dumps];
    [self zoomToFitMapWithAnnotations:self.mapView.annotations];
    
    [self.mapView setShowsUserLocation:YES];
}



- (MKPointAnnotation *)mapViewAnnotationWithPlace:(Dump *)dump
{
	for (MKPointAnnotation *annotation in self.mapView.annotations) {
		if ([annotation isKindOfClass:[LPODumpPointAnnotation class]]) {
			LPODumpPointAnnotation *annotationObject = (LPODumpPointAnnotation *)annotation;
            
			if ([[[annotationObject.dump objectID] URIRepresentation] isEqual:[[dump objectID] URIRepresentation]]) {
				return annotationObject;
			}
		}
	}
	
	return nil;
}

- (void)updateAnnotationsWithPlaces:(NSArray *)dumpsList
{
    NSMutableArray *dumps = [[NSMutableArray alloc] initWithArray:dumpsList];
	NSMutableArray *annotations = [[NSMutableArray alloc] init];
	
	// Get annotations that isn't on MapView new annotations
	for (Dump *dump in dumpsList) {
		LPODumpPointAnnotation *annotation = (LPODumpPointAnnotation *)[self mapViewAnnotationWithPlace:dump];
        
		if (annotation) {
            [dumps removeObject:dump];
		}
	}
	
    // Construct Annotations
	for (int i = 0; i < dumps.count; i++) {
		Dump *dump = [dumps objectAtIndex:i];
		LPODumpPointAnnotation *annotation = [[LPODumpPointAnnotation alloc] init];
		[annotation setDump:dump];
		[annotation setCoordinate:CLLocationCoordinate2DMake([dump.latitude doubleValue], [dump.longitude doubleValue])];
		[annotation setTitle:@"Lixeira"];
		[annotation setSubtitle:dump.address];
		[annotations addObject:annotation];
	}
	
    // Add new set of annotations to MapView
	[self.mapView addAnnotations:annotations];
    
    // Animate Annotation, if there is only one
    if (self.mapView.annotations.count == 1) {
        [self.mapView selectAnnotation:[annotations objectAtIndex:0] animated:YES];
    }
}

// Zoom MapView to fit all annotations on screen
- (void)zoomToFitMapWithAnnotations:(NSArray *)annotations
{
    if (self.mapView.annotations.count == 0) {
        return;
    }
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for (MKPointAnnotation *annotation in annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }

    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2;
    
    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];
}


#pragma mark - MKMapKitDelegate

- (CLLocationDistance)distanceBetweenLocation:(CLLocationCoordinate2D)locationA and:(CLLocationCoordinate2D)locationB
{
    CLLocation *newLocationA = [[CLLocation alloc] initWithLatitude:locationA.latitude longitude:locationA.longitude];
    CLLocation *newLocationB = [[CLLocation alloc] initWithLatitude:locationB.latitude longitude:locationB.longitude];
    
    return [newLocationA distanceFromLocation:newLocationB];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[MKUserLocation class]]) {
		return nil;
	}
    
	MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
    
    if (self.mapView.annotations.count > 1) {
        [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    } else {
        [annotationView setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    }
    
	[annotationView setAnimatesDrop:YES];
    [annotationView setCanShowCallout:YES];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
//	CRDPlacePointAnnotation *annotation = (CRDPlacePointAnnotation *)view.annotation;
    
    if (self.dumps.count == 1) {
//        [self buttonRoutePressed];
    } else {
//        [self performSegueWithIdentifier:@"Place" sender:annotation];
    }
}


@end
