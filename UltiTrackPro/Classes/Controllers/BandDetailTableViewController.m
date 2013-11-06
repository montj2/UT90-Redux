//
//  BandDetailTableViewController.m
//  UltiTrack90
//
//  Created by James Montgomery on 9/17/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "BandDetailTableViewController.h"
#import "Band.h"
#import "BandDetailCell.h"
#import <QuartzCore/QuartzCore.h>

@interface BandDetailTableViewController () {
    NSInteger lbsOrKgPreference;
}

@end

@implementation BandDetailTableViewController

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

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    lbsOrKgPreference = standardUserDefaults ? [[standardUserDefaults valueForKey:@"weight_preference"] integerValue] : 0;

    //BG Config Info
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    [self.tableView.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView.backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    self.navigationController.navigationBar.backItem.title = @"Bands";
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
    Band *band = [self.dataSource objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"Cell";
    BandDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...

    cell.weightLabel.text = (lbsOrKgPreference != 0) ? [NSString stringWithFormat:@"%.1f Kg.",band.weight / 2.2f ] : [NSString stringWithFormat:@"%d Lbs.", band.weight];
    cell.bandColorView.backgroundColor = [self colorForBandColorID:band.colorID];

    return cell;
}


- (UIColor *) colorForBandColorID:(NSInteger)colorID
{
    switch (colorID)
    {
        case 0: //nothing/clear
            return [UIColor whiteColor];
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
            return [UIColor clearColor];
            break;
    } /* switch */
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BandDetailCell *myCell = (BandDetailCell *)cell;

    [myCell.bandColorView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [myCell.bandColorView.layer setBorderWidth:1.0f];
    [myCell.bandColorView.layer setCornerRadius:4.0f];
    [myCell.bandColorView.layer setMasksToBounds:YES];

    cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:.5] : [UIColor colorWithRed:201.0f / 255.0f green:201.0f / 255.0f blue:201.0f / 255.0f alpha:.5];
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
