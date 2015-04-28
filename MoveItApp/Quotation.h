//
//  Quotation.h
//  MoveItApp
//
//  Created by Emmiz on 2015-04-27.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, Customer;

@interface Quotation : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * livingArea;
@property (nonatomic, retain) NSNumber * piano;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * storageArea;
@property (nonatomic, retain) Customer *customer;
@property (nonatomic, retain) Address *fromAddress;
@property (nonatomic, retain) Address *toAddress;

@end
