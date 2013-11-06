//
//  BandSetCell.h
//  UltiTrack90
//
//  Created by James Montgomery on 9/8/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BandSetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bandSetTitle;
@property (weak, nonatomic) IBOutlet UILabel *bandSetCount;
@property (weak, nonatomic) IBOutlet UILabel *bandSetWeightRange;
@property (weak, nonatomic) IBOutlet UILabel *bandSetActive;
@end
