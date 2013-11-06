//
//  BandsTableViewController.h
//  UltiTrack90
//
//  Created by James Montgomery on 9/7/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BandSetTableViewController : UITableViewController

@property (nonatomic, copy) NSArray *dataSource;
@property (nonatomic, copy) NSArray *bandSetDetails;

@end
