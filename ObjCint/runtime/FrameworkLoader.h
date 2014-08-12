//
//  FrameworkLoader.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 14/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrameworkLoader : NSObject

+ (id)sharedInstance;


@property (assign) NSString *currentVersion;
@property (strong) NSString *bundlePath;
@property (strong) NSMutableDictionary *loadedFrameworks;

@property (strong) NSMutableDictionary *versionedClasses;
@property (strong) NSMutableDictionary *retainCounts;


- (Class)currentClassOfClass:(Class)aClass;
- (Class)versionedClassOfClass:(Class)aClass withVersion:(NSString *)version;

@end


@interface NSObject (FrameworkReferenceCounting)


- (id)startFrameworkReferenceCounting;
- (id)stopFrameworkReferenceCounting;

@end

