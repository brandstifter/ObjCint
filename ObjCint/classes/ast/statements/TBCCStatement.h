//
//  TBCCStatement.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 16/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCNode.h"

@interface TBCCStatement : TBCCNode

@property (retain) TBCCNode *node;

- (id)initWithNode:(TBCCNode *)node;

@end
