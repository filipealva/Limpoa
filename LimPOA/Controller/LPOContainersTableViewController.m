//
//  LPOContainersTableViewController.m
//  LimPOA
//
//  Created by Filipe Alvarenga on 5/14/14.
//  Copyright (c) 2014 Filipe Alvarenga. All rights reserved.
//

#import "LPOContainersTableViewController.h"

@interface LPOContainersTableViewController ()

@property (nonatomic, strong) NSMutableArray *containers;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation LPOContainersTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Lazy Instantiation

- (NSManagedObjectContext *)context
{
    if (!_context) {
        _context = [(LPOAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    return _context;
}

- (NSMutableArray *)containers
{
    if (!_containers) {
        _containers = [[NSMutableArray alloc] initWithArray:[self updateDumpList]];
    }
    
    return _containers;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.containers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContainerCell" forIndexPath:indexPath];
    
    Container *container = (Container *)[self.containers objectAtIndex:indexPath.row];
    
    NSLog(@"%@", container);
    
    UILabel *containerAddress = (UILabel *)[cell viewWithTag:100];
    UILabel *distanceToContainer = (UILabel *)[cell viewWithTag:200];
    
    containerAddress.text = container.address;
    distanceToContainer.text = @"0.2km";
    
    return cell;
}

#pragma mark - CoreData

- (NSMutableArray *)updateDumpList
{
    NSError *error;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Container" inManagedObjectContext:self.context];
	[fetchRequest setEntity:entity];
    
    NSMutableArray *containersArray = [[NSMutableArray alloc] init];
    
	NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (Container *container in fetchedObjects) {
        [containersArray addObject:container];
    }
    
    if (!error) {
        NSLog(@"OK!");
    } else {
        NSLog(@"ERRO!");
    }
    
    return containersArray;
}

@end
