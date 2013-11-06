//
//  HistoryTableViewController.m
//  UltiTrack90
//
//  Created by James Montgomery on 9/19/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "Stat.h"
#import "HistoryCell.h"
#import <QuartzCore/QuartzCore.h>
@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }

    return self;
}


- (void) viewDidLoad
{
    [super viewDidLoad];

    //BG conf info
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    [self.tableView.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView.backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //Header manipulation based upon exercise type
    if (self.exerciseType == 2)   //time based
    {
        self.headerBandLabel.hidden = YES;
        self.headerNotesLabel.hidden = YES;
        self.headerRepsLabel.hidden = YES;
        self.headerWeightLabel.hidden = YES;
    }
    else     //rep based
    {
        self.headerTimeLabel.hidden = YES;
        self.headerTimeNotesLabel.hidden = YES;
    }
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataSource count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    Stat *stat = [self.dataSource objectAtIndex:indexPath.row];

    cell.dateLabel.text = stat.date;

    if (self.exerciseType == 2)   //time based
    {
        cell.timeNotesLabel.text = stat.notes;
        cell.timeLabel.text = stat.time;
        cell.repsLabel.hidden = YES;
        cell.weightLabel.hidden = YES;
        cell.bandsImage.hidden = YES;
        cell.notesLabel.hidden = YES;
    }
    else
    {
        cell.repsLabel.text = [NSString stringWithFormat:@"%d",stat.reps];
        cell.weightLabel.text = [NSString stringWithFormat:@"%d", stat.weight];
        cell.bandsImage.backgroundColor = [self colorForBandColorID:stat.bandID]; //BandID is actually storing ColorID - see ExerciseDetail
        cell.notesLabel.text = stat.notes;
        cell.timeLabel.hidden = YES;
        cell.timeNotesLabel.hidden = YES;
    }

    return cell;
}


- (UIColor *) colorForBandColorID:(NSInteger)bandColorID
{
    switch (bandColorID)
    {
        case 0: //nothing/clear
            return [UIColor clearColor];
            break;
        case 1: //255-192-203	Pink
            return [UIColor colorWithRed:255.0f / 255.0f green:192.0f / 255.0f blue:203.0f / 255.0f alpha:1.0f];
            break;
        case 2: //magenta
            return [UIColor magentaColor];
            break;
        case 3: //red
            return [UIColor redColor];
            break;
        case 4: //green
            return [UIColor greenColor];
            break;
        case 5: //blue
            return [UIColor blueColor];
            break;
        case 6: //black
            return [UIColor blackColor];
            break;
        case 7: //orange
            return [UIColor orangeColor];
            break;
        case 8: //yellow
            return [UIColor yellowColor];
            break;
        case 9: //purple
            return [UIColor purpleColor];
            break;
        default:
            return [UIColor whiteColor];
            break;
    } /* switch */
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:.5] : [UIColor colorWithRed:201.0f / 255.0f green:201.0f / 255.0f blue:201.0f / 255.0f alpha:.5];
    HistoryCell *myCell = (HistoryCell *)cell;
    [myCell.bandsImage.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [myCell.bandsImage.layer setBorderWidth:1.0f];
    [myCell.bandsImage.layer setCornerRadius:4.0f];
    [myCell.bandsImage.layer setMasksToBounds:YES];
}


- (IBAction) doneButton:(id)sender
{
    //[self.presentingViewController dismissModalViewControllerAnimated:YES];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void) viewDidUnload
{
    [self setTblHeader:nil];
    [super viewDidUnload];
}


@end
