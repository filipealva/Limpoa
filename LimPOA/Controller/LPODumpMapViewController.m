//
//  LPODumpMapViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/26/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPODumpMapViewController.h"
#import "LPODumpPointAnnotation.h"
#import "LPODumpDetailTableViewController.h"
#import "Dump.h"
#import "CMMapLauncher.h"

static const NSString *WAZE_TITLE = @"Waze";
static const NSString *GOOGLE_MAPS_TITLE = @"Google Maps";

@interface LPODumpMapViewController () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation LPODumpMapViewController
{
	BOOL isGoogleMapsInstalled;
	BOOL isWazeInstalled;
	NSMutableArray *routeButtons;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"map_view_title", nil);
    
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
		[annotation setTitle:NSLocalizedString(@"dump_list_title", nil)];
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
	LPODumpPointAnnotation *annotation = (LPODumpPointAnnotation *)view.annotation;
    
    if (self.dumps.count == 1) {
        [self buttonRoutePressed];
    } else {
        [self performSegueWithIdentifier:@"showDumpDetail" sender:annotation];
    }
}

#pragma mark - Actions

- (void)traceRouteWithApp:(CMMapApp)app
{
	Dump *dump = [self.dumps objectAtIndex:0];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dump.latitude doubleValue], [dump.longitude doubleValue]);
    CMMapPoint *point = [CMMapPoint mapPointWithName:@"Lixeira" coordinate:coordinate];
	[CMMapLauncher launchMapApp:app forDirectionsTo:point];
}

- (void)buttonRoutePressed
{
	routeButtons = [[NSMutableArray alloc] init];
	
	isGoogleMapsInstalled = [CMMapLauncher isMapAppInstalled:CMMapAppGoogleMaps];
	isWazeInstalled = [CMMapLauncher isMapAppInstalled:CMMapAppWaze];
	
	if (!isGoogleMapsInstalled && !isWazeInstalled) {
		[self traceRouteWithApp:CMMapAppAppleMaps];
	} else {
		[routeButtons addObject:NSLocalizedString(@"Maps", nil)];
		
		if (isGoogleMapsInstalled) {
			[routeButtons addObject:GOOGLE_MAPS_TITLE];
		}
		
		if (isWazeInstalled) {
			[routeButtons addObject:WAZE_TITLE];
		}
        
		UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
		actionSheet.title = NSLocalizedString(@"place_title_route_options", nil);
		actionSheet.delegate = self;
		
		for (NSString *title in routeButtons) {
			[actionSheet addButtonWithTitle:title];
		}
		
		actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
		
		[actionSheet showInView:self.view];
	}
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != routeButtons.count) {
		NSString *buttonTitle = routeButtons[buttonIndex];
        
		if (buttonIndex == 0) {
			[self traceRouteWithApp:CMMapAppAppleMaps];
		} else if ([buttonTitle isEqualToString:[NSString stringWithFormat:@"%@", GOOGLE_MAPS_TITLE]]) {
			[self traceRouteWithApp:CMMapAppGoogleMaps];
		} else {
			[self traceRouteWithApp:CMMapAppWaze];
		}
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDumpDetail"]) {
		LPODumpDetailTableViewController *detailViewController = segue.destinationViewController;
        
        LPODumpPointAnnotation *annotation = (LPODumpPointAnnotation *)sender;
        
        Dump *dump = annotation.dump;
        
        detailViewController.dumps = [NSArray arrayWithObject:dump];
	}
}

@end
