//
//  TBStatement.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 2/11/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCMethodSignature.h"
#import "System.h"


@implementation TBCCMethodSignature


- (id)init
{
    self = [super init];
    if (self) {
        self.parameterNames     = [[NSMutableArray alloc] init];
		self.parameterValues    = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    self.parameterNames = nil;
    self.parameterValues = nil;

    [super dealloc];
}

- (void)addParameterList:(NSMutableArray *)parameterList {
	
	NSInteger parametersPassed = parameterList.count;
	
	switch (parametersPassed) {
		case 0:
			return;
			break;
			
		case 1:
			[self.parameterNames addObject:parameterList[0]];
			break;
			
		default:
		{
			int ii;
			for (ii = 0; ii < parametersPassed; ii+=2) {
				[self.parameterNames addObject:parameterList[ii]];
				[self.parameterValues addObject:parameterList[ii+1]];
			}
		}
			break;
	}
}

- (BOOL)hasParameters {
	return (self.parameterNames.count == 1 && self.parameterValues.count == 0);
}

- (NSInteger)parametersCount {
	return self.parameterValues.count;
}


- (NSString *)selectorString {

	if (self.parameterNames.count == 0)
		return @"";
		
	NSMutableString *ret = [[[NSMutableString alloc] init] autorelease];
	
	// handle first param
	[ret appendString:self.parameterNames[0]];
	if (self.parameterValues.count > 0)
		[ret appendString:@":"];
	
	// handle more params if any
	int ii;
	for (ii = 1; ii < self.parameterNames.count; ii++) {
		[ret appendFormat:@"%@:", [self.parameterNames objectAtIndex:ii]];
	}
	
	return ret;
}


- (NSInvocation *)invocationForTargetClass:(Class)targetClass {
	
	SEL theSelector;
	NSMethodSignature *aSignature;
	NSInvocation *anInvocation;

	theSelector = NSSelectorFromString(self.selectorString);
	aSignature = [targetClass instanceMethodSignatureForSelector:theSelector];

	if (!aSignature)
		return nil;
	
	anInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
	anInvocation.selector = theSelector;
	
	int ii = 2;
	for (TBValue *value in self.parameterValues) {
        id realValue = value.value;
		[anInvocation setArgument:&realValue atIndex:ii];
	}
	
	return anInvocation;
}

- (void)codegen { /* intended to be empty */ }

- (NSString *)description {
    return self.selectorString;
}

@end
