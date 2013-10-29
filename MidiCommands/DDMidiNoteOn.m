//
//  DDMidiNoteOn.m
//  Audiosamples
//
//  Created by David Drechsel on 18.07.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiNoteOn.h"
#import "DDMidiCommand_DDMidiCommandInternalAccess.h"

@implementation DDMidiNoteOn

-(id)init
{
  if (self = [super init])
  {
    commandType = DDMidiCommandTypeNoteOn;
  }
  return self;
}

-(void)setNote:(UInt8)newNote
{
  parameter1 = newNote;
}

-(UInt8)note
{
  return parameter1;
}

-(void)setVelocity:(UInt8)velocity
{
  parameter2 = velocity;
}

-(UInt8)velocity
{
  return parameter2;
}

-(NSString *)commandStringRepresentation
{
  return [NSString stringWithFormat:@"%d-%d", [self channelAndCommandType], parameter1];
}

@end
