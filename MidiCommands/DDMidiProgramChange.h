//
//  DDMidiProgramChange.h
//  Audiosamples
//
//  Created by David Drechsel on 21.08.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiCommand.h"

@interface DDMidiProgramChange : DDMidiCommand

@property (nonatomic, assign) UInt8 program;

@end
