//
//  AppDelegate.h
//  Magrack-Demo
//
//  Created by Tope on 30/11/2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *rootViewController;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@end
