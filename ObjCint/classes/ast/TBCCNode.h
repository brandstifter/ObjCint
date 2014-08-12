//
//  TBNode.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 2/11/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SyntesizeBlock)();
typedef void(^InheritanceBlock)();


@interface TBCCNode : NSObject

@property (assign) TBCCNode *parent;
@property (strong) NSMutableArray *children;

@property (nonatomic, copy) SyntesizeBlock syntesizeBlock;
@property (nonatomic, copy) InheritanceBlock inheritanceBlock;

//@property (assign) NSUInteger line;
//@property (assign) NSUInteger column;

- (void)codegen;

@end
