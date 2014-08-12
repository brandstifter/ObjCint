//
//  TBNode.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 2/11/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCNode.h"

@implementation TBCCNode

#pragma mark - Object Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.parent = nil;
        self.children = [[NSMutableArray alloc] init];
    }

    NSLog(@"%@::%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    return self;
}

- (void)dealloc {
	self.parent = nil;
	self.children = nil;
	
	[super dealloc];
}


- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] allocWithZone:zone] init];

    if (copy) {

        [copy setSyntesizeBlock:[self.syntesizeBlock copy]];
        [copy setInheritanceBlock:[self.inheritanceBlock copy]];
    }

    return copy;
}


#pragma mark -

- (void)codegen {
    NSLog(@"override");
}

- (void)inheritance {
    NSLog(@"override");
}

- (void)syntesize {
    NSLog(@"override");
}

@end
