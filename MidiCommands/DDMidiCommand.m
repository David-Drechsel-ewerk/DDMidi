//
//  DDMidiCommand.m
//  Audiosamples
//
//  Created by David Drechsel on 18.07.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiCommand.h"
#import "DDMidiCommand_DDMidiCommandInternalAccess.h"

@implementation DDMidiCommand
@synthesize midiChannel;

-(UInt8)channelAndCommandType
{
  UInt8 convertedType = commandType << 4;
  return convertedType + self.midiChannel;
}

-(UInt8)parameter1
{
  return parameter1;
}

-(UInt8)parameter2
{
  return parameter2;
}

-(NSString *)description
{
  return [NSString stringWithFormat:@"MidiCommand: [%02x,%02x,%02x]",
          [self channelAndCommandType],
          parameter1,
          parameter2];
}

// overwrite in subclasses
-(NSString *)commandStringRepresentation
{
  return [NSString stringWithFormat:@"%d-%d-%d", [self channelAndCommandType], parameter1, parameter2];
}

-(NSString*)param1String
{
  return [NSString stringWithFormat:@"%02x", parameter1];
}

#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeInteger:commandType forKey:@"commandType"];
  [aCoder encodeInteger:self.midiChannel forKey:@"channel"];
  [aCoder encodeInteger:parameter1 forKey:@"param1"];
  [aCoder encodeInteger:parameter2 forKey:@"param2"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super init])
  {
    self.midiChannel = [aDecoder decodeIntegerForKey:@"channel"];
    commandType = [aDecoder decodeIntegerForKey:@"commandType"];
    parameter1 = [aDecoder decodeIntegerForKey:@"param1"];
    parameter2 = [aDecoder decodeIntegerForKey:@"param2"];
  }
  return self;
}

-(BOOL)isBasicallyEqualTo:(id)obj
{
  return NO;
}

@end
