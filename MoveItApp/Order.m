//
//  Order.m
//  MoveItApp
//
//  Created by Emmiz on 2015-04-28.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "Order.h"
#import "Quotation.h"


@implementation Order

@dynamic user;
@dynamic quotation;

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@. With quotation: %@.", [self class], [[self quotation] description]];
}

@end
