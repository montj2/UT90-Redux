//
//  Program.m
//  UltiTrackPro
//
//  Created by James Montgomery on 7/23/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import "Program.h"

@implementation Program

@synthesize programID = _programID;
@synthesize programName = _programName;
@synthesize isEditable = _isEditable;

- (id) initWithProgramID:(NSInteger)programID programName:(NSString *)programName isEditable:(BOOL)isEditable
{
    if (self = [super init])
    {
        self.programID = programID;
        self.programName = programName;
        self.isEditable = isEditable;
    }

    return self;
}


- (id) init
{
    return [self initWithProgramID:-1 programName:@"Default" isEditable:NO];
}


- (NSString *) description
{
    return [NSString stringWithFormat:@"ID: %d Name: %@ Can Edit: %d",
            _programID, _programName, _isEditable];
}


@end
