//
//  NSDictionary+SafeOperations.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 16/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeOperations)

- (void)save_setValue:(id)anObject forKey:(NSString *)aKey;

@end
