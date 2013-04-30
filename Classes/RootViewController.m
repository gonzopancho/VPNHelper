//
//  RootViewController.m
//  @rigoneri
//  
//  Copyright 2010 Rodrigo Neri
//  Copyright 2011 David Jarrett
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "RootViewController.h"
#import "MyLauncherItem.h"
#import "CustomBadge.h"
#import "ItemViewController.h"

#import "AKIConnectViewController.h"
#import "AKIDataPlanViewController.h"
#import "AKIPurchaseViewController.h"
#import "AKIServerInfoViewController.h"
#import "AKIDataUsageViewController.h"
//#import "AKIMultipalViewController.h"
#import "AKIMessageViewController.h"
#import "AKIHelpViewController.h"
#import "AKIAboutUsViewController.h"
#import "AKIDevelopViewController.h"

@implementation RootViewController

-(void)loadView
{    
	[super loadView];
	
	UIImageView *backGroundView;
	UIImage *imgBackGround = [UIImage imageNamed:@"background"];
	backGroundView = [[UIImageView alloc] initWithImage:imgBackGround];
	backGroundView.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
	backGroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:backGroundView];
	[self.view sendSubviewToBack:backGroundView];
	[backGroundView release];
	
	UIImageView *titleView;
	UIImage *titleImage = [UIImage imageNamed:@"nav_logo"];
	titleView = [[UIImageView alloc] initWithImage:titleImage];
	titleView.frame = CGRectMake(103.f, 26.f, 110.f, 32.f);
	[self.navigationController.view addSubview:titleView];
	
    //self.title = @"VPN Helper";
	self.title = @"";
    
    //[[self appControllers] setObject:[ItemViewController class] forKey:@"ItemViewController"];
	[[self appControllers] setObject:[AKIConnectViewController class] forKey:@"AKIConnectViewController"];
	[[self appControllers] setObject:[AKIDataPlanViewController class] forKey:@"AKIDataPlanViewController"];
	[[self appControllers] setObject:[AKIDataUsageViewController class] forKey:@"AKIDataUsageViewController"];
	[[self appControllers] setObject:[AKIPurchaseViewController class] forKey:@"AKIPurchaseViewController"];
	[[self appControllers] setObject:[AKIServerInfoViewController class] forKey:@"AKIServerInfoViewController"];
	//[[self appControllers] setObject:[AKIMultipalViewController class] forKey:@"AKIMultipalViewController"];
	[[self appControllers] setObject:[AKIMessageViewController class] forKey:@"AKIMessageViewController"];
	[[self appControllers] setObject:[AKIHelpViewController class] forKey:@"AKIHelpViewController"];
	[[self appControllers] setObject:[AKIAboutUsViewController class] forKey:@"AKIAboutUsViewController"];
	[[self appControllers] setObject:[AKIDevelopViewController class] forKey:@"AKIDevelopViewController"];
    
    //Add your view controllers here to be picked up by the launcher; remember to import them above
	//[[self appControllers] setObject:[MyCustomViewController class] forKey:@"MyCustomViewController"];
	//[[self appControllers] setObject:[MyOtherCustomViewController class] forKey:@"MyOtherCustomViewController"];
	
	if(![self hasSavedLauncherItems])
	{
		[self.launcherView setPages:[NSMutableArray arrayWithObjects: 
                                     [NSMutableArray arrayWithObjects: 
                                      [[[MyLauncherItem alloc] initWithTitle:@"Connect to VPN"
                                                                 iPhoneImage:@"icon-how-to" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIConnectViewController" 
                                                                 targetTitle:@"Connect to VPN"
                                                                   deletable:NO] autorelease],
									  
                                      [[[MyLauncherItem alloc] initWithTitle:@"Data Plan"
                                                                 iPhoneImage:@"icon-plan" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIDataPlanViewController" 
                                                                 targetTitle:@"Data Plan" 
                                                                   deletable:NO] autorelease],
									  
									  [[[MyLauncherItem alloc] initWithTitle:@"Usage Log"
                                                                 iPhoneImage:@"icon-usage" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIDataUsageViewController" 
                                                                 targetTitle:@"Usage Log"
                                                                   deletable:YES] autorelease],
									  
                                      [[[MyLauncherItem alloc] initWithTitle:@"Purchase"
                                                                 iPhoneImage:@"icon-purchase" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIPurchaseViewController" 
                                                                 targetTitle:@"Purchase"
                                                                   deletable:YES] autorelease],
									  
                                      [[[MyLauncherItem alloc] initWithTitle:@"Server Status"
                                                                 iPhoneImage:@"icon-servers" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIServerInfoViewController" 
                                                                 targetTitle:@"Server Status"
                                                                   deletable:NO] autorelease],
									  
                                      [[[MyLauncherItem alloc] initWithTitle:@"Messages"
                                                                 iPhoneImage:@"icon-messages" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIMessageViewController" 
                                                                 targetTitle:@"Messages"
                                                                   deletable:NO] autorelease],
									  
                                      [[[MyLauncherItem alloc] initWithTitle:@"Live Support"
                                                                 iPhoneImage:@"icon-livesupport" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIHelpViewController" 
                                                                 targetTitle:@"Live Support"
                                                                   deletable:NO] autorelease],
									  
									  [[[MyLauncherItem alloc] initWithTitle:@"About Us"
                                                                 iPhoneImage:@"icon-about" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIAboutUsViewController" 
                                                                 targetTitle:@"About Us"
                                                                   deletable:NO] autorelease],
									  
									  [[[MyLauncherItem alloc] initWithTitle:@"Back Door"
                                                                 iPhoneImage:@"icon-rate" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"AKIDevelopViewController" 
                                                                 targetTitle:@"Back Door"
                                                                   deletable:NO] autorelease],
                                      nil], 
                                     /*[NSMutableArray arrayWithObjects: 
                                      [[[MyLauncherItem alloc] initWithTitle:@"Item 8"
                                                                 iPhoneImage:@"itemImage" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"Item 8 View"
                                                                   deletable:NO] autorelease],
                                      [[[MyLauncherItem alloc] initWithTitle:@"Item 9"
                                                                 iPhoneImage:@"itemImage" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"Item 9 View"
                                                                   deletable:YES] autorelease],
                                      [[[MyLauncherItem alloc] initWithTitle:@"Item 10"
                                                                 iPhoneImage:@"itemImage" 
                                                                   iPadImage:@"itemImage-iPad"
                                                                      target:@"ItemViewController" 
                                                                 targetTitle:@"Item 10 View"
                                                                   deletable:NO] autorelease],
                                      nil],*/
                                     nil]];
        
        // Set number of immovable items below; only set it when you are setting the pages as the 
        // user may still be able to delete these items and setting this then will cause movable 
        // items to become immovable.
        // [self.launcherView setNumberOfImmovableItems:1];
        
        // Or uncomment the line below to disable editing (moving/deleting) completely!
        // [self.launcherView setEditingAllowed:NO];
	}
    
    // Set badge text for a MyLauncherItem using it's setBadgeText: method
    [(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:0] setBadgeText:@"4"];
    
    // Alternatively, you can import CustomBadge.h as above and setCustomBadge: as below.
    // This will allow you to change colors, set scale, and remove the shine and/or frame.
    [(MyLauncherItem *)[[[self.launcherView pages] objectAtIndex:0] objectAtIndex:1] setCustomBadge:[CustomBadge customBadgeWithString:@"2" withStringColor:[UIColor blackColor] withInsetColor:[UIColor whiteColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor blackColor] withScale:0.8 withShining:NO]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	//If you don't want to support multiple orientations uncomment the line below
    //return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
	return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}

- (void)dealloc 
{
    [super dealloc];
}

@end
