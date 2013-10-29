//
//  DDMidiCommand_DDMidiCommandInternalAccess.h
//  Audiosamples
//
//  Created by David Drechsel on 18.07.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiCommand.h"

@interface DDMidiCommand ()
{
  @public
  UInt8 commandType;
  UInt8 parameter1;
  UInt8 parameter2;
}

-(UInt8)channelAndCommandType;
-(UInt8)parameter1;
-(UInt8)parameter2;

-(NSString*)commandStringRepresentation;

@end
