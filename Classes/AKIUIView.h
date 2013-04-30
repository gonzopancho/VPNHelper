//
//  AKIUIView.h
//  AkiVPN
//
//  Created by luo  on 12-2-10.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView (ModalAnimationHelper)

+ (void) commitModalAnimations;

@end

@interface UIViewDelegate : NSObject
{
	CFRunLoopRef currentLoop;
}

@end
