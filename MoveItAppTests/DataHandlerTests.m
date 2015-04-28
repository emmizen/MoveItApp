//
//  DataHandlerTests.m
//  MoveItApp
//
//  Created by Emmiz on 2015-04-27.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DataHandler.h"
#import "Address.h"
#import "Quotation.h"

@interface DataHandlerTests : XCTestCase

@property Address *from;
@property Address *to;
@property Quotation *quotation;

@end

@implementation DataHandlerTests

- (void)setUp {
    [super setUp];
    _from = [[DataHandler sharedDatahandler] createAddressWithStreet:@"vägen 2" postalCode:@"12345" city:@"Åre" longitude:46.234 andLatitude:56.234];
    _to = [[DataHandler sharedDatahandler] createAddressWithStreet:@"gatan 1" postalCode:@"12345" city:@"Orsa" longitude:42.234 andLatitude:26.234];
    _quotation = [[DataHandler sharedDatahandler] createQuotationWithPrice:2000 livingArea:50 storageArea:10 fromAddress:_from toAddress:_to distance:25 piano:NO];
}

- (void)tearDown {
    _from = nil;
    _to = nil;
    _quotation = nil;
    [super tearDown];
}

-(void)testUnAuthorizedUserCreatesQuotation
{
    XCTAssertNotNil(self.quotation, @"Quotation should not be nil");
}

-(void)testUnAuthorizedUserSaveQuotation
{
    [[DataHandler sharedDatahandler] createCustomerWithEmail:@"test@test" password:@"test" name:@"test" phoneNumber:@"9999"];
    [[DataHandler sharedDatahandler] saveQuotation:self.quotation];
    NSArray *array = [[DataHandler sharedDatahandler] savedObjectsForCurrentCustomer];
    XCTAssertTrue([array containsObject:self.quotation], @"Quotation should be saved");
}


@end
