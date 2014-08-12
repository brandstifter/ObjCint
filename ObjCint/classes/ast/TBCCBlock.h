//
//  TBBlock.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 2/11/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCNode.h"


@class TBCCStatements;

@interface TBCCBlock : TBCCNode

@property (nonatomic, retain) NSMutableArray *statements;

@end
