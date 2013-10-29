//
//  DDMidiChannelPressure.h
//  Audiosamples
//
//  Created by David Drechsel on 20.08.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiCommand.h"

@interface DDMidiChannelPressure : DDMidiCommand

@property (nonatomic, assign) UInt8 pressure;

@end
