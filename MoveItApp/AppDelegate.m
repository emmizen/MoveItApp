//
//  AppDelegate.m
//  MoveItApp
//
//  Created by Emmiz on 2015-04-27.
//  Copyright (c) 2015 EmmaJohansson. All rights reserved.
//

#import "AppDelegate.h"
#import "A0SimpleKeychain.h"
#import "DataHandler.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [Parse setApplicationId:@"t1wYmUA9wOfzsQdOAJZRi15BEMSDbCflGuM7injA"
        clientKey:@"vIY1ZSZ3tIETU1zkSiXiSyCLbo5WnOLkNAnX26qL"];
    
    UIViewController *viewController = [self viewControllerForAuthenticatedOrNot];
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
 
    return YES;
}

-(UIViewController*)viewControllerForAuthenticatedOrNot
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *viewController;
    
    if ([[A0SimpleKeychain keychain] stringForKey:@"password"] && [[DataHandler sharedDatahandler] savedObjectsForCurrentUser]) {
        UIViewController *root = [storyboard instantiateViewControllerWithIdentifier:@"list"];
        viewController = [[UINavigationController alloc] initWithRootViewController:root];
    } else {
        viewController = [storyboard instantiateInitialViewController];
    }
    return viewController;
}

@end
