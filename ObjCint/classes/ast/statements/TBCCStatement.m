//
//  TBCCStatement.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 16/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCStatement.h"

@implementation TBCCStatement


- (id)initWithNode:(TBCCNode *)node
{
    self = [super init];
    if (self) {
        self.node = node;
    }
    return self;
}

- (void)dealloc {
	self.node = nil;
	
	[super dealloc];
}

- (void)codegen {
    [self.node codegen];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ node: %@", NSStringFromClass([self class]), self.node];
}

@end
