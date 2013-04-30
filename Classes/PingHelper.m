//
//  PingHelper.m
//  AkiVPN
//
//  Created by luo  on 12-2-4.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "PingHelper.h"

@implementation PingTask

@synthesize index;
@synthesize success;
@synthesize delay;

@end


@implementation PingHelper

@synthesize target, sel, sel2;

- (PingHelper *)initWithId:(id)_target itemSel:(SEL)_sel allSel:(SEL)_sel2
{
	self = [super init];
	if (self)
	{
		arrSimplePingHelper = [[NSMutableArray alloc] init];
		iCount = 0;
		iStop = 0;
		target = _target;
		sel = _sel;
		sel2 = _sel2;
		
		secFormatter = [[NSDateFormatter alloc] init];
		[secFormatter setDateFormat:@"s"];
		mSecFormatter = [[NSDateFormatter alloc] init];
		[mSecFormatter setDateFormat:@"SSS"];
	}
	return self;
}

- (void)addPingTask:(NSString *)strAddress atIndex:(NSInteger)iIndex
{
	SimplePingHelper *simplePingHelper = [[SimplePingHelper alloc] initWithAddress:strAddress target:self sel:@selector(finishedPingTaskAtIndex:) index:iCount];
	[arrSimplePingHelper addObject:simplePingHelper];
	[simplePingHelper release];
	iCount ++;
}

- (void)start
{
	for (int i = 0; i < [arrSimplePingHelper count]; i ++)
	{
		SimplePingHelper* simplePingHelper = [arrSimplePingHelper objectAtIndex:i];
		[simplePingHelper go];
	}
	NSDate *date = [NSDate date];
	iStartTime = 1000 * [[secFormatter stringFromDate:date] intValue] + [[mSecFormatter stringFromDate:date] intValue];
}

- (void)stop
{
	iStop = 1;
}

- (void)finishedPingTaskAtIndex:(NSNumber *)iIndex
{
	if (iStop == 1)
		return;
	PingTask *pingTask = [[PingTask alloc] init];
	if ([iIndex intValue] >= 0)
	{
		[pingTask setIndex:[iIndex intValue]];
		[pingTask setSuccess:1];
	}
	else
	{
		[pingTask setIndex:(-[iIndex intValue] - 1)];
		[pingTask setSuccess:0];
	}
	
	NSDate *date = [NSDate date];
	iEndTime = 1000 * [[secFormatter stringFromDate:date] intValue] + [[mSecFormatter stringFromDate:date] intValue];
	NSInteger iInterval = iEndTime - iStartTime;
	if (iInterval < 0)
		iInterval += 60000;
	[pingTask setDelay:iInterval];
	[pingTask autorelease];
	
	[target performSelector:sel withObject:pingTask];
	iCount --;
	if (iCount == 0)
		[self allTasksFinished];
}

- (void)allTasksFinished
{
	if (iStop == 1)
		return;
	[target performSelector:sel2 withObject:nil];
}

- (void)dealloc
{
	[arrSimplePingHelper release];
	[secFormatter release];
	[mSecFormatter release];
	[super dealloc];
}
	
@end
