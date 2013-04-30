//
//  PingHelper.h
//  AkiVPN
//
//  Created by luo  on 12-2-4.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimplePingHelper.h"

@interface PingTask : NSObject
{
	NSInteger index;
	NSInteger success;
	NSInteger delay;
}

@property NSInteger index;
@property NSInteger success;
@property NSInteger delay;

@end


@interface PingHelper : NSObject {
	NSInteger iStartTime;
	NSInteger iEndTime;
	NSMutableArray *arrSimplePingHelper;
	NSInteger iCount;
	NSInteger iStop;
	
	NSDateFormatter *secFormatter;
	NSDateFormatter *mSecFormatter;
	
	id target;
	SEL sel;
	SEL sel2;
}

@property(nonatomic,retain) id target;
@property(nonatomic,assign) SEL sel;
@property(nonatomic,assign) SEL sel2;

//@property(nonatomic, retain)
- (PingHelper *)initWithId:(id)_target itemSel:(SEL)_sel allSel:(SEL)_sel2;
- (void)addPingTask:(NSString *)strAddress atIndex:(NSInteger)iIndex;
- (void)start;
- (void)stop;
- (void)finishedPingTaskAtIndex:(NSNumber *)iIndex;
- (void)allTasksFinished;

@end
