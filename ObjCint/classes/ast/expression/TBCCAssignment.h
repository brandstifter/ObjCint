//
//  TBAssignment.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 11/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCExpression.h"
#import "TBCCVariable.h"

@interface TBCCAssignment : TBCCExpression

- (id)initWithTarget:(TBCCVariable *)target source:(TBCCExpression *)source;

@property (retain)  TBCCVariable *target;
@property (retain)  TBCCExpression *source;

@end
