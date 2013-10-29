//
//  DDMidiNoteOn.h
//  Audiosamples
//
//  Created by David Drechsel on 18.07.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiCommand.h"

@interface DDMidiNoteOn : DDMidiCommand

@property (nonatomic, assign) UInt8 note;
@property (nonatomic, assign) UInt8 velocity;

@end
