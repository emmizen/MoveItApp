//
//  QuotationViewController.h
//  MoveIt
//
//  Created by Emma Johansson on 24/04/15.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quotation.h"
#import "Order.h"

@interface QuotationViewController : UIViewController

@property (nonatomic) Quotation *quotation;
-(void)authenticatedUserToSavedObjects;
@end
