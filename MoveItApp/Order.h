//
//  Order.h
//  MoveItApp
//
//  Created by Emmiz on 2015-04-28.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject, Quotation;

@interface Order : NSManagedObject

@property (nonatomic, retain) NSManagedObject *user;
@property (nonatomic, retain) Quotation *quotation;

@end
