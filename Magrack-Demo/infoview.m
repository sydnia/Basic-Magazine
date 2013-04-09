//
//  infoview.m
//  Magrack-Demo
//
//  Created by Volkan UGUR on 25.03.2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "infoview.h"
#import "REComposeViewController.h"
#import <MessageUI/MFMailComposeViewController.h>



@interface infoview ()

@end

@implementation infoview

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
    
    NSString *urlAddress = @"http://www.togo.com.tr";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
   
    [webView loadRequest:requestObj];
   
    [webView setScalesPageToFit:YES];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backmain{


    [self dismissViewControllerAnimated:YES completion:nil];

}


-(void)sendcomment{

    
    NSString *urlAddress = @"http://togo.com.tr/iletisim.htm";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    
    [webView loadRequest:requestObj];
    
    [webView setScalesPageToFit:YES];


}


-(void)changecomp:(id)sender{
    
    UISegmentedControl *seg = (UISegmentedControl*)sender;
 //   NSString *SelectedTab = [NSString stringWithFormat:@"%d", seg.selectedSegmentIndex];
    NSString *urlAddress;
    //if (seg.selectedSegmentIndex==0){urlAddress=@"http://www.togo.com.tr/";}
    //if (seg.selectedSegmentIndex==1){urlAddress=@"http://pimser.com/lg/lg.htm";}
    //if (seg.selectedSegmentIndex==2){urlAddress=@"http://pimser.com/grundig/grundig.htm";}

    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    
    [webView loadRequest:requestObj];
    
    [webView setScalesPageToFit:YES];

}



@end
