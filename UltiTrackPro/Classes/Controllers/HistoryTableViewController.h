//
//  HistoryTableViewController.h
//  UltiTrack90
//
//  Created by James Montgomery on 9/19/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewController : UITableViewController
@property (nonatomic, copy) NSArray *dataSource;
- (IBAction)doneButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *tblHeader;
@property (weak, nonatomic) IBOutlet UILabel *headerRepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerBandLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerTimeNotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerNotesLabel;
@property (nonatomic, assign) NSInteger exerciseType;
@end
