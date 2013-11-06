//
//  Band.m
//  UltiTrack90
//
//  Created by James Montgomery on 9/7/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "Band.h"

@implementation Band

- (id) initWithBandID:(NSInteger)bandID colorID:(NSInteger)colorID weight:(NSInteger)weight color:(NSString *)color isEditable:(BOOL)isEditable
{
    if (self = [super init])
    {
        _bandID = bandID;
        _colorID = colorID;
        _weight = weight;
        _color = color;
        _isEditable = isEditable;
    }

    return self;
}


- (id) init
{
    return [self initWithBandID:0 colorID:0 weight:0 color:@"" isEditable:NO];
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"bandID:%d colorID:%d weight:%d color:%@ isEditable:%d", _bandID, _colorID, _weight, _color, _isEditable];
}


@end
