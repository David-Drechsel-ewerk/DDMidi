//
//  DDMidiNoteOff.m
//  Audiosamples
//
//  Created by David Drechsel on 18.07.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiNoteOff.h"
#import "DDMidiCommand_DDMidiCommandInternalAccess.h"

@implementation DDMidiNoteOff

-(id)init
{
  if (self = [super init])
  {
    commandType = DDMidiCommandTypeNoteOff;
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

-(NSString *)commandStringRepresentation
{
  return [NSString stringWithFormat:@"%d-%d", [self channelAndCommandType], parameter1];
}

@end
