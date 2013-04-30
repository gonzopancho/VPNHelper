//
//  AKIPurchaseViewController.m
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AkiVPNAppDelegate.h"
#import "AKIPurchaseViewController.h"
#import "AKIPurchaseCell.h"
#import "AKIHistoryCell.h"
#import "AKIUIView.h"

#import <QuartzCore/QuartzCore.h>

#define TAG_VALUE 8000

@implementation AKIPurchaseViewController

@synthesize tblViewPurchaseInfoTraffic;
@synthesize tblViewPurchaseInfoSubscription;
@synthesize tblViewHistoryInfo;
@synthesize view0;
@synthesize btnShowHistory;
@synthesize segType;
@synthesize strSerial;
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
	if ([buttons count] == 2)
	{
		UIButton* buttonNormal;
		UIButton* buttonHighlighted;
		if (segmentIndex == 0)
		{
			buttonNormal = [buttons objectAtIndex:1];
			buttonHighlighted = [buttons objectAtIndex:0];
		}
		else
		{
			buttonNormal = [buttons objectAtIndex:0];
			buttonHighlighted = [buttons objectAtIndex:1];
		}
		
		[buttonNormal setTitleColor:LIGHT_GREEN forState:UIControlStateNormal];
		[buttonNormal setTitleShadowColor:WHITE forState:UIControlStateNormal];
		[buttonNormal.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
		
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
	
	NSInteger iIndex = segmentIndex;
	if (iDisplayType != iIndex)
	{
		iDisplayType = iIndex;
		//[tblViewPurchaseInfoTraffic reloadData];
		//[tblViewPurchaseInfoSubscription reloadData];
		
		if (iDisplayType == 0)
		{
			UIView *srcView = tblViewPurchaseInfoSubscription;
			UIView *destView = tblViewPurchaseInfoTraffic;
			[destView setFrame:CGRectMake(-319, 60, destView.frame.size.width, destView.frame.size.height)];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.2];
			[srcView setFrame:CGRectMake(321, 60, srcView.frame.size.width, srcView.frame.size.height)];
			[destView setFrame:CGRectMake(1, 60, destView.frame.size.width, destView.frame.size.height)];
			[UIView commitAnimations];
		}
		else if (iDisplayType == 1)
		{
			UIView *srcView = tblViewPurchaseInfoTraffic;
			UIView *destView = tblViewPurchaseInfoSubscription;
			[destView setFrame:CGRectMake(321, 60, destView.frame.size.width, destView.frame.size.height)];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.2];
			[srcView setFrame:CGRectMake(-319, 60, srcView.frame.size.width, srcView.frame.size.height)];
			[destView setFrame:CGRectMake(1, 60, destView.frame.size.width, destView.frame.size.height)];
			[UIView commitAnimations];
		}
		
	}
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
	
	[tblViewPurchaseInfoTraffic setBackgroundColor:[UIColor clearColor]];
	[tblViewPurchaseInfoSubscription setBackgroundColor:[UIColor clearColor]];
	[tblViewHistoryInfo setBackgroundColor:[UIColor clearColor]];
	
	[self initRightButtonItem];
	
	switches = [[NSArray arrayWithObjects:
				[NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"Traffic", @"Subscription", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(151,47)], @"size", @"bottombarblue.png", @"button-image", @"bottombarblue_pressed.png", @"button-highlight-image", @"blue-divider2.png", @"divider-image", [NSNumber numberWithFloat:14.0], @"cap-width", nil], nil] retain];
	buttons = [[NSMutableArray alloc] init];
	
	NSDictionary* dictSegType = [switches objectAtIndex:0];
	NSArray* arrSegTypeTitles = [dictSegType objectForKey:@"titles"];
	CustomSegmentedControl* customSegType = [[[CustomSegmentedControl alloc] initWithSegmentCount:arrSegTypeTitles.count segmentsize:[[dictSegType objectForKey:@"size"] CGSizeValue] dividerImage:[UIImage imageNamed:[dictSegType objectForKey:@"divider-image"]] tag:TAG_VALUE delegate:self] autorelease];
	customSegType.frame = CGRectMake(8, 10, customSegType.frame.size.width, customSegType.frame.size.height);
	[self.view addSubview:customSegType];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self initUI];
	
	[view0.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [view0.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [view0.layer setBorderWidth:1.0];
	[view0.layer setCornerRadius:10.0];
	[view0.layer setMasksToBounds:YES];
    view0.clipsToBounds = YES; 
	
	strSerial = [[NSMutableString alloc] initWithFormat:@""];
	
	AkiVPNAppDelegate *appDelegate = (AkiVPNAppDelegate *) [UIApplication sharedApplication].delegate;
	akiPurchaseInfo = appDelegate.akiPurchaseInfo;
	akiPurchaseInfo.delegate = self;
	
	iShowHistory = 0;
	
	if (akiPurchaseInfo.hasBeenLoaded == 0)
	{
		[akiPurchaseInfo downloadInformation];
		[self showWaiting];
	}
	else
	{
		for (AkiPurchaseEntry *purchaseEntry in akiPurchaseInfo.arrPurchaseEntriesTraffic)
			[purchaseEntry setSelected:NO];
		for (AkiPurchaseEntry *purchaseEntry in akiPurchaseInfo.arrPurchaseEntriesSubscription)
			[purchaseEntry setSelected:NO];
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
	[akiPurchaseInfo downloadInformation];
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
	refresh = 3;
	[tblViewPurchaseInfoTraffic reloadData];
	[tblViewPurchaseInfoSubscription reloadData];
	[tblViewHistoryInfo reloadData];
	[strSerial release];
	strSerial = [[NSMutableString alloc] initWithFormat:@""];
}

- (IBAction)onSelectType
{
    NSInteger iIndex = segType.selectedSegmentIndex;
	if (iDisplayType != iIndex)
	{
		iDisplayType = iIndex;
		//[tblViewPurchaseInfoTraffic reloadData];
		//[tblViewPurchaseInfoSubscription reloadData];
	
		if (iDisplayType == 0)
		{
			UIView *srcView = tblViewPurchaseInfoSubscription;
			UIView *destView = tblViewPurchaseInfoTraffic;
			[destView setFrame:CGRectMake(-319, 60, destView.frame.size.width, destView.frame.size.height)];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.2];
			[srcView setFrame:CGRectMake(321, 60, srcView.frame.size.width, srcView.frame.size.height)];
			[destView setFrame:CGRectMake(1, 60, destView.frame.size.width, destView.frame.size.height)];
			[UIView commitAnimations];
		}
		else if (iDisplayType == 1)
		{
			UIView *srcView = tblViewPurchaseInfoTraffic;
			UIView *destView = tblViewPurchaseInfoSubscription;
			[destView setFrame:CGRectMake(321, 60, destView.frame.size.width, destView.frame.size.height)];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDuration:0.2];
			[srcView setFrame:CGRectMake(-319, 60, srcView.frame.size.width, srcView.frame.size.height)];
			[destView setFrame:CGRectMake(1, 60, destView.frame.size.width, destView.frame.size.height)];
			[UIView commitAnimations];
		}
		
	}
}

- (IBAction)onClickShowHistory
{
	if (iShowHistory == 0)
	{
		iShowHistory = 1;
		[view0 setFrame:CGRectMake(10, 366, view0.frame.size.width, view0.frame.size.height)];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		[view0 setFrame:CGRectMake(10, 176, view0.frame.size.width, view0.frame.size.height)];
		[btnShowHistory setTitle:@"Hide Purchase History" forState:UIControlStateNormal];
		[btnShowHistory setTitle:@"Hide Purchase History" forState:UIControlStateHighlighted];
		[UIView commitAnimations];
	}
	else
	{
		iShowHistory = 0;
		[view0 setFrame:CGRectMake(10, 176, view0.frame.size.width, view0.frame.size.height)];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.3];
		[view0 setFrame:CGRectMake(10, 366, view0.frame.size.width, view0.frame.size.height)];
		[btnShowHistory setTitle:@"Show Purchase History" forState:UIControlStateNormal];
		[btnShowHistory setTitle:@"Show Purchase History" forState:UIControlStateHighlighted];
		[UIView commitAnimations];
	}
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
	if (tableView == tblViewPurchaseInfoTraffic)
	{
		return [akiPurchaseInfo.arrPurchaseEntriesTraffic count];
	}
	else if (tableView == tblViewPurchaseInfoSubscription)
	{
		return [akiPurchaseInfo.arrPurchaseEntriesSubscription count];
	}
	else
	{
		return [akiPurchaseInfo.arrHistoryEntries count];
	}
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	if (aTableView != tblViewHistoryInfo)
	{
		static NSString *aKIPurchaseCellIdentifier = @"AKIPurchaseCellIdentifier";
		AKIPurchaseCell *cell = (AKIPurchaseCell *)[aTableView dequeueReusableCellWithIdentifier:aKIPurchaseCellIdentifier];
		NSInteger row = [indexPath row];
		
		AkiPurchaseEntry *purchaseEntry;
		if (aTableView == tblViewPurchaseInfoTraffic)
		{
			purchaseEntry = [akiPurchaseInfo.arrPurchaseEntriesTraffic objectAtIndex:row];
		}
		else if (aTableView == tblViewPurchaseInfoSubscription)
		{
			purchaseEntry = [akiPurchaseInfo.arrPurchaseEntriesSubscription objectAtIndex:row];
		}
		
		if (cell == nil || refresh != 0)
		{
			if (aTableView == tblViewPurchaseInfoTraffic && row == [akiPurchaseInfo.arrPurchaseEntriesTraffic count] - 1)
				refresh --;
			if (aTableView == tblViewPurchaseInfoSubscription && row == [akiPurchaseInfo.arrPurchaseEntriesSubscription count] - 1)
				refresh --;
			
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKIPurchaseCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];//这里是设置成0，而不是1，因为数组的count属性==1
			
			[[cell lblIntro] setText:purchaseEntry.intro];
			[[cell lblDesc] setText:purchaseEntry.desc];
			float tmpFloat = purchaseEntry.price / 100;
			[[cell lblPrice] setText:[NSString stringWithFormat:@"$%.2f", tmpFloat]];
			
			if (purchaseEntry.selected == YES)
			{
				[cell.lblIntro setFrame:CGRectMake(cell.lblIntro.frame.origin.x + 30, cell.lblIntro.frame.origin.y, cell.lblIntro.frame.size.width, cell.lblIntro.frame.size.height)];
				[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x + 30, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
				[cell.imgCheck setAlpha:1];
			}
		}
		
		return cell;	
	}
	else
	{
		static NSString *aKIHistoryCellIdentifier = @"AKIHistoryCellIdentifier";
		AKIHistoryCell *cell = (AKIHistoryCell *)[aTableView dequeueReusableCellWithIdentifier:aKIHistoryCellIdentifier];
		NSInteger row = [indexPath row];
		
		AkiHistoryEntry *historyEntry;
		historyEntry = [akiPurchaseInfo.arrHistoryEntries objectAtIndex:row];
		
		if (cell == nil || refresh != 0)
		{
			if (row == [akiPurchaseInfo.arrHistoryEntries count] - 1)
				refresh --;
			
			NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKIHistoryCell" owner:self options:nil];
			cell = [nib objectAtIndex:0];//这里是设置成0，而不是1，因为数组的count属性==1
			
			[[cell lblDate] setText:[NSString stringWithFormat:@"%@", [akiPurchaseInfo.formatter stringFromDate:[historyEntry date]]]];
			[[cell lblIntro] setText:historyEntry.intro];
			float tmpFloat = historyEntry.price / 100;
			[[cell lblPrice] setText:[NSString stringWithFormat:@"$%.2f", tmpFloat]];
		}
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;	
	}
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	AKIPurchaseCell *cell = (AKIPurchaseCell*) [aTableView cellForRowAtIndexPath:indexPath];
	
	AkiPurchaseEntry *purchaseEntry;
	if (aTableView == tblViewPurchaseInfoTraffic)
		purchaseEntry = [akiPurchaseInfo.arrPurchaseEntriesTraffic objectAtIndex:row];
	else
		purchaseEntry = [akiPurchaseInfo.arrPurchaseEntriesSubscription objectAtIndex:row];
	[purchaseEntry setSelected:(1 - purchaseEntry.selected)];
	
	if (purchaseEntry.selected == YES)
	{
		if ([strSerial isEqualToString:@""])
		{
			[strSerial release];
			strSerial = [[NSMutableString alloc] initWithFormat:@"%@", purchaseEntry.serial];
			iSelected = row;
			iSelectedDisplayType = iDisplayType;
			
			[cell.imgCheck setAlpha:0];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			[UIView setAnimationDuration:0.1f];
			[cell.lblIntro setFrame:CGRectMake(cell.lblIntro.frame.origin.x + 40, cell.lblIntro.frame.origin.y, cell.lblIntro.frame.size.width, cell.lblIntro.frame.size.height)];
			[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x + 40, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
			[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x + 40, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
			[cell.imgCheck setAlpha:1];
			[UIView commitModalAnimations];
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.05f];
			[cell.lblIntro setFrame:CGRectMake(cell.lblIntro.frame.origin.x - 10, cell.lblIntro.frame.origin.y, cell.lblIntro.frame.size.width, cell.lblIntro.frame.size.height)];
			[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x - 10, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
			[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x - 10, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
			[UIView commitAnimations];
		}
		else
		{
			//[purchaseEntry setSelected:(1 - purchaseEntry.selected)];
			NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:iSelected inSection:0];
			UITableView *lastTableView;
			if (iSelectedDisplayType == 0)
				lastTableView = tblViewPurchaseInfoTraffic;
			else
				lastTableView = tblViewPurchaseInfoSubscription;
			
			AKIPurchaseCell *lastCell = (AKIPurchaseCell*) [lastTableView cellForRowAtIndexPath:lastIndexPath];
			AkiPurchaseEntry *lastPurchaseEntry;
			if (iSelectedDisplayType == 0)
				lastPurchaseEntry = [akiPurchaseInfo.arrPurchaseEntriesTraffic objectAtIndex:iSelected];
			else
				lastPurchaseEntry = [akiPurchaseInfo.arrPurchaseEntriesSubscription objectAtIndex:iSelected];
			
			[lastPurchaseEntry setSelected:(1 - lastPurchaseEntry.selected)];
			
			[strSerial release];
			strSerial = [[NSMutableString alloc] initWithFormat:@"%@", purchaseEntry.serial];
			iSelected = row;
			iSelectedDisplayType = iDisplayType;
			
			[cell.imgCheck setAlpha:0];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			[UIView setAnimationDuration:0.1f];
			[cell.lblIntro setFrame:CGRectMake(cell.lblIntro.frame.origin.x + 40, cell.lblIntro.frame.origin.y, cell.lblIntro.frame.size.width, cell.lblIntro.frame.size.height)];
			[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x + 40, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
			[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x + 40, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
			[cell.imgCheck setAlpha:1];
			[UIView commitAnimations];
			
			[lastCell.imgCheck setAlpha:1];
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
			[UIView setAnimationDuration:0.1f];
			[lastCell.lblIntro setFrame:CGRectMake(lastCell.lblIntro.frame.origin.x - 40, lastCell.lblIntro.frame.origin.y, lastCell.lblIntro.frame.size.width, lastCell.lblIntro.frame.size.height)];
			[lastCell.lblDesc setFrame:CGRectMake(lastCell.lblDesc.frame.origin.x - 40, lastCell.lblDesc.frame.origin.y, lastCell.lblDesc.frame.size.width, lastCell.lblDesc.frame.size.height)];
			[lastCell.imgCheck setFrame:CGRectMake(lastCell.imgCheck.frame.origin.x - 40, lastCell.imgCheck.frame.origin.y, lastCell.imgCheck.frame.size.width, lastCell.imgCheck.frame.size.height)];
			[lastCell.imgCheck setAlpha:0];
			[UIView commitModalAnimations];
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.05f];
			[cell.lblIntro setFrame:CGRectMake(cell.lblIntro.frame.origin.x - 10, cell.lblIntro.frame.origin.y, cell.lblIntro.frame.size.width, cell.lblIntro.frame.size.height)];
			[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x - 10, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
			[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x - 10, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
			[UIView commitAnimations];
			
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
			[UIView setAnimationDuration:0.05f];
			[lastCell.lblIntro setFrame:CGRectMake(lastCell.lblIntro.frame.origin.x + 10, lastCell.lblIntro.frame.origin.y, lastCell.lblIntro.frame.size.width, lastCell.lblIntro.frame.size.height)];
			[lastCell.lblDesc setFrame:CGRectMake(lastCell.lblDesc.frame.origin.x + 10, lastCell.lblDesc.frame.origin.y, lastCell.lblDesc.frame.size.width, lastCell.lblDesc.frame.size.height)];
			[lastCell.imgCheck setFrame:CGRectMake(lastCell.imgCheck.frame.origin.x + 10, lastCell.imgCheck.frame.origin.y, lastCell.imgCheck.frame.size.width, lastCell.imgCheck.frame.size.height)];
			[UIView commitAnimations];
			
		}
	}
	else
	{
		[strSerial release];
		strSerial = [[NSMutableString alloc] initWithFormat:@""];
		
		[cell.imgCheck setAlpha:1];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.1f];
		[cell.lblIntro setFrame:CGRectMake(cell.lblIntro.frame.origin.x - 40, cell.lblIntro.frame.origin.y, cell.lblIntro.frame.size.width, cell.lblIntro.frame.size.height)];
		[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x - 40, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
		[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x - 40, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
		[cell.imgCheck setAlpha:0];
		[UIView commitModalAnimations];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.05f];
		[cell.lblIntro setFrame:CGRectMake(cell.lblIntro.frame.origin.x + 10, cell.lblIntro.frame.origin.y, cell.lblIntro.frame.size.width, cell.lblIntro.frame.size.height)];
		[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x + 10, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
		[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x + 10, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
		[UIView commitAnimations];
	}
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
	[strSerial release];
	[switches release];
	[buttons release];
    [super dealloc];
}

@end
