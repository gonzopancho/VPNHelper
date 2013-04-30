//
//  AKIUIView.m
//  AkiVPN
//
//  Created by luo  on 12-2-10.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "AKIUIView.h"

@implementation UIViewDelegate

-(id) initWithRunLoop: (CFRunLoopRef)runLoop 
{
	if (self = [super init]) currentLoop = runLoop;
	return self;
}

-(void) animationFinished: (id) sender
{
	CFRunLoopStop(currentLoop);
}
@end

@implementation UIView (ModalAnimationHelper)
+ (void) commitModalAnimations
{
	CFRunLoopRef currentLoop = CFRunLoopGetCurrent();
	UIViewDelegate *uivdelegate = [[UIViewDelegate alloc] initWithRunLoop:currentLoop];
	[UIView setAnimationDelegate:uivdelegate];
	[UIView setAnimationDidStopSelector:@selector(animationFinished:)];
	[UIView commitAnimations];
	CFRunLoopRun();
	[uivdelegate release];
}
@end
