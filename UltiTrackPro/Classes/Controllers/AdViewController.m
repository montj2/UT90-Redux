//
//  UTPViewController.m
//  UltiTrack90
//
//  Created by James Montgomery on 11/5/13.
//  Copyright (c) 2013 James Montgomery. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()

@end

@implementation AdViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set up the ads
    self.fullPageAd = [[GADInterstitial alloc] init];
    self.fullPageAd.delegate = self;
    self.fullPageAd.adUnitID = @"ca-app-pub-2915168992422718/6430614988";
    
    //Create the background view and adjust the alpha for readability
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    [backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    backgroundView.alpha = 0.5;
    [self.view insertSubview:backgroundView atIndex:0];

    //Set the completion label text described in ExerciseDetailViewController
    self.completionLabel.text = self.completionMessage;
    
    self.blurView = [[FXBlurView alloc] init];
    self.blurView.frame = self.view.bounds;
    self.blurView.blurEnabled = YES;
    self.blurView.blurRadius = 6.0f;
    [self.blurView addSubview:self.activityIndicator];
 
}
- (IBAction)viewAdButton:(UIButton *)sender {
    
    [self.view addSubview:self.blurView];
    [self.activityIndicator startAnimating];
    
    GADRequest *request = [GADRequest request];
    request.testing = YES;
    [self.fullPageAd loadRequest:request];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark GADelegate
// Sent when an interstitial ad request succeeded.  Show it at the next
// transition point in your application such as when transitioning between view
// controllers.
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    
    [self.activityIndicator stopAnimating];
    [self.blurView removeFromSuperview];
    
    [self.fullPageAd presentFromRootViewController:self];
}

// Sent when an interstitial ad request completed without an interstitial to
// show.  This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
    [self.activityIndicator stopAnimating];
    [self.blurView removeFromSuperview];
    
    NSLog(@"%@", error);
    //add alertview
    
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)noViewAdButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
