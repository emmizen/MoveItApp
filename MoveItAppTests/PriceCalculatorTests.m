//
//  PriceCalculatorTests.m
//  MoveIt
//
//  Created by Emmiz on 2015-04-22.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PriceCalculator.h"

@interface PriceCalculatorTests : XCTestCase

@end

@implementation PriceCalculatorTests
{
    int distance;
    int livingArea;
    int atticArea;
    int basementArea;
    BOOL includingPiano;
}

- (void)testPricePerCar
{
    //Testing price per car changing distance
    livingArea = 20;
    atticArea = 0;
    basementArea = 0;
    includingPiano = NO;
    
    int pricePerCar;
    distance = 0;
    pricePerCar = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(pricePerCar, 1000, @"Price per car should be 1000 with a distance of 0");
    
    distance = 20;
    pricePerCar = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(pricePerCar, 1200, @"Price per car should be 1200 with a distance of 20");
    
    distance = 50;
    pricePerCar = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(pricePerCar, 5400, @"Price per car should be 5400 with a distance of 50");
    
    distance = 75;
    pricePerCar = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(pricePerCar, 5600, @"Price per car should be 5600 with a distance of 75");
    
    distance = 100;
    pricePerCar = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(pricePerCar, 10700, @"Price per car should be 10700 with a distance of 100");
    
    distance = 200;
    pricePerCar = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(pricePerCar, 11400, @"Price per car should be 11400 with a distance of 200");
}

- (void)testPriceIncludingPianoOrNot
{
    //Testing price with or without piano including, all with total area 20 and 10km as distance
    livingArea = 20;
    atticArea = 0;
    basementArea = 0;
    distance = 10;
    
    int totalPrice;
    includingPiano = NO;
    totalPrice = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(totalPrice, 1100, @"Price should be 1100 without piano included (area 20, distance 10)");
    
    includingPiano = YES;
    totalPrice = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(totalPrice, 6100, @"Price should be 6100 with piano included (area 20, distance 10)");
}

- (void)testPriceForDifferentAreas
{
    //Testing price for different areas, all without piano and 10km as distance
    distance = 10;
    includingPiano = NO;
    
    //Test total volume 30
    int totalPrice;
    livingArea = 20;
    atticArea = 0;
    basementArea = 5;
    totalPrice = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(totalPrice, 1100, @"Price should be 1100 (1 car) when volume is 30 in total");
    
    //Test total volume 50
    livingArea = 50;
    atticArea = 0;
    basementArea = 0;
    totalPrice = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(totalPrice, 2200, @"Price should be 2200 (2 cars) when volume is 50 in total");
    
    //Test total volume 90
    livingArea = 50;
    atticArea = 20;
    basementArea = 0;
    totalPrice = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(totalPrice, 2200, @"Price should be 2200 (2 cars) when volume is 90 in total");
    
    //Test total volume 100
    livingArea = 100;
    atticArea = 0;
    basementArea = 0;
    totalPrice = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(totalPrice, 3300, @"Price should be 3300 (3 cars) when volume is 100 in total");
    
    //Test total volume 150
    livingArea = 100;
    atticArea = 25;
    basementArea = 0;
    totalPrice = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(totalPrice, 4400, @"Price should be 4400 (4 cars) when volume is 150 in total");
}

- (void)testWithoutValues
{
    //Putting nothing in gives a minimum price of 1000
    int totalPrice = [PriceCalculator calculatePriceForLivingArea:livingArea basementArea:basementArea atticArea:atticArea kilometers:distance includingPiano:includingPiano];
    XCTAssertEqual(totalPrice, 1000, @"Should be minimum price of 1000 when putting no values in");
    
}

@end
