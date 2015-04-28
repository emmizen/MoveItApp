//
//  PriceCalculator.h
//  MoveIt
//
//  Created by Emmiz on 2015-04-19.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceCalculator : NSObject

+(int)calculatePriceForLivingArea:(int)livingSqM basementArea:(int)basementSqM atticArea:(int)atticSqM kilometers:(int)km includingPiano:(BOOL)piano;

@end
