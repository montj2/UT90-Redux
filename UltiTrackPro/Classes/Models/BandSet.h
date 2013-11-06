//
//  BandSet.h
//  UltiTrack90
//
//  Created by James Montgomery on 9/7/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BandSet : NSObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger setID;
@property (nonatomic, assign) BOOL isEditable;
@property (nonatomic, copy) NSString *setName;

- (id)initWithSetID:(NSInteger)setID setName:(NSString *)setName isEditable:(BOOL)isEditable;

@end
