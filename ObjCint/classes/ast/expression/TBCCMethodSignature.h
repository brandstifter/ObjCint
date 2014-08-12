//
//  TBStatement.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 2/11/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCNode.h"

@interface TBCCMethodSignature : TBCCNode

@property (nonatomic, retain)	NSMutableArray *parameterNames;
@property (nonatomic, retain)	NSMutableArray *parameterValues;

@property (readonly)			BOOL hasParameters;
@property (readonly)			NSInteger parametersCount;

- (void)addParameterList:(NSMutableArray *)parameterList;

- (NSString *)selectorString;
- (NSInvocation *)invocationForTargetClass:(Class)targetClass; 

@end
