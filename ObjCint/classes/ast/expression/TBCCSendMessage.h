//
//  TBSendMessage.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 12/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCExpression.h"
#import "TBCCVariable.h"

@interface TBCCSendMessage : TBCCExpression

- (id)initWithTarget:(TBCCVariable *)target methodSignature:(TBCCMethodSignature *)methodSignature;

@property (retain) TBCCMethodSignature    *methodSignature;
@property (retain) TBCCVariable         *target;

@property (readonly, retain)    id result;
@property (readonly, assign)    BOOL hasResult;


@end
