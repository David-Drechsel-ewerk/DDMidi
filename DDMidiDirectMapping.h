//
//  DDMidiDirectMapping.h
//  Audiosamples
//
//  Created by David Drechsel on 15.08.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMidiCommand.h"

@interface DDMidiDirectMapping : NSObject <NSCoding>
@property (nonatomic, retain) DDMidiCommand *command;
@property (nonatomic, retain) id <DDMidiCommandResponder> object;
@property (nonatomic, readonly) id <NSCoding> objectIdentifier;
@end
