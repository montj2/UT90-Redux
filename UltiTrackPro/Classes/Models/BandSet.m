//
//  BandSet.m
//  UltiTrack90
//
//  Created by James Montgomery on 9/7/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "BandSet.h"

@implementation BandSet

- (id) initWithSetID:(NSInteger)setID setName:(NSString *)setName isEditable:(BOOL)isEditable
{
    if (self = [super init])
    {
        _setID = setID;
        _setName = setName;
        _isEditable = isEditable;
    }

    return self;
}


- (id) init
{
    return [self initWithSetID:0 setName:@"" isEditable:NO];
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"setID:%d setName:%@ isEditable:%d",_setID, _setName, _isEditable];
}


@end
