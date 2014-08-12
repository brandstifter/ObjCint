//
//  TBCCVariable.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 16/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCVariable.h"

@implementation TBCCVariable

#pragma mark - Object Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.name = nil;
    }
    return self;
}

- (id)initWithName:(NSString *)name {

    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

- (void)dealloc {
    self.name = nil;

    [super dealloc];
}

#pragma mark - overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"V: %@", self.name];
}

@end
