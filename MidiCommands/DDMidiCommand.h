//
//  DDMidiCommand.h
//  Audiosamples
//
//  Created by David Drechsel on 18.07.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

typedef enum {
  DDMidiCommandTypeNoteOff = 0x8, //two data bytes: note | velocity
  DDMidiCommandTypeNoteOn = 0x9, //two data bytes: note | velocity
  DDMidiCommandTypeAfterTouch = 0xA, //two data bytes: note | velocity
  DDMidiCommandTypeControlChange = 0xB, //two data bytes: controllernumber | value
  DDMidiCommandTypeProgramChange = 0xC, //one data byte: program number
  DDMidiCommandTypeChannelPressure = 0xD, //one data byte: pressure
  DDMidiCommandTypePitchWheel = 0xE //two data bytes: both describe the pitch and should be combined for greater accuracy (http://home.roadrunner.com/~jgglatt/tech/midispec.htm)
} DDMidiCommandType;

@class DDMidiCommand;

//direct mapping
@protocol DDMidiCommandResponder <NSObject>
@required
@property (nonatomic, retain) id <NSCoding> uniqueIdentifier; //an object to save the mapping and rebuild or find the corresponding object on load

- (void) didReceiveDirectMidiCommand:(DDMidiCommand*)command;

@optional
- (DDMidiCommand*) responseToDirectMidiCommand:(DDMidiCommand*)command;

@end

@interface DDMidiCommand : NSObject <NSCoding>

@property (nonatomic, assign) UInt8 midiChannel;


-(BOOL)isBasicallyEqualTo:(id)obj;

-(NSString*)param1String;

@end
