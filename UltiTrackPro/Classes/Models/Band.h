//
//  Band.h
//  UltiTrack90
//
//  Created by James Montgomery on 9/7/12.
//  Copyright (c) 2012 James Montgomery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Band : NSObject

@property (nonatomic, assign) NSInteger _id;
@property (nonatomic, assign) NSInteger bandID;
@property (nonatomic, assign) NSInteger colorID;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) BOOL isEditable;

- (id)initWithBandID:(NSInteger)bandID colorID:(NSInteger)colorID weight:(NSInteger)weight color:(NSString *)color isEditable:(BOOL)isEditable;
@end
