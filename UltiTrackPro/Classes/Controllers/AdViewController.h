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
#import <FXBlurView.h>

@interface AdViewController : UIViewController <GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *fullPageAd;
@property (nonatomic, strong) NSString *completionMessage;
@property (nonatomic, weak) IBOutlet UILabel *completionLabel;
@property (nonatomic, strong) FXBlurView *blurView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)viewAdButton:(UIButton *)sender;
- (IBAction)noViewAdButton:(UIButton *)sender;


@end
