//
//  OrdersTableViewController.m
//  MoveIt
//
//  Created by Emma Johansson on 24/04/15.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "OrdersTableViewController.h"
#import "DataHandler.h"
#import "ShowSavedViewController.h"

@implementation OrdersTableViewController
{
    NSArray *mySaved;
    id selectedObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFromDataHandler) name:@"update" object:nil];
    mySaved = [[DataHandler sharedDatahandler] savedObjectsForCurrentUser];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutButtonTapped:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
}

-(void)updateFromDataHandler
{
    mySaved = [[DataHandler sharedDatahandler] savedObjectsForCurrentUser];
    [self.tableView reloadData];
}

-(void)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"fromListToCreate" sender:self];
}

-(void)logoutButtonTapped:(id)sender
{
    [[DataHandler sharedDatahandler] logOut];
    [self performSegueWithIdentifier:@"fromListToCreate" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mySaved count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    id x = [mySaved objectAtIndex:indexPath.row];
    
    if ([x isKindOfClass:[Quotation class]]) {
        Quotation *q = (Quotation*)x;
        cell.textLabel.text = @"Sparat prisförslag";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ kr", q.price];
    } else {
        Order *o = (Order*)x;
        cell.textLabel.text = @"Beställd flytt";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ kr", o.quotation.price];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedObject = [mySaved objectAtIndex:indexPath.row];
    //Uncomment to log tapped object
    //NSLog(@"Tapped: %@", [selectedObject description]);
    [self performSegueWithIdentifier:@"showSaved" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[ShowSavedViewController class]]) {
        ShowSavedViewController *viewController = (ShowSavedViewController*)segue.destinationViewController;
        viewController.objectToShow = selectedObject;
    }
}

@end
