//
//  AKIDevelopViewController.m
//  AkiVPN
//
//  Created by luo  on 12-2-4.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "AkiVPNAppDelegate.h"
#import "AKIDevelopViewController.h"
#import "OpenUDID.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "PingHelper.h"

#import "GTMBase64.h"

@implementation AKIDevelopViewController

@synthesize lblUDID;
@synthesize lblUDIDLength;
@synthesize lblPing;
@synthesize txtPing;
@synthesize lblIndex;
@synthesize lblBaseURL;
@synthesize txtUserID;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBar.tintColor = COLOR(200, 40, 30);
	
	[lblUDID setText:[NSString stringWithFormat:@"%@", [OpenUDID value]]];
	[lblUDIDLength setText:[NSString stringWithFormat:@"(%d-length-hex)", [[OpenUDID value] length]]];
	
	/*
	NSString* req1 = @"10";
	NSString* req2 = @"znk0Z4WwwLHt4JbNsZuk3g==";
	NSString* ret1 = [Aki3DESUtils TripleDES:req1 encryptOrDecrypt:1];        
	NSLog(@"3DES/Base64 Encode Result=%@", ret1);
	NSString* ret2 = [Aki3DESUtils TripleDES2:req2 encryptOrDecrypt:0];
	NSLog(@"3DES/Base64 Decode Result=%@", ret2);
	 */
	
	[self reloadUI];
	timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reloadUI) userInfo:nil repeats:YES];
}

- (void)reloadUI
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	//if ([userDefaults objectIsForcedForKey:@"index"] == YES)
	//{
		NSString *strIndex = [userDefaults objectForKey:@"index"];
		NSString *strBaseURL = [userDefaults objectForKey:@"url"];
		[lblIndex setText:strIndex];
		[lblBaseURL setText:strBaseURL];
	//}
}

- (IBAction)onClickPing
{
	PingHelper *pingHelper = [[PingHelper alloc] initWithId:self itemSel:@selector(pingResult:) allSel:@selector(pingFinished)];
	[pingHelper addPingTask:[txtPing text] atIndex:0];
	[pingHelper start];
}

- (IBAction)onClickUpdateBaseURL
{
	[g_akiGWFInfo updateBaseURL];
}

- (IBAction)onClickRefreshAllInfos
{
	AkiVPNAppDelegate *appDelegate = (AkiVPNAppDelegate *) [UIApplication sharedApplication].delegate;
	
	AkiServerInfo *akiServerInfo = appDelegate.akiServerInfo;
	AkiDataInfo *akiDataInfo = appDelegate.akiDataInfo;
	AkiPurchaseInfo *akiPurchaseInfo = appDelegate.akiPurchaseInfo;
	AkiUsageInfo *akiUsageInfo = appDelegate.akiUsageInfo;
	AkiHelpInfo *akiHelpInfo = appDelegate.akiHelpInfo;
	AkiChatInfo *akiChatInfo = appDelegate.akiChatInfo;
	
	[akiServerInfo downloadInformationWithoutPing];
	[akiDataInfo downloadInformation];
	[akiPurchaseInfo downloadInformation];
	[akiUsageInfo downloadInformation];
	[akiHelpInfo downloadInformation];
	[akiChatInfo downloadInformation];
}

- (IBAction)onClickRegister
{
	[g_akiUserInfo initUserID];
	[txtUserID setText:[g_akiUserInfo getUserID]];
}

- (void)pingResult:(PingTask*)pingTask
{
	if (pingTask.success)
		[lblPing setText:[NSString stringWithFormat:@"%dms", [pingTask delay]]];
	else
		[lblPing setText:[NSString stringWithFormat:@"timeout"]];
}

- (void)pingFinished
{
	
}

- (void)pingResult2:(NSNumber*)iNumber
{
	[lblPing setText:[NSString stringWithFormat:@"%d", [iNumber intValue]]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[timer invalidate];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
