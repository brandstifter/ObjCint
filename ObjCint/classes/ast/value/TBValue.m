//
//  TBValue.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 11/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBValue.h"

@implementation TBValue

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@] %@", NSStringFromClass(self.class), self.value];
}

@end
