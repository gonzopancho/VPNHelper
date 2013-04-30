//
//  AkiVPNAppDelegate.m
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AkiVPNAppDelegate.h"

@implementation AkiVPNAppDelegate

@synthesize window, splashView, navigationController, firstLoadingTimeout;
@synthesize akiServerInfo, akiDataInfo, akiPurchaseInfo, akiUsageInfo, akiHelpInfo, akiChatInfo, akiMessageInfo;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	isSplashUsed = 0;
    
	navigationController = [[UINavigationController alloc] initWithRootViewController:
							[[[RootViewController alloc] init] autorelease]];
	//navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	
	UIImageView *navBarView;
	UIImage *imgNavBar = [UIImage imageNamed:@"navbar"];
	navBarView = [[UIImageView alloc] initWithImage:imgNavBar];
	navBarView.frame = CGRectMake(0.f, 0.f, navigationController.navigationBar.frame.size.width, navigationController.navigationBar.frame.size.height);
	navBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[navigationController.navigationBar addSubview:navBarView];
	[navigationController.navigationBar sendSubviewToBack:navBarView];
	[navBarView release];
	
	if (isSplashUsed == 1)
	{
		UIImage *slashImage = [UIImage imageNamed:@"Default"];
		splashView = [[UIImageView alloc] initWithImage:slashImage];
		splashView.frame = CGRectMake(0.f, 0.f, 320.0f, 480.0f);//navigationController.navigationBar.frame.size.width, navigationController.navigationBar.frame.size.height);
		[window addSubview:splashView];
		[window makeKeyAndVisible];
		[window layoutSubviews];
	}
	else
	{
		[window addSubview:navigationController.view];
		[window makeKeyAndVisible];
		[window layoutSubviews];
	}

	g_akiGWFInfo = [[AkiGWFInfo alloc] init];
	[g_akiGWFInfo initBaseURL];
	[g_akiGWFInfo updateBaseURL];

	gwfTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:g_akiGWFInfo selector:@selector(handleTimer:) userInfo:nil repeats:YES];

	g_akiUserInfo = [[AkiUserInfo alloc] init];
	[g_akiUserInfo initUserID];
	
	akiServerInfo = [[AkiServerInfo alloc] init];
	akiDataInfo = [[AkiDataInfo alloc] init];
	akiPurchaseInfo = [[AkiPurchaseInfo alloc] init];
	akiUsageInfo = [[AkiUsageInfo alloc] init];
	akiHelpInfo = [[AkiHelpInfo alloc] init];
	akiChatInfo = [[AkiChatInfo alloc] init];
	akiMessageInfo = [[AkiMessageInfo alloc] init];
	//Data Structure Load Finished
	
	[akiServerInfo downloadInformation];
	[akiDataInfo downloadInformation];
	[akiPurchaseInfo downloadInformation];
	[akiUsageInfo downloadInformation];
	[akiHelpInfo downloadInformation];
	[akiChatInfo downloadInformation];
	[akiMessageInfo downloadInformation];
	
	if (isSplashUsed == 0)
	{
		[self secondPhaseContruct];
		return YES;
	}
	else
	{
		firstLoadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
		firstLoadingTimeout = 0;
		return YES;
	}
}

- (void)handleTimer:(NSTimer *)timer
{
	//[firstLoadingTimer release];
	//[self secondPhaseContruct];
	//return;
	if ([akiServerInfo hasBeenLoaded] + [akiDataInfo hasBeenLoaded] + [akiPurchaseInfo hasBeenLoaded] + [akiUsageInfo hasBeenLoaded] + 
		[akiHelpInfo hasBeenLoaded] + [akiChatInfo hasBeenLoaded] + [akiMessageInfo hasBeenLoaded] > 4)
	{
		[firstLoadingTimer release];
		[self secondPhaseContruct];
	}
	else
	{
		firstLoadingTimeout ++;
		if (firstLoadingTimeout > 50)
		{
			[firstLoadingTimer invalidate];
			[window addSubview:navigationController.view];
			[splashView removeFromSuperview];
			[splashView release];
			[self secondPhaseContruct];
		}
	}
}

- (void)secondPhaseContruct
{
	serverTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:akiServerInfo selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	dataTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:akiDataInfo selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	purchaseTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:akiPurchaseInfo selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	usageTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:akiUsageInfo selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	helpTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:akiHelpInfo selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	chatTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:akiChatInfo selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	messageTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:akiMessageInfo selector:@selector(handleTimer:) userInfo:nil repeats:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
	[akiServerInfo release];
	[akiDataInfo release];
	[akiPurchaseInfo release];
	[akiUsageInfo release];
	[akiHelpInfo release];
	[akiMessageInfo release];
	
	[g_akiGWFInfo release];
	[g_akiUserInfo release];
	
	
    [super dealloc];
}


@end
