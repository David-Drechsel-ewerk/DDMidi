//
//  DDMidiPitchWheel.h
//  SYNTHL
//
//  Created by David Drechsel on 11.10.13.
//
//

#import "DDMidiCommand.h"

@interface DDMidiPitchWheel : DDMidiCommand

-(void)setDataByte1:(UInt8)byte1 byte2:(UInt8)byte2;

-(float)normalizedPitchWheel; // -1.0-1.0 | 0 is unison
-(unsigned short)rawPitchWheel;

@end
