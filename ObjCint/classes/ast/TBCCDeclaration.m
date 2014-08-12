//
//  TBDeclaration.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 11/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCDeclaration.h"

#import "System.h"


@implementation TBCCDeclaration


- (id)initWithType:(NSString *)type identifier:(NSString *)identifier;
{
    self = [super init];
    if (self) {
        self.type = type;
        self.identifier = identifier;
    }
    return self;
}

- (void)dealloc {
    self.type = nil;
    self.identifier = nil;

    [super dealloc];
}

- (void)codegen {
    
    System *sys = [System sharedInstance];

    id value = [sys.variables objectForKey:self.identifier];
    if (value) {
        NSString *message = [NSString stringWithFormat:@"redeclaration of variable '%@'", self.identifier];
        [[TBCCInputTracer sharedInstance] addWarning:message onLine:0 column:0];
    }

    value = value ? value : [NSNull null];      // nil -> NSNull
	[sys addVariable:self.identifier withValue:value];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[D] %@ %@", self.type, self.identifier];
}

@end
