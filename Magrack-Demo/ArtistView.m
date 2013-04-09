//
//  ArtistView.m
//  Magrack-Demo
//
//  Created by Volkan UGUR on 09.03.2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "ArtistView.h"
#import "Repository.h"
#import "ModalViewController.h"
#import "ReflectionView.h"

@interface ArtistView ()

@property (nonatomic, retain) NSMutableArray *items;
@end

@implementation ArtistView


@synthesize carousel;
@synthesize items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    carousel.type = iCarouselTypeInvertedTimeMachine;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    //set up data
    //your carousel should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
//    self.items = [NSMutableArray array];
 //   for (int i = 0; i < 10; i++)
 //   {
  //      [items addObject:[NSNumber numberWithInt:i]];
        // [items addObject:];
  //  }
}


- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *items = [defaults objectForKey:@"MagSay"];
    
    
    return [items intValue];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(ReflectionView *)view

{
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *items = [defaults objectForKey:@"MagSay"];
    
NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cover"];
jpgPath = [jpgPath stringByAppendingString:[NSString stringWithFormat:@"%d",[items intValue]-index]];
jpgPath = [jpgPath stringByAppendingString:@".png"];
        
        
        
		//no button available to recycle, so create new one
		UIImage *image = [UIImage imageWithContentsOfFile:jpgPath];
        
view = [[ReflectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height+3.0f)];
    

    UIButton *button = (UIButton *)view;
    
   // NSDictionary *item = [Repository dataIPad][index];
     	//if (button == nil)
	    button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0f, 0.0f, image.size.width-10, image.size.height-10);
		
        [button setBackgroundImage:image forState:UIControlStateNormal];
		[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        //	}
	
	//set button label
//	[button setTitle:[NSString stringWithFormat:@"%i", index] forState:UIControlStateNormal];
	    [view update];
	return view;
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
	NSInteger index = [carousel indexOfItemViewOrSubview:sender];
	
    NSString *string = [NSString stringWithFormat:@"%d", index];
    //   NSLog(  string);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:@"SelectedDergiNo"];
    
    [self performSegueWithIdentifier:@"detailart" sender:self];

}


-(void)geribas{

    [self dismissViewControllerAnimated:YES completion:nil];

}



@end
