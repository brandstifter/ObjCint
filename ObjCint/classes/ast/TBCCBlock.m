//
//  TBBlock.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 2/11/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCBlock.h"

#import "System.h"

@implementation TBCCBlock

- (id)init
{
    self = [super init];
    if (self) {
        self.statements = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    self.statements = nil;

    [super dealloc];
}

- (void)codegen {
	
//	for (TBCCNode *node in self.statements)
//        [node codegen];
}

@end
