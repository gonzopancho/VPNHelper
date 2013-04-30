//
//  AKIMessageViewController.m
//  AkiVPN
//
//  Created by luo  on 12-5-4.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "AkiVPNAppDelegate.h"
#import "AKIMessageViewController.h"
#import "AKIMessageCell.h"

@implementation AKIMessageViewController

@synthesize tblViewMessage;
@synthesize refresh;

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
	
	[tblViewMessage setBackgroundColor:[UIColor clearColor]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	//self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self initUI];

	AkiVPNAppDelegate *appDelegate = (AkiVPNAppDelegate *) [UIApplication sharedApplication].delegate;
	akiMessageInfo = appDelegate.akiMessageInfo;
	akiMessageInfo.delegate = self;

	if (akiMessageInfo.hasBeenLoaded == 0)
	{
		[akiMessageInfo downloadInformation];
		[self showWaiting];
	}
	else
	{
		[self reloadUI];
	}
	
	//timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	refresh = 0;
}

- (void)handleTimer:(NSTimer *)timer
{
	[self selfDownload];
}

- (void)selfDownload
{
	[akiMessageInfo downloadInformation];
	[self showWaiting];
}

- (void)showWaiting
{
    int width = 32, height = 32;
	CGRect frame = [[UIScreen mainScreen] bounds];
    int x = frame.size.width;
    int y = frame.size.height;
    frame = CGRectMake(x / 320 * 283, y / 480 * 25, width, height);
	
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc]initWithFrame:frame];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
	[progressInd setTag:9998];
    [self.navigationController.view addSubview:progressInd];
    [progressInd release];
	
	[[self view] setUserInteractionEnabled:NO];
	
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)hideWaiting
{
	[[self.navigationController.view viewWithTag:9998] removeFromSuperview];
    [[self view] setUserInteractionEnabled:YES];
	
	[self initRightButtonItem];
}

- (void)finishDownloading
{
	[self reloadUI];
	[self hideWaiting];
}

- (void)reloadUI
{
	refresh = 1;
	[tblViewMessage reloadData];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   
{
	return [akiMessageInfo.arrMessageEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *aKIMessageCellIdentifier = @"AKIMessageCellIdentifier";
	AKIMessageCell *cell = (AKIMessageCell *)[aTableView dequeueReusableCellWithIdentifier:aKIMessageCellIdentifier];
	NSInteger row = [indexPath row];
	AkiMessageEntry *messageEntry = [akiMessageInfo.arrMessageEntries objectAtIndex:row];
	
	if (cell == nil || refresh == 1)
	{
		if (row == [akiMessageInfo.arrMessageEntries count] - 1)
			refresh = 0;
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKIMessageCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];//这里是设置成0，而不是1，因为数组的count属性==1
		
		[[cell txtTitle] setText:[NSString stringWithFormat:@"%@", [messageEntry title]]];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;	
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSInteger row = [indexPath row];
	//[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	//AKIDataUsageCell *cell = (AKIDataUsageCell*) [aTableView cellForRowAtIndexPath:indexPath];
}


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
