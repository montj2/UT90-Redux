//
//  HistoryCell.m
//  UltiTrack90
//
//  Created by James Montgomery on 9/19/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "HistoryCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation HistoryCell

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
