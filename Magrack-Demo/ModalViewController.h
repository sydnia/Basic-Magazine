//
//  ModalViewController.h
//  Magrack-Demo
//
//  Created by VOLKAN UGUR on 24/01/2013.
//  Copyright (c) 2012 SYDNIA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRPConnection.h"
#import "ARCMacro.h"

@class YLProgressBar;
@interface ModalViewController : UIViewController{


IBOutlet UIButton *albutton;
IBOutlet UIButton *okubutton;
IBOutlet UIButton *silbutton;
IBOutlet UIImageView *resimpencere;
    IBOutlet UIImageView *cover;

    IBOutlet UINavigationBar *kont1;
    IBOutlet UIProgressView *progressview;
    
    
    
}
//@property (nonatomic, SAFE_ARC_PROP_RETAIN) IBOutlet YLProgressBar* progressView;
//@property (nonatomic, retain) UIProgressView *progressview;
//@property (nonatomic, retain) UIProgressView *progressview;
@property (nonatomic, retain) PRPConnection *download;
@property (readwrite, nonatomic, strong) NSArray *URLs;


#pragma mark Constructors - Initializers

#pragma mark Public Methods

-(IBAction)openpdf;
-(IBAction)resimdegistir:(id)sender;;
-(IBAction)dismiss:(id)sender;
-(IBAction)indir;

@end
