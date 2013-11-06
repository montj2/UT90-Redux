//
//  DaysTableViewController.h
//  UltiTrackPro
//
//  Created by James Montgomery on 7/26/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaysTableViewController : UITableViewController<UIGestureRecognizerDelegate>
{
}
@property (nonatomic, strong) NSArray *tableDataSource;
@property (nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic) IBOutlet UIBarButtonItem *resetButton;
@property (nonatomic) IBOutlet UIBarButtonItem *skipButton;
@property (nonatomic) IBOutlet UIBarButtonItem *completeButton;

- (void)displayActionSheet;
- (IBAction)editAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)resetAction:(id)sender;
- (IBAction)skipAction:(id)sender;
- (IBAction)completeAction:(id)sender;
@end
