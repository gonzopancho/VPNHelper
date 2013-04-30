//
//  SimplePingHelper.h
//  PingTester
//
//  Created by Chris Hulbert on 18/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePing.h"

@interface SimplePingHelper : NSObject <SimplePingDelegate>

@property(nonatomic,retain) SimplePing* simplePing;
@property(nonatomic,retain) id target;
@property(nonatomic,assign) SEL sel;
@property(nonatomic,assign) NSInteger index;

- (id)initWithAddress:(NSString*)address target:(id)_target sel:(SEL)_sel index:(NSInteger)_index;
- (void)go;

+ (void)ping:(NSString*)address target:(id)target sel:(SEL)sel;

@end
