//
//  DDMidiParser.h
//  Audiosamples
//
//  Created by David Drechsel on 18.07.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDMidiCommand.h"
#import "DDMidiNoteOff.h"
#import "DDMidiNoteOn.h"
#import "DDMidiChannelPressure.h"
#import "DDMidiProgramChange.h"
#import "DDMidiPitchWheel.h"
#import "DDMidiControlChange.h"

#import "PGMidi.h"

#define kMidiChannelOmni -1

@class DDMidi;

// general delegate for all relevant informations | called on a high priority background thread
@protocol DDMidiDelegate <NSObject>
@optional
- (BOOL) shouldForwardMidiCommand:(DDMidiCommand*)command toResponder:(id <DDMidiCommandResponder>)responder; //Defaults to YES
- (BOOL) shouldConnectToSource:(PGMidiSource*)source; //Defaults to YES
- (void) didRemoveSource:(PGMidiSource*)source;
- (void) didAddDestination:(PGMidiDestination *)destination;
- (void) didRemoveDestination:(PGMidiDestination *)destination;

- (void) didReceiveMidiCommand:(DDMidiCommand*)command fromSource:(PGMidiSource*)source;
@end

@protocol DDMidiDirectMappingDataSource <NSObject>

-(id <DDMidiCommandResponder>)directMidiCommandResponderForUniqueIdentifier:(id)identifier;

@end

@interface DDMidi : NSObject
@property (nonatomic, assign) id <DDMidiDelegate> delegate;
@property (nonatomic, assign) id <DDMidiDirectMappingDataSource> directMappingDataSource;

+(int)midiChannel;
+(void)setMidiChannel:(int)channel;

//accessors
- (NSArray*) sources; //PGMidiSource
- (NSArray*) destinations; //PGMidiDestination

//direct mapping
- (void) mapObject:(id <DDMidiCommandResponder> )object toCommand:(DDMidiCommand*)command;
- (void) mapObject:(id <DDMidiCommandResponder> )object toCommand:(DDMidiCommand*)command overwrite:(BOOL)overwrite;
- (id <DDMidiCommandResponder>) objectMappedToCommand:(DDMidiCommand*)command;
- (DDMidiCommand*) commandMappedToObject:(id <DDMidiCommandResponder>)object;
- (void) removeAllMappingsForObject:(id)object;

//sending
- (void) sendMidiCommand:(DDMidiCommand*)command; //just sends to all available destinations
- (void) sendMidiCommand:(DDMidiCommand*)command toDestinations:(NSArray*)destinations;

//helpers
- (void) attachToAllExistingSources;

//directmapping load (you need to support the DirectMappingDatasource)
-(BOOL)predefinedMappingWithNameExists:(NSString*)name;
-(BOOL)loadPredefinedMappingForName:(NSString*)name;
-(void)saveCurrentMappingForName:(NSString*)name;

@end
