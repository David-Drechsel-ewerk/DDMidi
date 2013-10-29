//
//  DDMidiDirectMapping.m
//  Audiosamples
//
//  Created by David Drechsel on 15.08.13.
//  Copyright (c) 2013 EWERK IT GmbH. All rights reserved.
//

#import "DDMidiDirectMapping.h"

@implementation DDMidiDirectMapping
{
  id _uniqueIdentifier;
}
@synthesize command, object, objectIdentifier = _uniqueIdentifier;

#pragma mark NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
  [aCoder encodeObject:self.command forKey:@"command"];
  id identifier = [self.object uniqueIdentifier];
  [aCoder encodeObject:identifier forKey:@"identifier"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super init])
  {
    self.command =  [aDecoder decodeObjectForKey:@"command"];
    id identifier = [aDecoder decodeObjectForKey:@"identifier"];
    _uniqueIdentifier = identifier;
  }
  return self;
}

@end
