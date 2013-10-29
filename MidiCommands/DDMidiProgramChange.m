//
//  DDMidiProgramChange.m
//  Audiosamples
//
//  Created by David Drechsel on 21.08.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiProgramChange.h"
#import "DDMidiCommand_DDMidiCommandInternalAccess.h"

@implementation DDMidiProgramChange

-(id)init
{
  if (self = [super init])
  {
    commandType = DDMidiCommandTypeProgramChange;
  }
  return self;
}

-(void)setProgram:(UInt8)program
{
  parameter1 = program;
}

-(UInt8)program
{
  return parameter1;
}

-(NSString *)commandStringRepresentation
{
  return [NSString stringWithFormat:@"%d-%d", [self channelAndCommandType], parameter1];
}

@end
