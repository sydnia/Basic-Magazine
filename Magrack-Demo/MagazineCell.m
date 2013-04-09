//
//  MagazineCell.m
//  Magrack
//
//  Created by Valentin Filip on 11/17/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "MagazineCell.h"

@implementation MagazineCell


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.labelTitle.textColor = [UIColor whiteColor];//[UIColor colorWithRed:0.88f green:0.80f blue:0.83f alpha:1.00f];
    self.labelTitle.backgroundColor = [UIColor clearColor];
    
    self.labelIssue.textColor = [UIColor colorWithRed:1.00f green:0.25f blue:0.55f alpha:1.00f];
    self.labelIssue.backgroundColor = [UIColor clearColor];
    
}

@end
