//
//  ModalViewController.m
//  Magrack-Demo
//
//  Created by Tope on 01/12/2012.
//  Copyright (c) 2012 App Design Vault. All rights reserved.
//

#import "ModalViewController.h"
#import "YLProgressBar.h"
#import "CPDFDocumentViewController.h"
#import "NSFileManager_BugFixExtensions.h"
#import "CPDFDocument.h"
#import "ViewController.h"
@interface ModalViewController ()
- (void)scanDirectories;
@end

@implementation ModalViewController
//@synthesize progressView;
@synthesize URLs = _URLs;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)indir{
    
    progressview.hidden=FALSE;//progress=1.0f;
    progressview.alpha=1.0f;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *selected = [defaults objectForKey:@"SelectedDergiNo"];
    NSString *dergisayisi = [defaults objectForKey:@"MagSay"];
    
    NSInteger *sayino = [dergisayisi intValue]-[selected intValue];
    NSString *downloadstr;
    NSString *selectedNo = [NSString stringWithFormat:@"%d",sayino];
    
    downloadstr = @"http://www.baveco.net/books/togo";
    downloadstr = [downloadstr stringByAppendingString:selectedNo];
    downloadstr = [downloadstr stringByAppendingString:@".pdf"];

    
    NSLog(downloadstr);
    
    NSURL *downloadURL = [NSURL URLWithString:downloadstr];

    
    ///doc8161.pdf"];
    PRPConnectionProgressBlock progress = ^(PRPConnection *connection) {
        progressview.progress = self.download.percentComplete / 100;
        albutton.titleLabel.text = [NSString stringWithFormat:@"indiriliyor. %.0f%%", self.download.percentComplete];
      //  albutton.titleLabel.center =
    };
    
    PRPConnectionCompletionBlock complete = ^(PRPConnection *connection, NSError *error) {
        if (error) {
           progressview.progress = self.download.percentComplete;
            //self.progressLabel.text = @"Failed";
            albutton.enabled=true;
        } else {
            progressview.progress = 0.3f;
        
            albutton.hidden=true;
            
            NSString  *pdfdosya = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/down.pdf"];
            NSString  *pdfdosya2 = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/togo"];
               pdfdosya2 = [pdfdosya2 stringByAppendingString:selectedNo];
               pdfdosya2 = [pdfdosya2 stringByAppendingString:@".pdf"];
            
               NSFileManager *fileMgr = [NSFileManager defaultManager];
               [fileMgr moveItemAtPath:pdfdosya toPath:pdfdosya2 error:nil];
                
            // Show contents of Documents directory
            
            [self oku];
            
     //   albutton.titleLabel.text=@"OKU";
        }
      ///  self.download = nil;
      //  self.downloadButton.enabled = YES;
    };
    
   self.download = [PRPConnection connectionWithURL:downloadURL
                                       progressBlock:progress
                                     completionBlock:complete];
    self.download.progressThreshold = lround(1);
    
    
  //  NSString  *pdfdosya = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/pimser1.pdf"];
 //   pdfdosya = [pdfdosya stringByAppendingString:selectedNo];
  //  pdfdosya = [pdfdosya stringByAppendingString:@".pdf"];
    
  //  NSLog(pdfdosya);
    self.download.dosyaadi=@"down.pdf";
   // sleep(1.0f);
    [self.download start];
    
    
    progressview.progress = 0;
    //self.progressLabel.text = @"0%";
    //self.downloadButton.enabled = NO;
    progressview.progressTintColor = [UIColor greenColor];
    albutton.enabled=FALSE;
    
   // NSLog(@"indir basildi");
    
}

- (void)scanDirectories
{
    NSFileManager *theFileManager = [NSFileManager defaultManager];
    
    
    NSURL *theDocumentsURL = [[theFileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    NSURL *theInboxURL = [theDocumentsURL URLByAppendingPathComponent:@"Inbox"];
    NSError *theError = NULL;
    NSEnumerator *theEnumerator = NULL;
    id theErrorHandler = ^(NSURL *url, NSError *error) { NSLog(@"ERROR: %@", error); return(YES); };
    
    if ([theFileManager fileExistsAtPath:theInboxURL.path])
    {
        for (NSURL *theURL in [theFileManager tx_enumeratorAtURL:theInboxURL includingPropertiesForKeys:NULL options:0 errorHandler:theErrorHandler])
        {
            NSURL *theDestinationURL = [theDocumentsURL URLByAppendingPathComponent:[theURL lastPathComponent]];
            BOOL theResult = [theFileManager moveItemAtURL:theURL toURL:theDestinationURL error:&theError];
            NSLog(@"MOVING: %@ %d %@", theURL, theResult, theError);
        }
    }
    
    NSArray *theAllURLs = [NSArray array];
    NSArray *theURLs = NULL;
    
    NSURL *theBundleURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:@"Samples"];
    theBundleURL = [theBundleURL URLByStandardizingPath];
    theEnumerator = [theFileManager tx_enumeratorAtURL:theBundleURL includingPropertiesForKeys:NULL options:0 errorHandler:theErrorHandler];
    theURLs = [theEnumerator allObjects];
    theAllURLs = [theAllURLs arrayByAddingObjectsFromArray:theURLs];
    
    theEnumerator = [theFileManager tx_enumeratorAtURL:theDocumentsURL includingPropertiesForKeys:NULL options:0 errorHandler:theErrorHandler];
    theURLs = [theEnumerator allObjects];
    theAllURLs = [theAllURLs arrayByAddingObjectsFromArray:theURLs];
    
    
    theAllURLs = [theAllURLs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"lastPathComponent LIKE '*.pdf'"]];
    
    theAllURLs = [theAllURLs filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        //        return(YES);
        return ([[NSFileManager defaultManager] fileExistsAtPath:[evaluatedObject path]]);
    }]];
    
    theAllURLs = [theAllURLs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return([[obj1 lastPathComponent] compare:[obj2 lastPathComponent]]);
    }];
    
    self.URLs = theAllURLs;
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //  [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    [super viewDidLoad];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [self scanDirectories];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *selected = [defaults objectForKey:@"SelectedDergiNo"];
    NSString *dergisayisi = [defaults objectForKey:@"MagSay"];
    
    NSInteger *sayino = [dergisayisi intValue]-[selected intValue];
    NSString  *sayistr = [NSString stringWithFormat:@"%d",sayino];
    
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cover"];
    jpgPath = [jpgPath stringByAppendingString:sayistr];
    jpgPath = [jpgPath stringByAppendingString:@".png"];
    
    
    cover.image = [UIImage imageWithContentsOfFile:jpgPath];
    NSString  *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/togo"];
    
    
    NSString* Dergi = documentsPath;// stringByAppendingPathComponent:@"/"];
    Dergi = [Dergi stringByAppendingString:[NSString stringWithFormat:@"%d", sayino]];
    Dergi = [Dergi stringByAppendingString:@".pdf"];
    BOOL dergidurumu = [[NSFileManager defaultManager] fileExistsAtPath:Dergi];
    
    
    if(dergidurumu){[self oku];}else{[self down];}
    
 //   [navigationController pushViewController:viewController animated:NO];
//    [viewController release];
    
  //  UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)dismiss:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(IBAction)resimdegistir:(id)sender{

    UISegmentedControl *seg = (UISegmentedControl*)sender;
    NSString *SelectedTab = [NSString stringWithFormat:@"%d", seg.selectedSegmentIndex];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *SelectedNo = [defaults objectForKey:@"SelectedDergiNo"];
    NSString *link = @"http://www.baveco.net/bookimages/img";
    link = [link stringByAppendingString:SelectedNo];
    link = [link stringByAppendingString:SelectedTab];
    link = [link stringByAppendingString:@".jpg"];

    NSURL *imgresim =[NSURL URLWithString:link];

    UIImage * img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imgresim]];
  //  NSLog(SelectedNo);
    resimpencere.image=img;
    

}




-(void)openpdf{
  
        [self scanDirectories];
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *resimyolu;//=@"file:/";
    resimyolu =[resimyolu stringByAppendingString:path];
    resimyolu = [resimyolu stringByAppendingString:@"/1"];
    resimyolu = [resimyolu stringByAppendingString:@".pdf"];
    
   // NSURL *imgresim =[NSURL fileURLWithPath:resimyolu];//[NSURL URLWithString:resimyolu];
  
    
    //self.title=@"123456";
      
  //  [self.navigationController pushViewController:theViewController animated:YES];
   // self.navigationItem.rightBarButtonItem = self.editButtonItem;
   // self.view=theViewController.view;
  //  NSArray *theURLs = NULL;
    
  //  theURLs=imgresim;
 //   NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:resimyolu];
//    NSURL *fileURL = [NSURL fileURLWithPath:resimyolu];

   // NSString *dev;

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *selected = [defaults objectForKey:@"SelectedDergiNo"];
    NSString *dergisayisi = [defaults objectForKey:@"MagSay"];
    
    NSInteger *sayino = [dergisayisi intValue]-[selected intValue];

    
    
    NSString *filter=@"lastPathComponent LIKE '";
    //filter = [filter stringByAppendingString: [NSString stringWithFormat:@"%d",1] ];
    filter = [filter stringByAppendingString:[NSString stringWithFormat:@"togo%d.pdf'",sayino]];
    
    self.URLs = [self.URLs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:filter]]; //@"lastPathComponent LIKE '.pdf'"]];
    
    
    
    NSURL *theURL = [self.URLs objectAtIndex:0];
    //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //  self.URLs = imgresim;// NSLog(resimyolu);

  CPDFDocumentViewController *theViewController = [[ CPDFDocumentViewController alloc] initWithURL:theURL];

//[self.navigationController pushViewController:theViewController animated:YES];


    //self.navigationController=
  //  [self performSegueWithIdentifier:@"pdf" sender:self];

    [self presentModalViewController:theViewController animated:YES];
    //[self.navigationController pushViewController:theViewController animated:YES];

    
 //   NSLog(@"nav controller = %@", self.navigationController);
    //[kont1 pushNavigat:theViewController animated:YES];
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    CGSize viewSize = self.view.bounds.size;
    
    
    
    resimpencere.center = CGPointMake(viewSize.width/2, viewSize.height/2);
  ///  NSLog(@"dondu");

}

-(void)oku{

    okubutton.hidden=false;
    silbutton.hidden=false;
    albutton.hidden=true;




}-(void)down{
    
    okubutton.hidden=true;
    silbutton.hidden=true;
    albutton.hidden=false;
    
    
    
    
}

@end
