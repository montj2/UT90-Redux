//
//  UTPViewController.h
//  UltiTrack90
//
//  Created by James Montgomery on 11/5/13.
//  Copyright (c) 2013 James Montgomery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface AdViewController : UIViewController <GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *fullPageAd; 

@end
