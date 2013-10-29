//
//  DDMidiControlChange.h
//  SYNTHL
//
//  Created by David Drechsel on 11.10.13.
//
//

#import "DDMidiCommand.h"

@interface DDMidiControlChange : DDMidiCommand

@property (nonatomic, assign) UInt8 controllerNumber;
@property (nonatomic, assign) UInt8 value;

-(float)normalizedValue;

@end
