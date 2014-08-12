//
//  TBInputTracer.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 11/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TBCCInterpreterMessage : NSObject

@property (readonly, assign) NSInteger line;
@property (readonly, assign) NSInteger column;

@property (readonly, retain) NSString *message;

@end

@interface TBCCInputTracer : NSObject

+ (id)sharedInstance;

@property (readonly, retain) NSMutableArray *lines;

@property (readonly, retain) NSMutableArray *warnings;
@property (readonly, retain) NSMutableArray *errors;

- (void)addParsedString:(NSString *)parsedString;
- (void)addWarning:(NSString *)warning onLine:(NSInteger)line column:(NSInteger)column;
- (void)addError:(NSString *)error onLine:(NSInteger)line column:(NSInteger)column;

@end
