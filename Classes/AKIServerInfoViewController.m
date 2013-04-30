//
//  AKIServerInfoViewController.m
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AkiVPNAppDelegate.h"
#import "AKIServerInfoViewController.h"
#import "AKIServerInfoCell.h"

#define TAG_VALUE 8020

@implementation AKIServerInfoViewController

@synthesize arrServerEntries;
@synthesize tblViewServerInfo;
@synthesize refresh;
@synthesize segSort;

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

-(UIImage*)image:(UIImage*)image withCap:(CapLocation)location capWidth:(NSUInteger)capWidth buttonWidth:(NSUInteger)buttonWidth
{
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, image.size.height), NO, 0.0);
	
	if (location == CapLeft)
		// To draw the left cap and not the right, we start at 0, and increase the width of the image by the cap width to push the right cap out of view
		[image drawInRect:CGRectMake(0, 0, buttonWidth + capWidth, image.size.height)];
	else if (location == CapRight)
		// To draw the right cap and not the left, we start at negative the cap width and increase the width of the image by the cap width to push the left cap out of view
		[image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + capWidth, image.size.height)];
	else if (location == CapMiddle)
		// To draw neither cap, we start at negative the cap width and increase the width of the image by both cap widths to push out both caps out of view
		[image drawInRect:CGRectMake(0.0-capWidth, 0, buttonWidth + (capWidth * 2), image.size.height)];
	
	UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resultImage;
}

- (void)adjustButtonTitle:(NSUInteger)segmentIndex
{
	if ([buttons count] == 3)
	{
		UIButton* buttonNormal1;
		UIButton* buttonNormal2;
		UIButton* buttonHighlighted;
		if (segmentIndex == 0)
		{
			buttonHighlighted = [buttons objectAtIndex:0];
			buttonNormal1 = [buttons objectAtIndex:1];
			buttonNormal2 = [buttons objectAtIndex:2];
		}
		else if (segmentIndex == 1)
		{
			buttonHighlighted = [buttons objectAtIndex:1];
			buttonNormal1 = [buttons objectAtIndex:0];
			buttonNormal2 = [buttons objectAtIndex:2];
		}
		else
		{
			buttonHighlighted = [buttons objectAtIndex:2];
			buttonNormal1 = [buttons objectAtIndex:0];
			buttonNormal2 = [buttons objectAtIndex:1];
		}
		
		[buttonNormal1 setTitleColor:LIGHT_GREEN forState:UIControlStateNormal];
		[buttonNormal1 setTitleShadowColor:WHITE forState:UIControlStateNormal];
		[buttonNormal1.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
		
		[buttonNormal2 setTitleColor:LIGHT_GREEN forState:UIControlStateNormal];
		[buttonNormal2 setTitleShadowColor:WHITE forState:UIControlStateNormal];
		[buttonNormal2.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
		
		[buttonHighlighted setTitleColor:WHITE forState:UIControlStateNormal];
		[buttonHighlighted setTitleShadowColor:BLACK forState:UIControlStateNormal];
		[buttonHighlighted.titleLabel setShadowOffset:CGSizeMake(0.0f, -1.0f)];
	}
}

- (UIButton*)buttonFor:(CustomSegmentedControl*)segmentedControl atIndex:(NSUInteger)segmentIndex;
{
	NSUInteger dataOffset = segmentedControl.tag - TAG_VALUE ;
	NSDictionary* data = [switches objectAtIndex:dataOffset];
	NSArray* titles = [data objectForKey:@"titles"];
	
	CapLocation location;
	if (segmentIndex == 0)
		location = CapLeft;
	else if (segmentIndex == titles.count - 1)
		location = CapRight;
	else
		location = CapMiddle;
	
	UIImage* buttonImage = nil;
	UIImage* buttonPressedImage = nil;
	
	CGFloat capWidth = [[data objectForKey:@"cap-width"] floatValue];
	CGSize buttonSize = [[data objectForKey:@"size"] CGSizeValue];
	
	if (location == CapLeftAndRight)
	{
		buttonImage = [[UIImage imageNamed:[data objectForKey:@"button-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
		buttonPressedImage = [[UIImage imageNamed:[data objectForKey:@"button-highlight-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0];
	}
	else
	{
		buttonImage = [self image:[[UIImage imageNamed:[data objectForKey:@"button-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonSize.width];
		buttonPressedImage = [self image:[[UIImage imageNamed:[data objectForKey:@"button-highlight-image"]] stretchableImageWithLeftCapWidth:capWidth topCapHeight:0.0] withCap:location capWidth:capWidth buttonWidth:buttonSize.width];
	}
	
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(0.0, 0.0, buttonSize.width, buttonSize.height);
	
	button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
	
	[button setTitle:[titles objectAtIndex:segmentIndex] forState:UIControlStateNormal];
	
	//[button.titleLabel setShadowColor:GRAY];
	
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:buttonPressedImage forState:UIControlStateSelected];
	button.adjustsImageWhenHighlighted = NO;
	
	if (segmentIndex == 0)
	{
		button.selected = YES;
	}
	[buttons addObject:button];
	[self adjustButtonTitle:0];
	
	return button;
}

- (void)touchUpInsideSegmentIndex:(NSUInteger)segmentIndex
{
	[self adjustButtonTitle:segmentIndex];
	
	iSort = segmentIndex;
	[self reloadUI];
}

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
	
	[tblViewServerInfo setBackgroundColor:[UIColor clearColor]];
	
	switches = [[NSArray arrayWithObjects:
				 [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"Name", @"Load", @"Ping", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(73,47)], @"size", @"bottombarblue.png", @"button-image", @"bottombarblue_pressed.png", @"button-highlight-image", @"blue-divider.png", @"divider-image", [NSNumber numberWithFloat:14.0], @"cap-width", nil], nil] retain];
	buttons = [[NSMutableArray alloc] init];
	
	NSDictionary* dictSegType = [switches objectAtIndex:0];
	NSArray* arrSegTypeTitles = [dictSegType objectForKey:@"titles"];
	CustomSegmentedControl* customSegType = [[[CustomSegmentedControl alloc] initWithSegmentCount:arrSegTypeTitles.count segmentsize:[[dictSegType objectForKey:@"size"] CGSizeValue] dividerImage:[UIImage imageNamed:[dictSegType objectForKey:@"divider-image"]] tag:TAG_VALUE delegate:self] autorelease];
	customSegType.frame = CGRectMake(89, 84, customSegType.frame.size.width, customSegType.frame.size.height);
	[self.view addSubview:customSegType];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	iSort = 0;
	[self initUI];

	AkiVPNAppDelegate *appDelegate = (AkiVPNAppDelegate *) [UIApplication sharedApplication].delegate;
	akiServerInfo = appDelegate.akiServerInfo;
	akiServerInfo.delegate = self;
	akiServerInfo.delegate3 = self;
	
	arrServerEntries = [[NSMutableArray alloc] init];
	
	if (akiServerInfo.hasBeenLoaded == 0)
	{
		[akiServerInfo downloadInformation];
		[self showWaiting];
	}
	else
	{
		[akiServerInfo restorePings];
		[self reloadUI];
		[self startPing];
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
	[akiServerInfo downloadInformation];
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
	[self startPing];
	[self hideWaiting];
}

- (void)reloadUI
{
	[self sortBySegmentIndex];
	refresh = 1;
	[tblViewServerInfo reloadData];
}

- (void)startPing
{
	[akiServerInfo newPingHelper];
	[akiServerInfo.pingHelper start];
}

- (void)finishOnePingAtIndex:(NSInteger)iIndex
{
	AkiServerEntry *serverEntry = [akiServerInfo.arrServerEntries objectAtIndex:iIndex];
	
	NSInteger iCurrentIndex = serverEntry.index;
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:iCurrentIndex inSection:0];
	AKIServerInfoCell *cell = (AKIServerInfoCell*) [tblViewServerInfo cellForRowAtIndexPath:indexPath];
	
	if (serverEntry.ping == 10000)
	{
		[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:timeout"]];
		[[cell lblPing] setTextColor:GRAY];
	}
	else if (serverEntry.ping > 1000)
	{
		[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:%dms", serverEntry.ping]];
		[[cell lblPing] setTextColor:RED];
	}
	else if (serverEntry.ping > 500)
	{
		[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:%dms", serverEntry.ping]];
		[[cell lblPing] setTextColor:YELLOW];
	}
	else
	{
		[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:%dms", serverEntry.ping]];
		[[cell lblPing] setTextColor:GREEN];
	}
	//refresh = 1;
	//[tblViewServerInfo reloadData];
}

- (void)finishAllPings
{
	NSInteger iIndex = segSort.selectedSegmentIndex;
	if (iIndex == 2)
		[self reloadUI];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) sortEntriesByName
{
	[arrServerEntries removeAllObjects];
	[akiServerInfo restoreIndices];
	for (int i = 0; i < [akiServerInfo.arrServerEntries count]; i ++)
	{
		[arrServerEntries addObject:[akiServerInfo.arrServerEntries objectAtIndex:i]];
	}
	
	AkiServerEntry *entry1;
	AkiServerEntry *entry2;
	for (NSInteger j = 0; j < (NSInteger) ([arrServerEntries count] - 1); j ++)
	{
		for (NSInteger i = 0; i < (NSInteger) ([arrServerEntries count] - 1); i ++)
		{
			entry1 = [arrServerEntries objectAtIndex:i];
			entry2 = [arrServerEntries objectAtIndex:i + 1];
			NSComparisonResult result = [[entry1 code] compare:[entry2 code]];
			if (result > 0)
			{
				[arrServerEntries replaceObjectAtIndex:i withObject:entry2];
				[arrServerEntries replaceObjectAtIndex:i + 1 withObject:entry1];
				
				[entry1 setIndex:i + 1];
				[entry2 setIndex:i];
			}
		}
	}
}

- (void) sortEntriesByLoad
{
	[arrServerEntries removeAllObjects];
	[akiServerInfo restoreIndices];
	for (int i = 0; i < [akiServerInfo.arrServerEntries count]; i ++)
	{
		[arrServerEntries addObject:[akiServerInfo.arrServerEntries objectAtIndex:i]];
	}
	
	AkiServerEntry *entry1;
	AkiServerEntry *entry2;
	for (NSInteger j = 0; j < (NSInteger) ([arrServerEntries count] - 1); j ++)
	{
		for (NSInteger i = 0; i < (NSInteger) ([arrServerEntries count] - 1); i ++)
		{
			entry1 = [arrServerEntries objectAtIndex:i];
			entry2 = [arrServerEntries objectAtIndex:i + 1];
			if ([entry1 load] > [entry2 load])
			{
				[arrServerEntries replaceObjectAtIndex:i withObject:entry2];
				[arrServerEntries replaceObjectAtIndex:i + 1 withObject:entry1];
				
				[entry1 setIndex:i + 1];
				[entry2 setIndex:i];
			}
		}
	}
}

- (void) sortEntriesByPing
{
	[arrServerEntries removeAllObjects];
	[akiServerInfo restoreIndices];
	for (int i = 0; i < [akiServerInfo.arrServerEntries count]; i ++)
	{
		[arrServerEntries addObject:[akiServerInfo.arrServerEntries objectAtIndex:i]];
	}
	
	AkiServerEntry *entry1;
	AkiServerEntry *entry2;
	for (NSInteger j = 0; j < (NSInteger) ([arrServerEntries count] - 1); j ++)
	{
		for (NSInteger i = 0; i < (NSInteger) ([arrServerEntries count] - 1); i ++)
		{
			entry1 = [arrServerEntries objectAtIndex:i];
			entry2 = [arrServerEntries objectAtIndex:i + 1];
			if ([entry1 ping] > [entry2 ping])
			{
				[arrServerEntries replaceObjectAtIndex:i withObject:entry2];
				[arrServerEntries replaceObjectAtIndex:i + 1 withObject:entry1];
				
				[entry1 setIndex:i + 1];
				[entry2 setIndex:i];
			}
		}
	}
}

- (IBAction)onSelectSort
{
	[self reloadUI];
}

- (void)sortBySegmentIndex
{
	//NSInteger iIndex = segSort.selectedSegmentIndex;
	NSInteger iIndex = iSort;
	if (iIndex == 0)
	{
		[self sortEntriesByName];
	}
	else if (iIndex == 1)
	{
		[self sortEntriesByLoad];
	}
	else if (iIndex == 2)
	{
		[self sortEntriesByPing];
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   
{
	return [arrServerEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *aKIServerInfoCellIdentifier = @"AKIServerInfoCellIdentifier";
	AKIServerInfoCell *cell = (AKIServerInfoCell *)[aTableView dequeueReusableCellWithIdentifier:aKIServerInfoCellIdentifier];
	NSInteger row = [indexPath row];
	AkiServerEntry *serverEntry = [arrServerEntries objectAtIndex:row];
	
	if (cell == nil || refresh == 1)
	{
		if (row == [arrServerEntries count] - 1)
			refresh = 0;
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKIServerInfoCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];//这里是设置成0，而不是1，因为数组的count属性==1
		
		[[cell lblDesc] setText:serverEntry.desc];
		[[cell lblCode] setText:serverEntry.code];
		[[cell lblStatus] setText:[NSString stringWithFormat:@"%@(load %d%%)", (serverEntry.status == @"running")? @"Running" : @"Maintaining", serverEntry.load]];
		if (serverEntry.status == @"maintanence")
		{
			[[cell lblStatus] setTextColor:GRAY];
		}
		else if (serverEntry.status == @"running" && serverEntry.load > 70)
		{
			[[cell lblStatus] setTextColor:RED];
		}
		else if (serverEntry.status == @"running" && serverEntry.load > 30)
		{
			[[cell lblStatus] setTextColor:YELLOW];
		}
		else
		{
			[[cell lblStatus] setTextColor:GREEN];
		}
		
		if (serverEntry.ping == 0)
		{
			[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:wait.."]];
			[[cell lblPing] setTextColor:BLUE];
		}
		else if (serverEntry.ping == 10000)
		{
			[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:timeout"]];
			[[cell lblPing] setTextColor:GRAY];
		}
		else if (serverEntry.ping > 1000)
		{
			[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:%dms", serverEntry.ping]];
			[[cell lblPing] setTextColor:RED];
		}
		else if (serverEntry.ping > 500)
		{
			[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:%dms", serverEntry.ping]];
			[[cell lblPing] setTextColor:YELLOW];
		}
		else
		{
			[[cell lblPing] setText:[NSString stringWithFormat:@"Ping:%dms", serverEntry.ping]];
			[[cell lblPing] setTextColor:GREEN];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;	
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSInteger row = [indexPath row];
	//[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	//AKIServerInfoCell *cell = (AKIServerInfoCell*) [aTableView cellForRowAtIndexPath:indexPath];
	
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
	[arrServerEntries release];
    [super dealloc];
}


@end
