//
//  TBSendMessage.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 12/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCSendMessage.h"
#import "System.h"


@interface TBCCSendMessage ()

@property (readwrite, retain)    id result;

@end

@implementation TBCCSendMessage


- (id)initWithTarget:(TBCCVariable *)target methodSignature:(TBCCMethodSignature *)methodSignature {

    self = [super init];
    if (self) {
        self.methodSignature    = methodSignature;
        self.target             = target;
        self.result             = nil;

        self.methodSignature.parent = self;
        self.target.parent = self;

    }
    return self;
}

- (void)dealloc {
    self.result = nil;
    self.methodSignature = nil;
    self.target = nil;

    [super dealloc];
}

- (void)codegen {

    System *system = [System sharedInstance];

    if (!self.methodSignature) {
        NSLog(@"warning methodSignatur");
        return;
    }

    if (!self.target) {
        NSLog(@"warning target");
        return;
    }

    self.result = nil;
	NSObject *target = nil;
	Class targetClass = nil;  // ??? strange
	
	if ([self.target.name isEqualToString:@"system"]) {
		target = system;
		targetClass = [System class];
	}
	else {
		target = [system.variables objectForKey:self.target.name];
		targetClass = [target class];
	}
	
	
	if (!target || !targetClass)
		return;
	
    NSInvocation *anInvocation = [self.methodSignature invocationForTargetClass:targetClass];
    if (!anInvocation) {
		NSLog(@"methodSignature: '%@' not found for targetClass: '%@'", self.methodSignature, NSStringFromClass(targetClass));
        return;
	}
	
    anInvocation.target = target; // = self.target
    [anInvocation invoke];

    NSString *returnType = [NSString stringWithUTF8String:anInvocation.methodSignature.methodReturnType];
    if ([returnType isEqualToString:@"v"]) {
            // void
    }
    if ([returnType isEqualToString:@"@"]) {
            // string
        [anInvocation getReturnValue:&_result];
    }
    if ([returnType isEqualToString:@"c"]) {

            // BOOL, ... ???
        BOOL boolResult;
        [anInvocation getReturnValue:&boolResult];
        self.result = [NSNumber numberWithBool:boolResult];
    }
}

- (BOOL)hasResult {
    return !self.result;
}

@end
