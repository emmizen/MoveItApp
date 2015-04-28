//
//  AppDelegate.m
//  MoveItApp
//
//  Created by Emmiz on 2015-04-27.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "AppDelegate.h"
#import "DataHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[DataHandler sharedDatahandler] test];
    
    return YES;
}

@end
