//
//  Order.h
//  MoveItApp
//
//  Created by Emmiz on 2015-04-27.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Customer, Quotation;

@interface Order : NSManagedObject

@property (nonatomic, retain) Customer *customer;
@property (nonatomic, retain) Quotation *quotation;

@end
