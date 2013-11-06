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
	// Do any additional setup after loading the view.
    GADRequest *request = [GADRequest request];
    request.testing = YES;
    self.fullPageAd = [[GADInterstitial alloc] init];
    self.fullPageAd.delegate = self;
    self.fullPageAd.adUnitID = @"ca-app-pub-2915168992422718/6430614988";
    //[self.fullPageAd loadRequest:request];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];

 
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
    [self.fullPageAd presentFromRootViewController:self];
    NSLog(@"presented ad");

}

// Sent when an interstitial ad request completed without an interstitial to
// show.  This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%@", error);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
