//
//  AkiVPNAppDelegate.h
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "AkiVPNModels.h"

@interface AkiVPNAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
	
	AkiServerInfo *akiServerInfo;
	AkiDataInfo *akiDataInfo;
	AkiPurchaseInfo *akiPurchaseInfo;
	AkiUsageInfo *akiUsageInfo;
	AkiHelpInfo *akiHelpInfo;
	AkiChatInfo *akiChatInfo;
	AkiMessageInfo *akiMessageInfo;
	
	NSTimer *gwfTimer;
	
	NSTimer *serverTimer;
	NSTimer *dataTimer;
	NSTimer *purchaseTimer;
	NSTimer *usageTimer;
	NSTimer *helpTimer;
	NSTimer *chatTimer;
	NSTimer *messageTimer;
	
	UIImageView *splashView;
	NSTimer *firstLoadingTimer;
	NSInteger firstLoadingTimeout;
	NSInteger isSplashUsed;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) AkiServerInfo *akiServerInfo;
@property (nonatomic, retain) AkiDataInfo *akiDataInfo;
@property (nonatomic, retain) AkiPurchaseInfo *akiPurchaseInfo;
@property (nonatomic, retain) AkiUsageInfo *akiUsageInfo;
@property (nonatomic, retain) AkiHelpInfo *akiHelpInfo;
@property (nonatomic, retain) AkiChatInfo *akiChatInfo;
@property (nonatomic, retain) AkiMessageInfo *akiMessageInfo;
@property NSInteger firstLoadingTimeout;

- (void)secondPhaseContruct;

@end

