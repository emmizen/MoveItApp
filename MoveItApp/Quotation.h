//
//  Quotation.h
//  MoveItApp
//
//  Created by Emmiz on 2015-04-28.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Address, NSManagedObject;

@interface Quotation : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * livingArea;
@property (nonatomic, retain) NSNumber * piano;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * storageArea;
@property (nonatomic, retain) NSManagedObject *user;
@property (nonatomic, retain) Address *fromAddress;
@property (nonatomic, retain) Address *toAddress;

@end
