//
//  OrdersTableViewController.m
//  MoveIt
//
//  Created by Emma Johansson on 24/04/15.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "OrdersTableViewController.h"
#import "DataHandler.h"

@interface OrdersTableViewController ()


@end

@implementation OrdersTableViewController
{
    NSArray *mySaved;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"*** %lu %@",[mySaved count], [x class]);
    NSString *class = [NSString stringWithFormat:@"%@", [x class]];
    cell.textLabel.text = class;
    if ([x isKindOfClass:[Quotation class]]) {
        Quotation *q = (Quotation*)x;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", q.price];
    } else {
        Order *o = (Order*)x;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", o.quotation.price];
    }
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
