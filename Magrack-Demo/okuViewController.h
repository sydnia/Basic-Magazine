//
//  okuViewController.h
//  Magrack-Demo
//
//  Created by Volkan UGUR on 10.03.2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface okuViewController : UITableViewController
@property (readwrite, nonatomic, strong) NSArray *URLs;

-(IBAction)oku;

@end
