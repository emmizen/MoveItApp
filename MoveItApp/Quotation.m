//
//  Quotation.m
//  MoveItApp
//
//  Created by Emmiz on 2015-04-28.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "Quotation.h"
#import "Address.h"

@implementation Quotation

@dynamic distance;
@dynamic livingArea;
@dynamic piano;
@dynamic price;
@dynamic storageArea;
@dynamic user;
@dynamic fromAddress;
@dynamic toAddress;

-(NSString *)description
{
    NSString *inclPiano = [[self piano] boolValue] ? @"Including piano": @"Not including piano";
    return [NSString stringWithFormat:@"%@. From address: %@. To address: %@. Distance: %.1f. LivingArea: %@. StorageArea: %@. %@. price: %@", [self class], [[self fromAddress] description], [[self toAddress] description], [[self distance] doubleValue], [self livingArea], [self storageArea], inclPiano, [self price]];
}

@end
