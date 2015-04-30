//
//  ShowSavedViewController.m
//  MoveItApp
//
//  Created by Emmiz on 2015-04-30.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "ShowSavedViewController.h"
#import "Quotation.h"
#import "Order.h"
#import "Address.h"

@interface ShowSavedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromAddressField;
@property (weak, nonatomic) IBOutlet UILabel *toAddressField;
@property (weak, nonatomic) IBOutlet UILabel *distanceField;
@property (weak, nonatomic) IBOutlet UILabel *areasField;
@property (weak, nonatomic) IBOutlet UILabel *pianoField;
@end

@implementation ShowSavedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setInformationValues];
}

-(void)setInformationValues
{
    Quotation *quotation;
    if ([self.objectToShow isKindOfClass:[Quotation class]]) {
        quotation = (Quotation*)self.objectToShow;
        _info.text = @"Sparat prisförslag";
    } else if ([self.objectToShow isKindOfClass:[Order class]]){
        quotation = (Quotation*)[(Order*)self.objectToShow quotation];
        _info.text = @"Beställd flytt enligt prisförslag";
    }
    
    _fromAddressField.text = [NSString stringWithFormat:@"Från %@, %@ %@", quotation.fromAddress.streetAddress, quotation.fromAddress.postalCode, quotation.fromAddress.city];
    _toAddressField.text = [NSString stringWithFormat:@"Till %@, %@ %@", quotation.toAddress.streetAddress, quotation.toAddress.postalCode, quotation.toAddress.city];
    _distanceField.text = [NSString stringWithFormat:@"Vi beräknar att körsträckan är %.01fkm", [quotation.distance doubleValue]];
    _areasField.text = [NSString stringWithFormat:@"Din boendeyta %@kvm + förvaring %@kvm", quotation.livingArea , quotation.storageArea];
    _pianoField.text = [quotation.piano boolValue] ? @"Pianoflytt inkluderad" : @"Ej pianoflytt";
    _priceLabel.text = [NSString stringWithFormat:@"%@ kr", [quotation.price stringValue]];
}

@end
