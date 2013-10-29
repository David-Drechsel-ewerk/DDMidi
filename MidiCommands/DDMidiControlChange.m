//
//  DDMidiControlChange.m
//  SYNTHL
//
//  Created by David Drechsel on 11.10.13.
//
//

#import "DDMidiControlChange.h"
#import "DDMidiCommand_DDMidiCommandInternalAccess.h"

@implementation DDMidiControlChange


-(id)init
{
  if (self = [super init])
  {
    commandType = DDMidiCommandTypeControlChange;
  }
  return self;
}

-(NSString *)commandStringRepresentation
{
  return [NSString stringWithFormat:@"%d-%d", [self channelAndCommandType], parameter1];
}

-(UInt8)controllerNumber
{
  return parameter1;
}

-(void)setControllerNumber:(UInt8)controllerNumber
{
  parameter1 = controllerNumber;
}

-(UInt8)value
{
  return parameter2;
}

-(void)setValue:(UInt8)value
{
  parameter2 = value;
}

-(float)normalizedValue
{
  return parameter2/127.0f;
}

@end
