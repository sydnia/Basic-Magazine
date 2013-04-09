//
//  infoview.h
//  Magrack-Demo
//
//  Created by Volkan UGUR on 25.03.2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoview : UIViewController{

IBOutlet UIWebView *webView;
}

-(IBAction)backmain;
-(IBAction)sendcomment;
-(IBAction)changecomp:(id)sender;



@end
