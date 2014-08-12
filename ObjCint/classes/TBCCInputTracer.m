//
//  TBInputTracer.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 11/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCInputTracer.h"


typedef NS_ENUM(NSInteger, TBInterpreterMessageType) {
    TBInterpreterMessageType_Warning,
    TBInterpreterMessageType_Error
};


@interface TBCCInterpreterMessage ()

- (id)initWithLine:(NSInteger)line column:(NSInteger)column message:(NSString *)message type:(TBInterpreterMessageType)type;

@property (readwrite, assign) NSInteger line;
@property (readwrite, assign) NSInteger column;

@property (readwrite, retain) NSString *message;
@property (assign) TBInterpreterMessageType type;

@end


@implementation TBCCInterpreterMessage

#pragma mark - Object Lifecycle

- (id)initWithLine:(NSInteger)line column:(NSInteger)column message:(NSString *)message type:(TBInterpreterMessageType)type {

    self = [super init];
    if (self) {
        _column = column;
        _line   = line;
        _message = message;
        _type = type;
    }
    return self;
}

- (void)dealloc {
    [_message release], _message = nil;
    [super dealloc];
}

#pragma mark - Overrides

- (NSString *)description {
    return [NSString stringWithFormat:@"%ld [%lu:%lu] : %@",
            self.type,
            self.line,
            self.column,
            self.message];
}

@end



@implementation TBCCInputTracer

#pragma mark - Object Lifecycle

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
        _errors     = [[NSMutableArray alloc] init];
        _warnings   = [[NSMutableArray alloc] init];
        _lines      = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addParsedString:(NSString *)parsedString {

    NSArray *newLines = [parsedString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    if (newLines.count == 1) {      // no newline found
        [self appendTextToCurrentLine:parsedString];
    }
    else if (newLines.count > 1) {
        int ii = 0;

        NSString *newLine = [newLines objectAtIndex:ii];
        while ( newLine != nil ) {

            (ii == 0)
                ? [self appendTextToCurrentLine:newLine]
                : [self addLine:newLine];

            ii++;
            newLine = ii < newLines.count ? [newLines objectAtIndex:ii] : nil;
        }
    }
    else {
            // 0
        NSLog(@"shouldn't happen!");
    }
}

- (void)addLine:(NSString *)line {
    [self.lines addObject:line];
}

- (void)appendTextToCurrentLine:(NSString *)text {
    NSString *lastLine = self.lines.lastObject;

    if (!lastLine) {     // the first line
        [self addLine:text];
        return;
    }

    lastLine = [lastLine stringByAppendingString:text];
    [self.lines removeLastObject];
    [self.lines addObject:lastLine];
}


- (void)addWarning:(NSString *)warning onLine:(NSInteger)line column:(NSInteger)column {

    TBCCInterpreterMessage *message = [[TBCCInterpreterMessage alloc] initWithLine:line
                                                                        column:column
                                                                       message:warning
                                                                          type:TBInterpreterMessageType_Warning];

    [self.warnings addObject:message];
    [message release];
}

- (void)addError:(NSString *)error onLine:(NSInteger)line column:(NSInteger)column {

    TBCCInterpreterMessage *message = [[TBCCInterpreterMessage alloc] initWithLine:line
                                                                        column:column
                                                                       message:error
                                                                          type:TBInterpreterMessageType_Error];

    [self.errors addObject:message];
    [message release];
}


@end
