//
//  AppDelegate.m
//  Magrack-Demo
//
//  Created by Tope on 30/11/2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "AppDelegate.h"
#import "ModalViewController.h"
#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  //  ViewController *nonRotating = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    //[nonRotating release];

    //[self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url isFileURL])
    {
        NSString *theDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        NSURL *theDestinationURL = [[NSURL fileURLWithPath:theDocumentsPath] URLByAppendingPathComponent:[url lastPathComponent]];
        
        NSError *theError = NULL;
        BOOL theResult = [[NSFileManager defaultManager] moveItemAtURL:url toURL:theDestinationURL error:&theError];
        if (theResult == YES)
        {
            NSMutableDictionary *theUserInfo = [NSMutableDictionary dictionary];
            if (theDestinationURL != NULL)
            {
                [theUserInfo setObject:theDestinationURL forKey:@"URL"];
            }
            if (sourceApplication != NULL)
            {
                [theUserInfo setObject:sourceApplication forKey:@"sourceApplication"];
            }
            if (annotation != NULL)
            {
                [theUserInfo setObject:annotation forKey:@"annotation"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidOpenURL" object:application userInfo:theUserInfo];
        }
        
        return(theResult);
    }
    return(NO);
}



@end
