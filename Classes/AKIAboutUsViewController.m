//
//  AKIAboutUsViewController.m
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AKIAboutUsViewController.h"

#import <QuartzCore/QuartzCore.h>

@implementation AKIAboutUsViewController

@synthesize btnRateUs;
@synthesize textView;

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

- (void)initRightButtonItem
{
	/*
	UIImage *imageNormal = [UIImage imageNamed:@"refresh_normal"];
	UIImage *imageHighlighted = [UIImage imageNamed:@"refresh_pressed"];
	CGRect frame = CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height);
	UIButton *rightButton = [[UIButton alloc] initWithFrame:frame];
	[rightButton setBackgroundImage:imageNormal forState:UIControlStateNormal];
	[rightButton setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
	[rightButton addTarget:self action:@selector(selfDownload) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
	[self.navigationItem setRightBarButtonItem:rightBarButtonItem];
	[rightBarButtonItem release];
	[rightButton release];
	 */
}

- (void)initUI
{
	UIImageView *navBarView;
	UIImage *imgNavBar = [UIImage imageNamed:@"navbar"];
	navBarView = [[UIImageView alloc] initWithImage:imgNavBar];
	navBarView.frame = CGRectMake(0.f, 0.f, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
	navBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.navigationController.navigationBar addSubview:navBarView];
	[self.navigationController.navigationBar sendSubviewToBack:navBarView];
	[navBarView release];
	
	UIImageView *backGroundView;
	UIImage *imgBackGround = [UIImage imageNamed:@"background"];
	backGroundView = [[UIImageView alloc] initWithImage:imgBackGround];
	backGroundView.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
	backGroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:backGroundView];
	[self.view sendSubviewToBack:backGroundView];
	[backGroundView release];
	
	[self initRightButtonItem];
	
	//UIButton *rateUs = [UIButton buttonWithType:UIButtonTypeCustom];
	//[rateUs setFrame:CGRectMake(0, 0, 200, 200)];
	//[rateUs setBackgroundImage:[UIImage imageNamed:@"rate_us"] forState:UIControlStateNormal];
	//[self.view addSubview:rateUs];
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self initUI];
	
	[textView.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [textView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [textView.layer setBorderWidth:1.0];
	[textView.layer setCornerRadius:10.0];
	[textView.layer setMasksToBounds:YES];
    textView.clipsToBounds = YES; 
	
}

- (IBAction)onClickRateUs
{
	
}

- (IBAction)sendEmail
{
	MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
	[mc setSubject:@"Bazinga!"];
	[mc setToRecipients:[NSArray arrayWithObjects:@"support@vpn-helper.com", nil]];
	[mc setMessageBody:@"Veonax!!!\n\nCome here, I need you!" isHTML:NO];
	[self presentModalViewController:mc animated:YES];
	[mc release];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Mail send canceled...");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Mail saved...");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Mail sent...");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Mail send errored: %@...", [error localizedDescription]);
			break;
		default:
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
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
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
