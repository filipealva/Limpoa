//
//  LPOCookingOilDetailTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 6/21/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOCookingOilDetailTableViewController.h"
#import "LPOCookingOilPointAnnotation.h"
#import "CookingOil.h"
#import "CMMapLauncher.h"

static const NSString *WAZE_TITLE = @"Waze";
static const NSString *GOOGLE_MAPS_TITLE = @"Google Maps";

@interface LPOCookingOilDetailTableViewController () <UIActionSheetDelegate>

- (IBAction)routePressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *openHoursLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *routeButton;

@end

@implementation LPOCookingOilDetailTableViewController
{
	BOOL isGoogleMapsInstalled;
	BOOL isWazeInstalled;
	NSMutableArray *routeButtons;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"details_title", nil);
    
    self.routeButton.title = NSLocalizedString(@"route_button_title", nil);
    
    CookingOil *cookingOil = (CookingOil *)self.cookingOils[0];

    self.addressLabel.text = cookingOil.address;
    self.phoneLabel.text = cookingOil.telephone ? cookingOil.telephone : @"Telefone indisponível";
    self.openHoursLabel.text = cookingOil.openHours ? cookingOil.openHours : @"Seg a Sex - Horário comercial";
    
    [self updateAnnotationsWithPlaces:self.cookingOils];
    [self zoomToFitMapWithAnnotations:self.mapView.annotations];
    
    [self.mapView setShowsUserLocation:YES];
}



- (MKPointAnnotation *)mapViewAnnotationWithPlace:(CookingOil *)cookingOil
{
	for (MKPointAnnotation *annotation in self.mapView.annotations) {
		if ([annotation isKindOfClass:[LPOCookingOilPointAnnotation class]]) {
			LPOCookingOilPointAnnotation *annotationObject = (LPOCookingOilPointAnnotation *)annotation;
            
			if ([[[annotationObject.cookingOil objectID] URIRepresentation] isEqual:[[cookingOil objectID] URIRepresentation]]) {
				return annotationObject;
			}
		}
	}
	
	return nil;
}

- (void)updateAnnotationsWithPlaces:(NSArray *)cookingOilList
{
    NSMutableArray *cookingOils = [[NSMutableArray alloc] initWithArray:cookingOilList];
	NSMutableArray *annotations = [[NSMutableArray alloc] init];
	
	// Get annotations that isn't on MapView new annotations
	for (CookingOil *cookingOil in cookingOilList) {
		LPOCookingOilPointAnnotation *annotation = (LPOCookingOilPointAnnotation *)[self mapViewAnnotationWithPlace:cookingOil];
        
		if (annotation) {
            [cookingOils removeObject:cookingOil];
		}
	}
	
    // Construct Annotations
	for (int i = 0; i < cookingOils.count; i++) {
		CookingOil *cookingOil = [cookingOils objectAtIndex:i];
		LPOCookingOilPointAnnotation *annotation = [[LPOCookingOilPointAnnotation alloc] init];
		[annotation setCookingOil:cookingOil];
		[annotation setCoordinate:CLLocationCoordinate2DMake([cookingOil.latitude doubleValue], [cookingOil.longitude doubleValue])];
		[annotation setTitle:cookingOil.name];
		[annotation setSubtitle:cookingOil.address];
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
	LPOCookingOilPointAnnotation *annotation = (LPOCookingOilPointAnnotation *)view.annotation;
    
    if (self.cookingOils.count == 1) {
        [self buttonRoutePressed];
    } else {
        [self performSegueWithIdentifier:@"showDumpDetail" sender:annotation];
    }
}

#pragma mark - Actions

- (void)traceRouteWithApp:(CMMapApp)app
{
	CookingOil *cookingOil = [self.cookingOils objectAtIndex:0];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([cookingOil.latitude doubleValue], [cookingOil.longitude doubleValue]);
    CMMapPoint *point = [CMMapPoint mapPointWithName:cookingOil.name coordinate:coordinate];
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
		actionSheet.title = NSLocalizedString(@"route_options_title", nil);
		actionSheet.delegate = self;
		
		for (NSString *title in routeButtons) {
			[actionSheet addButtonWithTitle:title];
		}
		
		actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)];
		
		[actionSheet showInView:self.view];
	}
}


- (IBAction)routePressed:(UIBarButtonItem *)sender
{
    [self buttonRoutePressed];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Óleo Vegetal"
                                                            message:@"Texto Sobre Óleo Vegetal Bem Legal"
                                                           delegate:nil cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
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

@end
