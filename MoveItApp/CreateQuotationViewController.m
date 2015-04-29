//
//  CreateQuotationViewController.m
//  MoveIt
//
//  Created by Emma Johansson on 24/04/15.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "CreateQuotationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "PriceCalculator.h"
#import "DataHandler.h"
#import "QuotationViewController.h"
#import "LogInViewController.h"

@interface CreateQuotationViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *pianoSwith;
@property (weak, nonatomic) IBOutlet UITextField *livingAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *atticAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *basementAreaTextField;

@property (weak, nonatomic) IBOutlet UITextField *fromAddressField;
@property (weak, nonatomic) IBOutlet UITextField *toAddressfield;
@property (weak, nonatomic) IBOutlet UIView *fromAddressView;
@property (weak, nonatomic) IBOutlet UIView *toAddressView;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *toAddressLabel;

typedef void (^MyBlock)(CLPlacemark *completionPlacemark);

@end

@implementation CreateQuotationViewController

{
    double distanceInKilometers;
    CLLocation *fromLocation;
    CLLocation *toLocation;
    Address *movingFrom;
    Address *movingTo;
    int prix;
    Quotation *quotation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    
    distanceInKilometers = 0;
    [[DataHandler sharedDatahandler] test];
}

-(void)authenticatedUserToSavedObjects
{
    [self performSegueWithIdentifier:@"toOrdersList" sender:self];
}

- (IBAction)ToListOfSaved:(id)sender
{
    if ([[DataHandler sharedDatahandler] isAuthenlicated]) {
        [self performSegueWithIdentifier:@"toOrdersList" sender:self];
    } else {
        [self performSegueWithIdentifier:@"toLogin" sender:self];
    }
}

- (IBAction)fromButton:(id)sender
{
    NSString *address = [NSString stringWithFormat:@"%@, sverige", self.fromAddressField.text];
    [self searchForAddress:address block:^(CLPlacemark *completionPlacemark) {
        fromLocation = completionPlacemark.location;
        NSString *text;
        NSString *street;
        if (!completionPlacemark.thoroughfare || !completionPlacemark.subThoroughfare) {
            text = [NSString stringWithFormat:@"%@ \n%@ %@", completionPlacemark.name, completionPlacemark.postalCode, completionPlacemark.locality];
            street = completionPlacemark.name;
        } else {
            text = [NSString stringWithFormat:@"%@ %@ \n%@ %@", completionPlacemark.thoroughfare, completionPlacemark.subThoroughfare, completionPlacemark.postalCode, completionPlacemark.locality];
            street = [NSString stringWithFormat:@"%@ %@", completionPlacemark.thoroughfare, completionPlacemark.subThoroughfare];
        }
        
        movingFrom = [[DataHandler sharedDatahandler] createAddressWithStreet:street postalCode:completionPlacemark.postalCode city:completionPlacemark.locality longitude:fromLocation.coordinate.longitude andLatitude:fromLocation.coordinate.latitude];
        
        self.fromAddressView.hidden = NO;
        self.fromAddressLabel.text = text;
    }];
}

- (IBAction)toButton:(id)sender
{
    NSString *address = [NSString stringWithFormat:@"%@, sweden", self.toAddressfield.text];
    [self searchForAddress:address block:^(CLPlacemark *completionPlacemark) {
        toLocation = completionPlacemark.location;
        self.toAddressLabel.text = self.toAddressfield.text;
        NSString *text;
        NSString *street;
        if (!completionPlacemark.thoroughfare || !completionPlacemark.subThoroughfare) {
            text = [NSString stringWithFormat:@"%@ \n%@ %@", completionPlacemark.name, completionPlacemark.postalCode, completionPlacemark.locality];
            street = completionPlacemark.name;
        } else {
            text = [NSString stringWithFormat:@"%@ %@ \n%@ %@", completionPlacemark.thoroughfare, completionPlacemark.subThoroughfare, completionPlacemark.postalCode, completionPlacemark.locality];
            street = [NSString stringWithFormat:@"%@ %@", completionPlacemark.thoroughfare, completionPlacemark.subThoroughfare];
        }
        movingTo = [[DataHandler sharedDatahandler] createAddressWithStreet:street postalCode:completionPlacemark.postalCode city:completionPlacemark.locality longitude:toLocation.coordinate.longitude andLatitude:toLocation.coordinate.latitude];
        
        self.toAddressLabel.text = text;
        [self.toAddressView setHidden:NO];
    }];
}

- (IBAction)okButtonPressed:(id)sender
{
    if (fromLocation && toLocation) {
        double distance = [fromLocation distanceFromLocation:toLocation];
        distanceInKilometers = distance/1000;
    }
    
    NSLog(@"Distance %f", distanceInKilometers);
    if ([self.livingAreaTextField.text intValue]) {
        prix = [PriceCalculator calculatePriceForLivingArea:[self.livingAreaTextField.text intValue] basementArea:[self.basementAreaTextField.text intValue] atticArea:[self.basementAreaTextField.text intValue] kilometers:distanceInKilometers includingPiano:self.pianoSwith.on];
        NSLog(@"Price %d", prix);
        quotation = [[DataHandler sharedDatahandler] createQuotationWithPrice:prix livingArea:[self.livingAreaTextField.text intValue] storageArea:[self.basementAreaTextField.text intValue] + [self.basementAreaTextField.text intValue] fromAddress:movingFrom toAddress:movingTo distance:distanceInKilometers piano:self.pianoSwith.on];
        [self performSegueWithIdentifier:@"toQuotation" sender:self];
    } else {
        //alert must have some area...
    }
}

-(void)searchForAddress:(NSString*)address block:(MyBlock)block
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0 && placemarks.count < 2) {
            CLPlacemark *placemark = [placemarks firstObject];
            block(placemark);
            NSLog(@"En matchande adresss: %@ %@ %@, %@ %@", placemark.name, placemark.thoroughfare, placemark.subThoroughfare, placemark.postalCode, placemark.locality);
        } else if (placemarks.count >= 2) {
            NSLog(@"Flera matchande adresser: %lu, %@", [placemarks count], placemarks);
        } else {
            NSLog(@"Error %@", error);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toQuotation"]) {
        QuotationViewController *quotationView = (QuotationViewController*)segue.destinationViewController;
        quotationView.quotation = quotation;
    } else if ([segue.identifier isEqualToString:@"toLogin"]) {
        LogInViewController * login = (LogInViewController*)[segue destinationViewController];
        login.sourceViewController = self;
    }
}

@end
