//
//  FrameworkLoader.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 14/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "FrameworkLoader.h"
#import <objc/runtime.h>
#import "objc/message.h"

#import "NSArray+SafeOperations.h"


@interface NSObject (FrameworkReferenceCounting) /* HotPlug */

- (id)startFrameworkReferenceCounting;
- (id)stopFrameworkReferenceCounting;

@end


static static void cleanupFARC(void);

#pragma mark -
#pragma mark - implementation FrameworkLoader


/**

 @discussion 
 
 = class loading =
 the properties currentVersionIndex and versions control which versions can
 be load and what is the default to load if requested.

 = memory management =
 the currentClassOfClass: method exchange the implementation of retain and 
 release in. the new added methods are invoked by their known messages. the 
 old implementation is available with an class_prefix.
 

 */
@implementation FrameworkLoader

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
        _currentVersion     = nil;
        _bundlePath         = @"<<the framework bundle to test>>";
        _versionedClasses   = [[NSMutableDictionary alloc] init];
        _retainCounts       = [[NSMutableDictionary alloc] init];
        _loadedFrameworks   = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (BOOL)loadCurrentFramework {

    NSString *filename  = [NSString stringWithFormat:@"__FRAMEWORK_TO_LOAD__%@.framework", self.currentVersion];
    NSString *path      = [_bundlePath stringByAppendingPathComponent:filename];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:path];

    [self.loadedFrameworks setObject:frameworkBundle forKey:filename];

    return [frameworkBundle load];
}

- (Class)currentClassOfClass:(Class)aClass {

    return [self versionedClassOfClass:aClass withVersion:self.currentVersion];
}

- (Class)versionedClassOfClass:(Class)aClass withVersion:(NSString *)version {

    NSString *versionedClassName = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(aClass), version];
    Class versionedClass = NSClassFromString(versionedClassName);

    return versionedClass;
}

@end



#pragma mark -
#pragma mark - === HOT PLUG ===
#pragma mark -


#pragma mark - framework arc implementations

/**
 @discussion

 From Objc Runtime Reference

 The compiler generates an objc_super data structure when it encounters the super keyword as the receiver of a message. It specifies the class definition of the particular superclass that should be messaged.

 ----- 

 */
id imp__FARC__retain(id self, SEL _cmd) {
	
	NSString *className		= NSStringFromClass([self class]);
	FrameworkLoader *loader = [FrameworkLoader sharedInstance];
	
	NSString *instanceKey = [self instanceKey];
	
	NSNumber *retainCount = [loader.retainCounts objectForKey:instanceKey];
	retainCount = @( retainCount.integerValue + 1 );
	[loader.retainCounts setObject:retainCount forKey:instanceKey];

    struct objc_super super = { self, [self superclass] };
	return objc_msgSendSuper(&super, _cmd);
}

/**
 @discussion

 From Objc Runtime Reference

 The compiler generates an objc_super data structure when it encounters the super keyword as the receiver of a message. It specifies the class definition of the particular superclass that should be messaged.

 -----

 */
void imp__FARC__release(id self, SEL _cmd) {
	
	
	NSString *className = NSStringFromClass([self class]);
	FrameworkLoader *loader = [FrameworkLoader sharedInstance];
	
	NSString *instanceKey = [self instanceKey];
	NSNumber *retainCount = [loader.retainCounts objectForKey:instanceKey];
	retainCount = @( retainCount.integerValue - 1 );

	[loader.retainCounts setObject:retainCount forKey:instanceKey];

	struct objc_super super = { self, [self superclass] };
    objc_msgSendSuper(&super, _cmd);
	
	cleanupFARC();
}


NSString *imp__FARC__instanceKey(id self, SEL _cmd) {
	return [[[NSString alloc] initWithFormat:@"%@__%p", NSStringFromClass([self class]), self] autorelease];
}



static void cleanupFARC(void) {

		//
		// determine loaded frameworks
		//
	FrameworkLoader *loader             = [FrameworkLoader sharedInstance];
	NSMutableArray *frameworkBundles    = [[NSMutableArray alloc] init];
	NSMutableArray *versions            = [[NSMutableArray alloc] init];
	
	for (NSString *bundleKey in loader.loadedFrameworks) {
		[frameworkBundles addObject:bundleKey];
	}


	for (NSString *bundleName in frameworkBundles) {
		
		NSArray *bundleNameComponents = [bundleName componentsSeparatedByString:@"."];			// foobar_VV.framework
		NSString *bundleFilename = bundleNameComponents[0];										// foobar_VV
		NSString *version = [[bundleFilename componentsSeparatedByString:@"_"] lastObject];		// VV
		
		[versions addObject:version];
	}
	
	NSLog(@"%@", versions);
	
	
		//
		// remove 0 retainCount objects
		//
	NSMutableArray *zeroInstances = [[NSMutableArray alloc] init];
	for (NSString *instanceKey in loader.retainCounts.allKeys) {
		NSNumber *retainCount = [loader.retainCounts objectForKey:instanceKey];
		if (retainCount.integerValue == 0) {
			[zeroInstances addObject:instanceKey];
		}
	}
	
	for (NSString *instanceKey in zeroInstances) {
		[loader.retainCounts removeObjectForKey:instanceKey];
		NSString *classKey = [[instanceKey componentsSeparatedByString:@"__"] objectAtIndex:0];
		[loader.versionedClasses removeObjectForKey:classKey];
	}
}


#pragma mark - NSObject additions

@implementation NSObject (FrameworkReferenceCounting)

//static NSMutableDictionary *arcClasses = nil;

- (id)startFrameworkReferenceCounting {

    Class aClass = [self class];
    Class arcClass = nil;

        // check for already under arc
    if (class_getMethodImplementation(aClass, @selector(retain))
        == (IMP) imp__FARC__retain)
    {
        return self;
    }

    NSString *className     = NSStringFromClass(aClass);
	FrameworkLoader *loader = [FrameworkLoader sharedInstance];
	
    if (!className)     return nil;

	NSValue *classValue = [loader.versionedClasses objectForKey:NSStringFromClass(arcClass)];
	[classValue getValue:&arcClass];
    if (!arcClass) {

        NSString *arcClassName = [@[className, @"farc", @"V1"] componentsJoinedByString:@"_"];
        arcClass = objc_allocateClassPair(aClass, [arcClassName UTF8String], 0);

            // retrieve old implementations
        IMP old_retain  = class_getMethodImplementation(aClass, @selector(retain));
        IMP old_release = class_getMethodImplementation(aClass, @selector(release));

            // apply old implementation to subclass with an prefix
        class_addMethod(arcClass, @selector(old_retain),   old_retain,   "@@:");
        class_addMethod(arcClass, @selector(old_release),  old_release,  "v@:");

            // replace old implemantation
        class_addMethod(arcClass, @selector(retain), (IMP) &imp__FARC__retain, "@@:");
        class_addMethod(arcClass, @selector(release), (IMP) &imp__FARC__release, "v@:");
		class_addMethod(arcClass, @selector(instanceKey), (IMP) &imp__FARC__instanceKey, "@@:");

            // tell it the objc runtime
        objc_registerClassPair(arcClass);
		classValue = [NSValue value:arcClass withObjCType:@encode(Class)];
        [loader.versionedClasses setObject:classValue forKey:NSStringFromClass(arcClass)];     // key must fullfill the NSCoping
    }

    object_setClass(self, arcClass);       // only save if no instance variables were added
                                           // try extra_bytes instance
	[loader.retainCounts setObject:@1 forKey:[self instanceKey]];
	
    return self;
}

- (id)stopFrameworkReferenceCounting {

        // check for already under arc
    if (class_getMethodImplementation([self class], @selector(retain))
        != (IMP) imp__FARC__retain)
    {
        return self;
    }

    object_setClass(self, [self superclass]);
    return self;
}

@end
