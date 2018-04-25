//
//  FrameworkProxy.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 09/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "System.h"

#import "NSDictionary+SafeOperations.h"
#import "FrameworkLoader.h"



@implementation System

#pragma mark - object lifecycle

+ (id)sharedInstance {

    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _variables      = [[NSMutableDictionary alloc] init];
        _definitions    = [[NSMutableDictionary alloc] init];
		
        [self initDefaultVariables];
    }
    return self;
}

- (void)dealloc {
    self.variables   = nil;
    self.definitions =  nil;

    [super dealloc];
}

- (void)initDefaultVariables {

	[self.variables setObject:[FrameworkLoader sharedInstance] forKey:@"framework"];
	[self.variables setObject:[NSDate date]	forKey:@"initDate"];
}
@end



@implementation System (Variables)

- (void)addDefinition:(NSString *)definition {
    [self.definitions save_setValue:nil forKey:definition];
}

- (void)addVariable:(NSString *)variable {
    [self addVariable:variable withValue:nil];
}

- (void)addVariable:(NSString *)variable withValue:(id)value {
    [self.variables save_setValue:value forKey:variable];
}
@end


@implementation System (Support)

- (void)enableDebug {
	// [[TBLogger sharedInstance] setDebugLevelMask:TBDebugLevelAllMask];
}

- (void)help {
    NSLog(
@"                                                          \n"
@"          @interface System (Support)                     \n"
@"          - [system help]                                 \n"
@"          - [system show: \"variable\"];    // Log the variables value     \n"
@"          - [system showall];               // Log the variables value     \n"
@"          - [system shownames];             // Log the variables value     \n"	    
@"          - [system releaseVariables];      // Cleanup variable space      \n"
@"\n"
    );
}

- (void)show:(NSString *)variable {

	NSObject *o = [self.variables valueForKey:variable];
	NSLog(@"%@", o);
}

- (void)showVariables {
	
    for (NSString *key in self.variables.allKeys) {
        NSObject *o = [self.variables valueForKey:key];
        NSLog(@">  %@", o);
    }
}

- (void)showVariableNames {

    for (NSString *key in self.variables.allKeys)
        NSLog(@">  %@", key);
}

- (void)releaseVariables {
    [self.variables removeAllObjects];
}

@end
