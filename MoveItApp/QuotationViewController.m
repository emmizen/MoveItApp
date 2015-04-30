//
//  QuotationViewController.m
//  MoveIt
//
//  Created by Emma Johansson on 24/04/15.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "QuotationViewController.h"
#import "DataHandler.h"
#import "LogInViewController.h"
typedef enum{
    save,order, noState}
buttonState;

@interface QuotationViewController ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressField;
@property (weak, nonatomic) IBOutlet UILabel *toAddressField;
@property (weak, nonatomic) IBOutlet UILabel *distanceField;
@property (weak, nonatomic) IBOutlet UILabel *areasField;
@property (weak, nonatomic) IBOutlet UILabel *pianoField;

@property (nonatomic) buttonState buttonstate;

@end

@implementation QuotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //Uncomment to log path where to find coreData objets in local sql
    // NSLog(@"app dir: %@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    self.buttonstate = noState;
    [self showQuotationInfo];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)showQuotationInfo
{
    _fromAddressField.text = [NSString stringWithFormat:@"Från %@, %@ %@", self.quotation.fromAddress.streetAddress, self.quotation.fromAddress.postalCode, self.quotation.fromAddress.city];
    _toAddressField.text = [NSString stringWithFormat:@"Till %@, %@ %@", self.quotation.toAddress.streetAddress, self.quotation.toAddress.postalCode, self.quotation.toAddress.city];
    _distanceField.text = [NSString stringWithFormat:@"Vi beräknar att körsträckan är %.01fkm", [self.quotation.distance doubleValue]];
    _areasField.text = [NSString stringWithFormat:@"Din boendeyta %@kvm + förvaring %@kvm", self.quotation.livingArea , self.quotation.storageArea];
    _pianoField.text = [self.quotation.piano boolValue] ? @"Pianoflytt inkluderad" : @"Ej pianoflytt";
    _priceLabel.text = [NSString stringWithFormat:@"%@ kr", [self.quotation.price stringValue]];
    
}

- (IBAction)saveButtonTapped:(id)sender
{
    if ([[DataHandler sharedDatahandler] isAuthenlicated]) {
        [[DataHandler sharedDatahandler] saveQuotation:self.quotation];
        [self performSegueWithIdentifier:@"quotationToList" sender:self];
    } else {
        self.buttonstate = save;
        [self performSegueWithIdentifier:@"quotationToLogin" sender:self];
    }
}

- (IBAction)orderButtonTapped:(id)sender
{
    if ([[DataHandler sharedDatahandler] isAuthenlicated]) {
        [[DataHandler sharedDatahandler] createOrderWithQuotation:self.quotation];
        [self performSegueWithIdentifier:@"quotationToList" sender:self];
    } else {
        self.buttonstate = order;
        [self performSegueWithIdentifier:@"quotationToLogin" sender:self];
    }
}

-(void)authenticatedUserToSavedObjects
{
    //if successfully created order or saved, show allert and after that go to list
    switch (self.buttonstate) {
        case save:
             [[DataHandler sharedDatahandler] saveQuotation:self.quotation];
            break;
        case order:
            [[DataHandler sharedDatahandler] createOrderWithQuotation:self.quotation];
            break;
        default:
            break;
    }
    [self performSegueWithIdentifier:@"quotationToList" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqualToString:@"quotationToLogin"]) {
        LogInViewController *login = (LogInViewController*)[segue destinationViewController];
        login.sourceViewController = self;
    }
}


@end
