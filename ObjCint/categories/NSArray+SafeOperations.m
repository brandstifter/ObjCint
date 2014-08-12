//
//  NSArray+SafeOperations.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 15/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "NSArray+SafeOperations.h"

@implementation NSArray (SafeOperations)

- (id)save_objectAtIndex:(NSUInteger)index {

    if (index > self.count-1)
        return nil;
    return [self objectAtIndex:index];
}

@end
