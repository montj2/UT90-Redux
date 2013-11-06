//
//  BandSetCell.m
//  UltiTrack90
//
//  Created by James Montgomery on 9/8/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "BandSetCell.h"

@implementation BandSetCell
@synthesize bandSetTitle;
@synthesize bandSetCount;
@synthesize bandSetWeightRange;
@synthesize bandSetActive;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }

    return self;
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
