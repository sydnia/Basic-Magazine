//
//  ArtistView.h
//  Magrack-Demo
//
//  Created by Volkan UGUR on 09.03.2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface ArtistView : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, retain) IBOutlet iCarousel *carousel;

-(IBAction)geribas;

@end
