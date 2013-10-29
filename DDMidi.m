//
//  DDMidiParser.m
//  Audiosamples
//
//  Created by David Drechsel on 18.07.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidi.h"
#import "DDMidiCommand_DDMidiCommandInternalAccess.h"
#import "PGMidi.h"
#import "DDMidiDirectMapping.h"

static NSMutableArray *midiMapping = nil;


@interface DDMidi () <PGMidiDelegate, PGMidiSourceDelegate>
{
  PGMidi *pgMidi;
}

-(NSArray*)midiCommandsFromMidiPacket:(const MIDIPacket*)packet;

@end

@implementation DDMidi
@synthesize delegate, directMappingDataSource;

-(id)init
{
  if (self = [super init])
  {
    pgMidi = [[PGMidi alloc] init];
    pgMidi.delegate = self;
    pgMidi.networkEnabled = YES;
    [self attachToAllExistingSources];
  }
  return self;
}

#pragma mark accessors
-(NSArray*)sources
{
  return pgMidi.sources;
}

-(NSArray*)destinations
{
  return pgMidi.destinations;
}

#pragma mark parsing
-(id)commandWithType:(DDMidiCommandType)type
{
  DDMidiCommand *command = nil;
  
  switch (type)
  {
    case DDMidiCommandTypeNoteOff:
    {
      DDMidiNoteOff *noteOff = [[DDMidiNoteOff alloc] init];
      command = noteOff;
      break;
    }
    case DDMidiCommandTypeNoteOn:
    {
      DDMidiNoteOn *noteOn = [[DDMidiNoteOn alloc] init];
      command = noteOn;
      break;
    }
    case DDMidiCommandTypeChannelPressure:
    {
      DDMidiChannelPressure *channelPressure = [[DDMidiChannelPressure alloc] init];
      command = channelPressure;
      break;
    }
    case DDMidiCommandTypePitchWheel:
    {
      DDMidiPitchWheel *pitchWheel = [[DDMidiPitchWheel alloc] init];
      command = pitchWheel;
      break;
    }
    case DDMidiCommandTypeControlChange:
    {
      DDMidiControlChange *controlChange = [[DDMidiControlChange alloc] init];
      command = controlChange;
      break;
    }
    default:
      break;
  }
  
  return command;
}

-(NSArray*)midiCommandsFromMidiPacket:(const MIDIPacket *)packet
{
  NSMutableArray *parsedMidiCommands = [NSMutableArray array];
  
  NSUInteger packetLength = packet->length;
  
  if (packetLength == 0) return nil;
  

  DDMidiCommand *command = nil;
  int byteIndexInMessage = 0;
  
//  //log
//  NSMutableString *logString = [[NSMutableString alloc] init];
//  for (int indexInPacket = 0; indexInPacket < packetLength; indexInPacket++)
//  {
//    [logString appendFormat:@"%02x | ", packet->data[indexInPacket]];
//  }
//  NSLog(@"%@", logString);
  
  for (int indexInPacket = 0; indexInPacket < packetLength; indexInPacket++)
  {
    UInt8 byte = packet->data[indexInPacket];
    
    if (byte & (1<<7)) //is status byte --> new message
    {
      if (command)
      {
        [parsedMidiCommands addObject:command];
        byteIndexInMessage = 0;
        command = nil;
      }
      
      UInt8 type = (byte & 0xF0) >> 4;
      UInt8 channel = (byte & 0x0F);
      
      command = [self commandWithType:(DDMidiCommandType)type];
      
      command.midiChannel = channel;
    }
    else
    {
      if (!command)
      {
        NSLog(@"Strange midi byte. This is no status byte and there wasn't any.");
        return nil;
      }
      
      switch (byteIndexInMessage)
      {
        case 1:
          command->parameter1 = byte;
          break;
        case 2:
          command->parameter2 = byte;
          break;
        default:
          NSLog(@"longer message. Not parsable at the moment");
          break;
      }
    }
    byteIndexInMessage++;
  }

  if (command)
  {
    [parsedMidiCommands addObject:command];
    byteIndexInMessage = 0;
    command = nil;
  }

  return parsedMidiCommands;
}

#pragma mark directMapping
-(BOOL)loadPredefinedMappingForName:(NSString*)name
{
  if (!name)
    name = @"default";
  
  //TODO: load mapWithName
  
  NSArray *map = [self midiMapping];
  return [map count] > 0;
}
-(BOOL)predefinedMappingWithNameExists:(NSString*)name
{
  if (!name)
    name = @"default";

  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  
  NSString *fileName = [NSString stringWithFormat:@"%@.smm", name];
  NSString *file = [documentsDirectory stringByAppendingPathComponent:fileName];
  
  return [[NSFileManager defaultManager] fileExistsAtPath:file];
}

-(NSArray*)loadMidiMappingWithName:(NSString*)name
{
  if (!name)
    name = @"default";
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  
  NSString *fileName = [NSString stringWithFormat:@"%@.smm", name];
  NSString *file = [documentsDirectory stringByAppendingPathComponent:fileName];
  
  NSArray *mapping = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
  for (DDMidiDirectMapping *directMapping in mapping)
  {
    id <DDMidiCommandResponder> responder = nil;
    if ([self.directMappingDataSource respondsToSelector:@selector(directMidiCommandResponderForUniqueIdentifier:)])
      responder = [self.directMappingDataSource directMidiCommandResponderForUniqueIdentifier:directMapping.objectIdentifier];
    
    directMapping.object = responder;
  }
  
  return mapping ?: [NSArray array];
}

-(void)saveCurrentMappingForName:(NSString*)name
{
  if (!name)
    name = @"default";
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  
  NSString *fileName = [NSString stringWithFormat:@"%@.smm", name];
  NSString *file = [documentsDirectory stringByAppendingPathComponent:fileName];
  
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[self midiMapping]];
  
  NSError *err;
  if (![data writeToFile:file options:NSDataWritingAtomic error:&err])
  {
    NSLog(@"saving midimap %@ failed: %@", name, [err localizedDescription]);
  }
}

-(NSMutableArray*)midiMapping
{
  if (!midiMapping)
  {
    midiMapping = [[self loadMidiMappingWithName:nil] mutableCopy];
  }
  return midiMapping;
}

-(void)mapObject:(id <DDMidiCommandResponder>)object toCommand:(DDMidiCommand*)command
{
  [self mapObject:object toCommand:command overwrite:YES];
}

- (void) mapObject:(id <DDMidiCommandResponder> )object toCommand:(DDMidiCommand*)command overwrite:(BOOL)overwrite
{
  if (overwrite)
  {
    id foundobject = nil;
    while ((foundobject = [self objectMappedToCommand:command]))
    {
      [self removeAllMappingsForObject:foundobject];
    }
    [self removeAllMappingsForObject:object];
  }
  
  DDMidiDirectMapping *newMapping = [[DDMidiDirectMapping alloc] init];
  newMapping.command = command;
  newMapping.object = object;
  
  [[self midiMapping] addObject:newMapping];
}

-(id)objectMappedToCommand:(DDMidiCommand*)command
{
  NSArray *mappings = [self midiMapping];
  int index = [mappings indexOfObjectPassingTest:^BOOL(DDMidiDirectMapping *mapping, NSUInteger idx, BOOL *stop) {
    if ([command isKindOfClass:[DDMidiNoteOn class]] || [command isKindOfClass:[DDMidiNoteOff class]])
    {
      if ([(DDMidiNoteOn*)(mapping.command) note] == [(DDMidiNoteOn*)command note])
      {
        return YES;
      }
    }
    return NO;
  }];
  
  if (index == NSNotFound)
    return nil;
  
  DDMidiDirectMapping *directMapping = [mappings objectAtIndex:index];
  id object = [directMapping object];
  
  return object;
}

- (DDMidiCommand*) commandMappedToObject:(id <DDMidiCommandResponder>)object
{
  NSArray *mappings = [self midiMapping];
  
  int index = [mappings indexOfObjectPassingTest:^BOOL(DDMidiDirectMapping *mapping, NSUInteger idx, BOOL *stop) {
    
    if ([mapping.object isEqual:object])
    {
      return YES;
    }
    return NO;
  }];
  
  if (index == NSNotFound)
    return nil;
  
  return [[mappings objectAtIndex:index] command];
}

- (void) removeAllMappingsForObject:(id)object
{
  NSMutableArray *mappings = [self midiMapping];
  
  NSPredicate *objectPredicate = [NSPredicate predicateWithBlock:^BOOL(DDMidiDirectMapping *mapping, NSDictionary *bindings) {
    
    if ([mapping.object isEqual:object])
      return YES;
    
    return NO;
  }];
  
  NSArray *mappingsToObject = [mappings filteredArrayUsingPredicate:objectPredicate];
  [mappings removeObjectsInArray:mappingsToObject];
}

#pragma mark PGMidiDelegate

- (void) midi:(PGMidi*)midi sourceAdded:(PGMidiSource *)source
{
  BOOL shouldConnect = YES;
  if ([self.delegate respondsToSelector:@selector(shouldConnectToSource:)])
  {
    shouldConnect = [self.delegate shouldConnectToSource:source];
  }
  
  if (shouldConnect)
  {
    [source addDelegate:self];
  }
}

- (void) midi:(PGMidi*)midi sourceRemoved:(PGMidiSource *)source
{
  if ([self.delegate respondsToSelector:@selector(didRemoveSource:)])
  {
    [self.delegate didRemoveSource:source];
  }
}

- (void) midi:(PGMidi*)midi destinationAdded:(PGMidiDestination *)destination
{
  if ([self.delegate respondsToSelector:@selector(didAddDestination:)])
  {
    [self.delegate didAddDestination:destination];
  }
}

- (void) midi:(PGMidi*)midi destinationRemoved:(PGMidiDestination *)destination
{
  if ([self.delegate respondsToSelector:@selector(didRemoveDestination:)])
  {
    [self.delegate didRemoveDestination:destination];
  }
}

#pragma mark PGMidiSourceDelegate
- (void) midiSource:(PGMidiSource*)midiSource midiReceived:(const MIDIPacketList *)packetList
{
  const MIDIPacket *packet = &packetList->packet[0];
  for (int i = 0; i < packetList->numPackets; ++i)
  {
    NSArray *commands = [self midiCommandsFromMidiPacket:packet];
    
    for (DDMidiCommand *command in commands)
    {
      if ([self.delegate respondsToSelector:@selector(didReceiveMidiCommand:fromSource:)])
        [self.delegate didReceiveMidiCommand:command fromSource:midiSource];
      
      id <DDMidiCommandResponder> directResponder = [self objectMappedToCommand:command];
      
      if (!!directResponder)
      {
        BOOL shouldForward = YES;
        
        if ([self.delegate respondsToSelector:@selector(shouldForwardMidiCommand:toResponder:)])
          shouldForward = [self.delegate shouldForwardMidiCommand:command toResponder:directResponder];
        
        if (shouldForward)
          [directResponder didReceiveDirectMidiCommand:command];
        
        DDMidiCommand *response = nil;
        
        if ([directResponder respondsToSelector:@selector(responseToDirectMidiCommand:)])
          response = [directResponder responseToDirectMidiCommand:command];
        
        if (response)
          [self sendMidiCommand:response];
        
      }
    }
    packet = MIDIPacketNext(packet);
  }
}

#pragma mark helpers
- (void) attachToAllExistingSources
{
  for (PGMidiSource *source in [self sources])
  {
    [source addDelegate:self];
  }
}

#pragma mark sending Midi

- (void) sendMidiCommand:(DDMidiCommand*)command
{
  [self sendMidiCommand:command toDestinations:pgMidi.destinations];
}

- (void) sendMidiCommand:(DDMidiCommand*)command toDestinations:(NSArray*)destinations
{
  const UInt8 commandBytes[] = { [command channelAndCommandType], [command parameter1], [command parameter2] };
  for (PGMidiDestination *destination in destinations)
  {
    [destination sendBytes:commandBytes size:sizeof(commandBytes)];
  }
}

#pragma mark midi channel
+(int)midiChannel
{
  return [[NSUserDefaults standardUserDefaults] integerForKey:@"selectedMidiChannel"];
}

+(void)setMidiChannel:(int)channel
{
  [[NSUserDefaults standardUserDefaults] setInteger:channel forKey:@"selectedMidiChannel"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
