//
//  PriceCalculator.m
//  MoveIt
//
//  Created by Emmiz on 2015-04-19.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "PriceCalculator.h"

@implementation PriceCalculator

+(int)calculatePriceForLivingArea:(int)livingSqM basementArea:(int)basementSqM atticArea:(int)atticSqM kilometers:(int)km includingPiano:(BOOL)piano
{
    PriceCalculator *calculator = [PriceCalculator new];
    int costPerCar = [calculator calculateCostPerCarForDistance:km];
    int storageArea = basementSqM + atticSqM;
    int totalVolume = (storageArea * 2) + livingSqM;
    int totalCost;
    
    int numberOfCars = (totalVolume - (totalVolume % 50)) /50 + 1;
    
    totalCost = (piano) ? costPerCar * numberOfCars + 5000 : costPerCar * numberOfCars;
    
    return totalCost;
}

-(int)calculateCostPerCarForDistance:(int)distance
{
    int costPerCar = 0;
    if (distance < 50) {
        costPerCar = 1000 + (distance * 10);
    } else if (distance >= 50 && distance < 100) {
        costPerCar = 5000 + (distance * 8);
    } else if (distance >= 100) {
        costPerCar = 10000 + (distance * 7);
    }
    return costPerCar;
}

@end
