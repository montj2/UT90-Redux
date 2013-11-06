//
//  Program.h
//  UltiTrackPro
//
//  Created by James Montgomery on 7/23/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Program : NSObject

@property (nonatomic, assign) NSInteger programID;
@property (nonatomic, copy) NSString *programName;
@property (nonatomic, assign) BOOL isEditable;

- (id)initWithProgramID:(NSInteger)programID programName:(NSString *)programName isEditable:(BOOL)isEditable;

@end
