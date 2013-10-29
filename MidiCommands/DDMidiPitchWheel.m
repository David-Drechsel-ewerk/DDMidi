//
//  DDMidiPitchWheel.m
//  SYNTHL
//
//  Created by David Drechsel on 11.10.13.
//
//

#import "DDMidiPitchWheel.h"
#import "DDMidiCommand_DDMidiCommandInternalAccess.h"

#define kMaxPitchWheel 0x3FFF //16383 --> 14 bit
#define kMaxPitchWheelFloat 16383.0f

@implementation DDMidiPitchWheel

// the 2 data parameters need to be combined for more accurracy
unsigned short CombineBytes(unsigned char First, unsigned char Second)
{
  unsigned short _14bit;
  _14bit = (unsigned short)Second;
  _14bit <<= 7;
  _14bit |= (unsigned short)First;
  return(_14bit);
}

-(id)init
{
  if (self = [super init])
  {
    commandType = DDMidiCommandTypePitchWheel;
  }
  return self;
}

-(void)setDataByte1:(UInt8)byte1 byte2:(UInt8)byte2
{
  parameter1 = byte1;
  parameter2 = byte2;
}

// unison (normalized 0) is in the center of the pitch wheel --> -1.0f - 1.0f
-(float)normalizedPitchWheel
{
  float wholeNumberScaled = [self rawPitchWheel]/kMaxPitchWheelFloat; // 0.0f - 1.0f
  wholeNumberScaled *= 2.0f; // 0.0f - 2.0f
  wholeNumberScaled -= 1.0f; // -1.0f - 1.0f
  return wholeNumberScaled;
}

-(unsigned short)rawPitchWheel
{
  return CombineBytes(parameter1, parameter2);
}

-(NSString *)commandStringRepresentation
{
  return [NSString stringWithFormat:@"%d", [self channelAndCommandType]];
}

-(NSString *)description
{
  return [NSString stringWithFormat:@"PitchWheel: [%02x,%f]",
          [self channelAndCommandType],
          [self normalizedPitchWheel]];
}

@end
