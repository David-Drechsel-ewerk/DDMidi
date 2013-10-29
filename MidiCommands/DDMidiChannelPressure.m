//
//  DDMidiChannelPressure.m
//  Audiosamples
//
//  Created by David Drechsel on 20.08.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiChannelPressure.h"
#import "DDMidiCommand_DDMidiCommandInternalAccess.h"

@implementation DDMidiChannelPressure

-(id)init
{
  if (self = [super init])
  {
    commandType = DDMidiCommandTypeChannelPressure;
  }
  return self;
}

-(UInt8)pressure
{
  return parameter1;
}

-(void)setPressure:(UInt8)pressure
{
  parameter1 = pressure;
}

-(NSString *)commandStringRepresentation
{
  return [NSString stringWithFormat:@"%d-%d", [self channelAndCommandType], parameter1];
}

@end
