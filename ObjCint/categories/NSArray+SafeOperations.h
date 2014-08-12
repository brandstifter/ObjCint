//
//  NSArray+SafeOperations.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 15/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SafeOperations)

- (id)save_objectAtIndex:(NSUInteger)index;

@end
