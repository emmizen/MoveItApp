//
//  Address.h
//  MoveItApp
//
//  Created by Emmiz on 2015-04-27.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * streetAddress;

@end
