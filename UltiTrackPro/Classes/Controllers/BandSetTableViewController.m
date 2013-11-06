//
//  BandsTableViewController.m
//  UltiTrack90
//
//  Created by James Montgomery on 9/7/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "BandSetTableViewController.h"
#import "BandSet.h"
#import "BandSetCell.h"
#import "DataHelper.h"
#import "BandDetailTableViewController.h"

@interface BandSetTableViewController () {
    NSMutableDictionary *settingsDict;
    BOOL hasBeenUpdated;
    BandSet *selectedBandSet;
}

@property (nonatomic, strong) BandSet *bandSet;
@end

@implementation BandSetTableViewController

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

    //Get the program preference from ProgramSettings.plist
    // If the file doesn't exist in the Documents Folder, copy it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self dataFilePath]])
    {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"ProgramSettings" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:[self dataFilePath] error:nil];
    }

    //Set the program preferences property to the contents of the ProgramSettings plist
    settingsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataFilePath]];

    //Add observer to watch for plist changes
    [settingsDict addObserver:self forKeyPath:@"activeBandSet" options:NSKeyValueObservingOptionNew context:NULL];

    //BG Config Info
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
    [self.tableView.backgroundView setContentMode:UIViewContentModeScaleAspectFill];
    [self.tableView.backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //if the ProgramSettings.plist has been modified, reload tableData and reset flag
    if (hasBeenUpdated)
    {
        hasBeenUpdated = NO;
    }

    [self.tableView reloadData];
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
    self.bandSet = [self.dataSource objectAtIndex:indexPath.row];

    static NSString *CellIdentifier = @"Cell";
    BandSetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    self.bandSetDetails = [[DataHelper sharedManager] bandSetInfoForSet:self.bandSet.setID];

    // Configure the cell...
    cell.bandSetTitle.text = self.bandSet.setName;
    cell.bandSetCount.text = [NSString stringWithFormat:@"%d Bands",[[self.bandSetDetails objectAtIndex:0] intValue]];
    cell.bandSetWeightRange.text = [NSString stringWithFormat:@"Weight Range: %d - %d",
                                    [[self.bandSetDetails objectAtIndex:1] intValue],
                                    [[self.bandSetDetails objectAtIndex:2] intValue]];

    cell.bandSetActive.text = ([[settingsDict valueForKey:@"activeBandSet"] intValue] == indexPath.row + 1) ? @"Active" : @"";

    return cell;
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = (indexPath.row % 2 == 0) ? [UIColor colorWithRed:218.0f / 255.0f green:218.0f / 255.0f blue:218.0f / 255.0f alpha:.5] : [UIColor colorWithRed:201.0f / 255.0f green:201.0f / 255.0f blue:201.0f / 255.0f alpha:.5];
}


#pragma mark - Table view delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set the selected program to active in ProgramSettings.plist if different from current value
    if ( [[settingsDict valueForKey:@"activeBandSet"] intValue] != (indexPath.row + 1) )
    {
        [settingsDict setValue:[NSNumber numberWithInt:(indexPath.row + 1)] forKey:@"activeBandSet"];
    }
}


#pragma mark KVO
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //Write the settings dictionary to disk
    [settingsDict writeToFile:[self dataFilePath] atomically:YES];
    //Trip the flag for hasBeenUpdated so tableData will be reloaded on viewWillAppear
    hasBeenUpdated = YES;
}


#pragma mark FilePath
- (NSString *) documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    return documentsDirectory;
}


- (NSString *) dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"ProgramSettings.plist"];
}


#pragma mark segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedRowIndexPath = [self.tableView indexPathForSelectedRow];
    selectedBandSet = [self.dataSource objectAtIndex:selectedRowIndexPath.row];

    BandSetTableViewController *controller = segue.destinationViewController;
    controller.dataSource = [[DataHelper sharedManager] bandsForSet:selectedBandSet.setID];
    controller.title = [NSString stringWithFormat:@"Bands in %@", selectedBandSet.setName];
}


@end
