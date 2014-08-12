//
//  NSDictionary+SafeOperations.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 16/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "NSDictionary+SafeOperations.h"

@implementation NSDictionary (SafeOperations)

- (void)save_setValue:(id)anObject forKey:(NSString *)aKey {

    anObject = anObject ? anObject : [NSNull null];
    [self setValue:anObject forKey:aKey];
}

@end
