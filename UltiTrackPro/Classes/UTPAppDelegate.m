//
//  UTPAppDelegate.m
//  UltiTrackPro
//
//  Created by James Montgomery on 7/17/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "UTPAppDelegate.h"
#import "Controllers/ProgramsTableViewController.h"
#import "DataHelper.h"
#import "Flurry.h"

@implementation UTPAppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
    UINavigationController *nvc = [[tbc viewControllers] objectAtIndex:0];
    ProgramsTableViewController *pvc = (ProgramsTableViewController *)nvc.topViewController;
    pvc.tableDataSource = [[DataHelper sharedManager] programsList];

    //get rid of the historytabbar for now
    NSMutableArray *tabBarVCs = [NSMutableArray arrayWithArray:tbc.viewControllers];
    [tabBarVCs removeObjectAtIndex:1];
    [tbc setViewControllers:tabBarVCs];
    
    //Start the Analytics
    [Flurry startSession:@"62BK2CFXDWHGVVVPJW3J"];

    return YES;
}


- (void) applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void) applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void) applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void) applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void) applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
