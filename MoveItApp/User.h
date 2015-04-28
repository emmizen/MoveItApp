//
//  User.h
//  MoveItApp
//
//  Created by Emmiz on 2015-04-28.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Order, Quotation;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * eMail;
@property (nonatomic, retain) NSSet *orders;
@property (nonatomic, retain) NSSet *quotations;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addOrdersObject:(Order *)value;
- (void)removeOrdersObject:(Order *)value;
- (void)addOrders:(NSSet *)values;
- (void)removeOrders:(NSSet *)values;

- (void)addQuotationsObject:(Quotation *)value;
- (void)removeQuotationsObject:(Quotation *)value;
- (void)addQuotations:(NSSet *)values;
- (void)removeQuotations:(NSSet *)values;

@end
