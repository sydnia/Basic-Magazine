//
//  ViewController.m
//  Magrack-Demo
//
//  Created by VOLKAN UGUR on 24/01/2013.
//  Copyright (c) 2012 SYDNIA. All rights reserved.
//

#import "ViewController.h"
//#import "Repository.h"
#import "MagazineCell.h"
#import "Reachability.h"
#import "ModalViewController.h"
#import "ODRefreshControl.h"


@interface ViewController ()

@end
NSInteger DERGISAYISI = 0;
NSArray *itemArray;
Boolean *checkconn;
@implementation ViewController


- (NSString *) getPath

{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:@"TOGO.dat"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else
    {
        return NO;
    }
}
- (void)viewDidLoad
{
    
    
    CGSize viewSize = self.view.bounds.size;
    
   // UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
    //[backgroundView setFrame:CGRectMake(0, 0, viewSize.width,viewSize.height)];
    //[self.view insertSubview:backgroundView atIndex:0];
    
    //Create the gradient and add it to our view's root layer
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
 //   [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
   // self.title = @"Pimser";
    
    //UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"togo2"]];
    //titleImageView.frame = CGRectMake(0, 0, 15, 23);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,22,49)];
    label.text=@"TOGO";
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont fontWithName:@"Marion-Bold" size:30 ];
    label.textAlignment = UITextAlignmentCenter;
    label.numberOfLines = 0;

    self.navigationItem.titleView =label;

    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    
    [super viewDidLoad];
    
    
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.collectionView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor underPageBackgroundColor];
    //[refreshControl tintColor]=[UIColor redColor];
    
   // NSArray  * myArray2 = [NSArray arrayWithObjects:@"1",nil];
    
    
    NSString *myUrl = @"http://www.baveco.net/books.txt";
    NSString *returnData = [NSString stringWithContentsOfURL:[NSURL URLWithString: myUrl]];
    itemArray = [returnData componentsSeparatedByString:@","];
    
    //  NSString *content =  [NSString stringWithContentsOfURL:@"http://www.baveco.net/book.txt" encoding:NSUTF8StringEncoding error:nil];
    NSString *magsay = [itemArray objectAtIndex:0];
    
    NSLog(magsay);

    DERGISAYISI = [magsay intValue]; // [itemArray objectAtIndex:0] ;
    
    if (returnData==NULL){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *RCMAGSAY = [defaults objectForKey:@"MagSay"];
        DERGISAYISI= [RCMAGSAY intValue];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"İnternet Bağlantısı Yok ! Kataloglar Offline Modda Sergilenecek." message:nil delegate:nil
                              cancelButtonTitle:nil otherButtonTitles:@"Tamam", nil];
        [alert show];
        checkconn=FALSE;
        
        itemArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPath]];
        
    }else{
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *iosMAGSAY = [defaults objectForKey:@"MagSay"];
        if ([magsay isEqualToString:iosMAGSAY]){}else{[self indir];}
        [defaults setObject:magsay forKey:@"MagSay"];
        [NSKeyedArchiver archiveRootObject:itemArray toFile:[self getPath]];
        checkconn=TRUE;
        
    }
    
    
   // MYGlobalVariable=2;
  //  [reach startNotifier];
//    sleep(24);
   // sleep(2.0f);
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       
        if(checkconn){}else{ UIAlertView *alert = [[UIAlertView alloc]
                                                   initWithTitle:@"İnternet Bağlantısı Yok !" message:nil delegate:nil
                                                   cancelButtonTitle:nil otherButtonTitles:@"Tamam", nil];
            [alert show];
        }
        
        [refreshControl endRefreshing];
    });
}


- (void)arrangeCollectionView {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    } else {
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
    }
    
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView reloadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self arrangeCollectionView];
    
    
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    [self arrangeCollectionView];

    
}


-(void)artistgec{

    [self performSegueWithIdentifier:@"artist" sender:self];

}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
  
  
    
    return DERGISAYISI;//[[Repository dataIPad] count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MagazineCell *cell = (MagazineCell*)[cv dequeueReusableCellWithReuseIdentifier:@"MagazineCell" forIndexPath:indexPath];
    
   // NSDictionary *item = [Repository dataIPad][indexPath.row];
 
    NSInteger *sayino = DERGISAYISI-indexPath.row;
    
cell.labelTitle.text = [itemArray objectAtIndex:indexPath.row+1];
cell.labelIssue.text = [NSString stringWithFormat:@"SAYI: %i",sayino];

cell.labelfiyat.text = [NSString stringWithFormat:@"Fiyat: %@",[itemArray objectAtIndex:DERGISAYISI+indexPath.row+1]];
    
    NSString *sayi = [NSString stringWithFormat:@"%d",indexPath.row];
   // NSLog([NSString stringWithFormat:@"%d",sayino]);
    
    //   NSLog(sayi);
   // NSURL *imgresim =[NSURL URLWithString:link];
    
  //  UIImage * img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imgresim]];
   NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/cover"];
   jpgPath = [jpgPath stringByAppendingString:[NSString stringWithFormat:@"%i",sayino]];
   jpgPath = [jpgPath stringByAppendingString:@".png"];
  

   // _CHECKPDF.alpha=1.0f;
    //_chcpdf.alpha=1.0f;
    
    NSString  *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/togo"];
    
    NSString* Dergi = documentsPath;// stringByAppendingPathComponent:@"/"];
    Dergi = [Dergi stringByAppendingString:[NSString stringWithFormat:@"%d",sayino]];
    Dergi = [Dergi stringByAppendingString:@".pdf"];
    BOOL dergidurumu = [[NSFileManager defaultManager] fileExistsAtPath:Dergi];
    
    
    if(dergidurumu){cell.chcpdf.alpha=1.0f;}else{cell.chcpdf.alpha=0.0f;}
    cell.imageCover.image = [UIImage imageWithContentsOfFile:jpgPath];//imageNamed:[NSString stringWithFormat:@"list-item-cover-%@", item[@"cover"]]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [[UICollectionReusableView alloc] init];
 
}


#pragma mark – UICollectionViewDelegateFlowLayout

+(BOOL)isPad
{
#ifdef UI_USER_INTERFACE_IDIOM
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#endif
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if( UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone  )//[deviceType isEqualToString:@"iPhone"])
    {
    return CGSizeMake(280, 167);
    }else {
    
    return CGSizeMake(370, 207);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *string = [NSString stringWithFormat:@"%d", indexPath.item];
    // NSString *sayino = //[NSString stringWithFormat:@"%d", indexPath.item];
    //   NSLog(  string);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:@"SelectedDergiNo"];
    
    [self performSegueWithIdentifier:@"detail" sender:self];



}
-(void)indir{
    int i;
    NSLog(@"Resimler indiriliyor..");
          NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    for (i=0; i<DERGISAYISI; i++) {
        
        NSString *link = @"http://www.baveco.net/bookcovers/img";
        link = [link stringByAppendingString:[NSString stringWithFormat:@"%i", DERGISAYISI-i]];
        link = [link stringByAppendingString:@".png"];
        
        NSURL *imgresim =[NSURL URLWithString:link];
        

        
        //   NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
      
NSString *resimyolu=path;
resimyolu = [resimyolu stringByAppendingString:[NSString stringWithFormat:@"/cover%d",DERGISAYISI-i]];
resimyolu = [resimyolu stringByAppendingString:@".png"];

        
      //  NSLog(resimyolu);
        // UIImage * resimto = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:imgresim]];
        NSData *imgData =[NSData dataWithContentsOfURL:imgresim];//= UIImagePNGRepresentation(resimto);
     

 
        [imgData writeToFile:resimyolu atomically:YES];

    }





}


@end
