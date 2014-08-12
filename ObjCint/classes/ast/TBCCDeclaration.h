//
//  TBDeclaration.h
//  ObjCint
//
//  Created by Thomas Brandstätter on 11/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import "TBCCNode.h"

@interface TBCCDeclaration : TBCCNode

- (id)initWithType:(NSString *)type identifier:(NSString *)identifier;

@property (retain) NSString *type;
@property (retain) NSString *identifier;

@end
