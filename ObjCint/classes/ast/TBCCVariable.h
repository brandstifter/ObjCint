//
//  TBCCVariable.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 16/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCNode.h"
#import "TBValue.h"

@interface TBCCVariable : TBCCNode

@property (retain) NSString *name;
@property (retain) TBValue *value;

- (id)initWithName:(NSString *)name;

@end
