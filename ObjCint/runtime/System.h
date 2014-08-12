//
//  FrameworkProxy.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 09/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface System : NSObject

+ (id)sharedInstance;

@property (retain) NSMutableDictionary *definitions;
@property (retain) NSMutableDictionary *variables;

@property (retain) NSString *filename;

@end

@interface System (Variables)

- (void)addDefinition:(NSString *)definition;
- (void)addVariable:(NSString *)variable;
- (void)addVariable:(NSString *)variable withValue:(id)value;

@end

@interface System (Support)

- (void)help;
- (void)show:(NSString *)variable;
- (void)showVariables;
- (void)showVariableNames;

- (void)enableDebug;
- (void)releaseVariables;

@end
