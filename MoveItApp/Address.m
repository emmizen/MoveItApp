//
//  Address.m
//  MoveItApp
//
//  Created by Emmiz on 2015-04-28.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "Address.h"

@implementation Address

@dynamic city;
@dynamic latitude;
@dynamic longitude;
@dynamic postalCode;
@dynamic streetAddress;

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@. Street address: %@. Postal code: %@. City: %@.", [self class], [self streetAddress], [self postalCode], [self city]];
}

@end
