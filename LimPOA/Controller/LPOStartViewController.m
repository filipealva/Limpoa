//
//  LPOStartViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/14/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOStartViewController.h"

@interface LPOStartViewController ()

- (IBAction)startButtonWasPressed:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activityIndicatorYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonStartYConstraint;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPOStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.activityIndicator.alpha = 0;
    
    self.backgroundImage.image = [UIImage imageNamed:self.imageFile];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.buttonStartYConstraint.constant = self.view.bounds.size.height == 568 ? 60.0 : 40.0;
    self.activityIndicatorYConstraint.constant = self.view.bounds.size.height == 568 ? 75.0 : 55.0;
}

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

- (IBAction)startButtonWasPressed:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.activityIndicator.alpha = 1;
    }];
    
    [self.activityIndicator startAnimating];
    
    [self performSelector:@selector(loadAllData) withObject:nil afterDelay:.1];
}

#pragma mark - Load data

- (void)loadAllData
{
    [self loadDumpsData];
    [self loadContainersData];
    [self loadCookingOilsData];
    [self loadEcoPointsData];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadDumpsData
{
    NSCharacterSet *commaSet;
    commaSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Dump" ofType:@"txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding  error:&error];
    
    
    NSArray *dataFileLines = [dataFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i <= dataFileLines.count - 1; i++) {
        Dump *dump = (Dump *)[NSEntityDescription insertNewObjectForEntityForName:@"Dump" inManagedObjectContext:self.context];
        
        NSArray *fields = [dataFileLines[i] componentsSeparatedByCharactersInSet:commaSet];
        NSString *address;
        NSString *latitudeMaker;
        NSString *longitudeMaker;
        
        NSNumber *latitude;
        NSNumber *longitude;
        
        if (fields.count == 4) {
            address = [NSString stringWithFormat:@"%@, %@", fields[0], fields[1]];
            latitudeMaker = [NSString stringWithFormat:@"%@", fields[2]];
            longitudeMaker = [NSString stringWithFormat:@"%@",fields[3]];
            
            latitude = [NSNumber numberWithDouble:[latitudeMaker doubleValue]];
            longitude = [NSNumber numberWithDouble:[longitudeMaker doubleValue]];
        } else {
            address = [NSString stringWithFormat:@"%@", fields[0]];
            latitudeMaker = [NSString stringWithFormat:@"%@", fields[1]];
            longitudeMaker = [NSString stringWithFormat:@"%@",fields[2]];
            
            latitude = [NSNumber numberWithDouble:[latitudeMaker doubleValue]];
            longitude = [NSNumber numberWithDouble:[longitudeMaker doubleValue]];
        }
        
        dump.address = address;
        dump.latitude = latitude;
        dump.longitude = longitude;
        
        [self.context save:&error];
    }
}

- (void)loadContainersData
{
    NSCharacterSet *commaSet;
    commaSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Container" ofType:@"txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding  error:&error];
    
    
    NSArray *dataFileLines = [dataFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i <= dataFileLines.count - 1; i++) {
        Container *container = (Container *)[NSEntityDescription insertNewObjectForEntityForName:@"Container" inManagedObjectContext:self.context];
        
        NSArray *fields = [dataFileLines[i] componentsSeparatedByCharactersInSet:commaSet];
        NSString *address;
        NSString *latitudeMaker;
        NSString *longitudeMaker;
        
        NSNumber *latitude;
        NSNumber *longitude;
        
        if (fields.count == 4) {
            address = [NSString stringWithFormat:@"%@, %@", fields[0], fields[1]];
            latitudeMaker = [NSString stringWithFormat:@"%@", fields[2]];
            longitudeMaker = [NSString stringWithFormat:@"%@",fields[3]];
            
            latitude = [NSNumber numberWithDouble:[latitudeMaker doubleValue]];
            longitude = [NSNumber numberWithDouble:[longitudeMaker doubleValue]];
        } else {
            address = [NSString stringWithFormat:@"%@", fields[0]];
            latitudeMaker = [NSString stringWithFormat:@"%@", fields[1]];
            longitudeMaker = [NSString stringWithFormat:@"%@",fields[2]];
            
            latitude = [NSNumber numberWithDouble:[latitudeMaker doubleValue]];
            longitude = [NSNumber numberWithDouble:[longitudeMaker doubleValue]];
        }
        
        container.address = address;
        container.latitude = latitude;
        container.longitude = longitude;
        
        [self.context save:&error];
    }
}

- (void)loadCookingOilsData
{
    NSCharacterSet *commaSet;
    commaSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CookingOil" ofType:@"txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding  error:&error];
    
    
    NSArray *dataFileLines = [dataFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i <= dataFileLines.count - 1; i++) {
        CookingOil *cookingOil = (CookingOil *)[NSEntityDescription insertNewObjectForEntityForName:@"CookingOil" inManagedObjectContext:self.context];
        
        NSArray *fields = [dataFileLines[i] componentsSeparatedByCharactersInSet:commaSet];
        NSLog(@"%d", (int)fields.count);
        
        NSString *name = nil;
        NSString *openHours = nil;
        NSString *address = nil;
        NSString *telephone = nil;
        NSString *latitudeMaker;
        NSString *longitudeMaker;
        NSNumber *latitude;
        NSNumber *longitude;
        
        
        name = [NSString stringWithFormat:@"%@", fields[0]];
        
        if (![fields[2] isEqualToString:@" "]) {
            address = [NSString stringWithFormat:@"%@, %@", fields[1], fields[2]];
        } else {
            address = [NSString stringWithFormat:@"%@", fields[1]];
        }
        
        if (![fields[3] isEqualToString:@" "]) {
            telephone = [NSString stringWithFormat:@"%@", fields[3]];
        }
        
        if (![fields[4] isEqualToString:@" "]) {
            openHours = [NSString stringWithFormat:@"%@", fields[4]];
        }
        
        latitudeMaker = [NSString stringWithFormat:@"%@", fields[5]];
        longitudeMaker = [NSString stringWithFormat:@"%@",fields[6]];
        
        latitude = [NSNumber numberWithDouble:[latitudeMaker doubleValue]];
        longitude = [NSNumber numberWithDouble:[longitudeMaker doubleValue]];
        
        
        cookingOil.name = name;
        cookingOil.openHours = openHours;
        cookingOil.address = address;
        cookingOil.telephone = telephone;
        cookingOil.latitude = latitude;
        cookingOil.longitude = longitude;
        
        [self.context save:&error];
    }
}

- (void)loadEcoPointsData
{
    NSCharacterSet *commaSet;
    commaSet = [NSCharacterSet characterSetWithCharactersInString:@","];
    
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EcoPoint" ofType:@"txt"];
    NSString *dataFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding  error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    }
    
    NSArray *dataFileLines = [dataFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i <= dataFileLines.count - 1; i++) {
        EcoPoint *ecoPoint = (EcoPoint *)[NSEntityDescription insertNewObjectForEntityForName:@"EcoPoint" inManagedObjectContext:self.context];
        
        NSArray *fields = [dataFileLines[i] componentsSeparatedByCharactersInSet:commaSet];
        
        NSString *neighborhood = nil;
        NSString *address = nil;
        NSString *telephone = nil;
        NSString *latitudeMaker;
        NSString *longitudeMaker;
        NSNumber *latitude;
        NSNumber *longitude;
        
        
        neighborhood = [NSString stringWithFormat:@"%@", fields[2]];
        address = [NSString stringWithFormat:@"%@, %@", fields[0], fields[1]];
        
        if (![fields[3] isEqualToString:@" "]) {
            telephone = [NSString stringWithFormat:@"%@", fields[3]];
        }
        
        
        latitudeMaker = [NSString stringWithFormat:@"%@", fields[4]];
        longitudeMaker = [NSString stringWithFormat:@"%@",fields[5]];
        
        latitude = [NSNumber numberWithDouble:[latitudeMaker doubleValue]];
        longitude = [NSNumber numberWithDouble:[longitudeMaker doubleValue]];
        
        
        ecoPoint.neighborhood = neighborhood;
        ecoPoint.address = address;
        ecoPoint.telephone = telephone;
        ecoPoint.latitude = latitude;
        ecoPoint.longitude = longitude;
        
        [self.context save:&error];
    }
}

@end
