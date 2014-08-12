//
//  TBAssignment.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 11/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCAssignment.h"
#import "TBCCDeclaration.h"
#import "System.h"
#import "TBCCInputTracer.h"
#import "TBCCVariable.h"

@implementation TBCCAssignment

- (id)initWithTarget:(TBCCVariable *)target source:(TBCCExpression *)source;
{
    self = [super init];
    if (self) {
        self.target = target;
        self.source = source;

        self.source.parent = self;
        [self.children addObject:self.source];
    }
    return self;
}

- (void)dealloc {
    self.target = nil;
    self.source = nil;

    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"[A] %@ = %@", self.description, self.source];
}


- (void)codegen {

    System *system = [System sharedInstance];
//    NSString *desiredType = nil;

        // lookup destination
//
//    TBCCDeclaration *declaration = [system.variables objectForKey:self.target.name];
//    if (!declaration) {
//        NSLog(@"implicit target of '%@'", self.target);
//    }

//    desiredType = declaration.type;

        // write variable


    if ([self.source isKindOfClass:[TBIdentifier class]]) {

        TBIdentifier *identifier = (TBIdentifier *)self.source;
        id identifierValue = [system.variables valueForKey:identifier.value];

        if (!identifierValue) {
            NSString *message = [NSString stringWithFormat:@"undefined variable: '%@'", identifier];
            [[TBCCInputTracer sharedInstance] addError:message onLine:0 column:0];

            identifierValue = [NSNull null];
        }

        [system.variables setObject:identifierValue forKey:self.target.name];
    }
    else if ([self.source isKindOfClass:[TBValue class]]) {
        TBValue *value = (TBValue *)self.source;
        [system.variables setObject:value.value forKey:self.target.name];
    }
    else if ([self.source isKindOfClass:[TBCCSendMessage class]]) {

        [self.source codegen];

        TBCCSendMessage *message = (TBCCSendMessage *)self.source;
        id result = message.result;
        if (!result) {
            NSString *message = [NSString stringWithFormat:@"Assign void to variable %@", self.target];
            [[TBCCInputTracer sharedInstance] addWarning:message onLine:0 column:0];
            result = [NSNull null];
        }

       [system.variables setObject:result forKey:self.target.name];
    }
}

@end
