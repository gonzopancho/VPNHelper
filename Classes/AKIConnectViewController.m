//
//  AKIConnectViewController.m
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AkiVPNAppDelegate.h"
#import "AKIConnectViewController.h"
#import "AKIConnectCell.h"
#import "iToast.h"
#import <QuartzCore/QuartzCore.h>
#import "AKIUIView.h"

@implementation AKIConnectViewController

@synthesize view0, view1, view2, view3, viewContainer;
@synthesize btnBack, btnNext;
@synthesize tblViewServerInfo;
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
	
	[tblViewServerInfo setBackgroundColor:[UIColor clearColor]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self initUI];
	
	//[self.view setBackgroundColor:COLOR(234,237,250)];
	
	iCurrentView = 0;
	[view0 setFrame:CGRectMake(0, 0, view0.frame.size.width, view0.frame.size.height)];
	[btnBack setHidden:YES];
	//[self openViewAtIndex:iCurrentView];
	arrViews = [[NSMutableArray alloc] init];
	[arrViews addObject:view0];
	[arrViews addObject:view1];
	[arrViews addObject:view2];
	[arrViews addObject:view3];
	
	AkiVPNAppDelegate *appDelegate = (AkiVPNAppDelegate *) [UIApplication sharedApplication].delegate;
	akiServerInfo = appDelegate.akiServerInfo;
	akiServerInfo.delegate = self;
	
	/*
	UIImage *imgRightButton = [UIImage imageNamed:@"close"];
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithImage:imgRightButton style:UIBarButtonItemStylePlain target:self action:@selector(selfDownload)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	[refreshButton release];
	*/
	
	/*
	UIButton *btnRightButton=[UIButton buttonWithType:UIButtonTypeCustom];
	btnRightButton.frame=CGRectMake(0, 0, 51, 31);
	[btnRightButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
	[btnRightButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateHighlighted];
	[btnRightButton addTarget:self action:@selector(selfDownload) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *btnItemRightButton = [[UIBarButtonItem alloc] initWithCustomView:btnRightButton];
	self.navigationItem.rightBarButtonItem = btnItemRightButton;
	[btnItemRightButton release];
	 */
	
	if (akiServerInfo.hasBeenLoaded == 0)
	{
		[akiServerInfo downloadInformation];
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
	[akiServerInfo downloadInformation];
	[self showWaiting];
}

//显示进度滚轮指示器
- (void)showWaiting2
{
    int width = 32, height = 32;
    CGRect frame = [[self view] frame];;
    int x = frame.size.width;
    int y = frame.size.height;
    frame = CGRectMake((x - width) / 2, (y - height) / 2, width, height);
	
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc]initWithFrame:frame];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
	frame = CGRectMake((x - 60)/2, (y - height) / 2 + height, 80, 20);
	UILabel *waitingLable = [[UILabel alloc] initWithFrame:frame];
	waitingLable.text = @"Loading...";
	waitingLable.textColor = [UIColor whiteColor];
	waitingLable.font = [UIFont systemFontOfSize:15];
	waitingLable.backgroundColor = [UIColor clearColor];
	
    frame = [[self view] frame];//[[UIScreen mainScreen] applicationFrame];
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    theView.backgroundColor = [UIColor blackColor];
    theView.alpha = 0.7;
    
    [theView addSubview:progressInd];
	[theView addSubview:waitingLable];
    [progressInd release];
	[waitingLable release];
	
    [theView setTag:9999];
    [[self view] addSubview:theView];
    [theView release];
}

//消除滚动轮指示器
- (void)hideWaiting2
{
    [[self.view viewWithTag:9999] removeFromSuperview];
	
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
	[tblViewServerInfo reloadData];
}

- (IBAction)onClickBack
{
	iCurrentView --;
	if (iCurrentView == 0)
		[btnBack setHidden:YES];
	else if (iCurrentView == 2)
		[btnNext setHidden:NO];
	//[self openViewAtIndex:iCurrentView];
	
	UIView *srcView = [arrViews objectAtIndex:(iCurrentView + 1)];
	UIView *destView = [arrViews objectAtIndex:iCurrentView];
	[destView setFrame:CGRectMake(-320, 0, destView.frame.size.width, destView.frame.size.height)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	[srcView setFrame:CGRectMake(320, 0, srcView.frame.size.width, srcView.frame.size.height)];
	[destView setFrame:CGRectMake(0, 0, destView.frame.size.width, destView.frame.size.height)];
	[UIView commitAnimations];
}

- (IBAction)onClickNext
{
	iCurrentView ++;
	if (iCurrentView == 3)
		[btnNext setHidden:YES];
	else if (iCurrentView == 1)
		[btnBack setHidden:NO];
	//[self openViewAtIndex:iCurrentView];
	
	UIView *srcView = [arrViews objectAtIndex:(iCurrentView - 1)];
	UIView *destView = [arrViews objectAtIndex:iCurrentView];
	[destView setFrame:CGRectMake(320, 0, destView.frame.size.width, destView.frame.size.height)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.2];
	[srcView setFrame:CGRectMake(-320, 0, srcView.frame.size.width, srcView.frame.size.height)];
	[destView setFrame:CGRectMake(0, 0, destView.frame.size.width, destView.frame.size.height)];
	[UIView commitAnimations];
	
	/*
	CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [self.view.layer addAnimation:animation forKey:@"MyAnimation"];
	*/
}

- (void)openViewAtIndex:(NSInteger) iIndex
{
	if (iIndex == 0)
	{
		[self.view0 setCenter:CGPointMake(160, 170)];
		[self.view0 setBounds:CGRectMake(0, 0, 320, 340)];
		[self.view0 setHidden:NO];
		
		[self.view1 setHidden:YES];
		[self.view2 setHidden:YES];
		[self.view3 setHidden:YES];
	}
	else if (iIndex == 1)
	{
		[self.view1 setCenter:CGPointMake(160, 170)];
		[self.view1 setBounds:CGRectMake(0, 0, 320, 340)];
		[self.view1 setHidden:NO];
		
		[self.view0 setHidden:YES];
		[self.view2 setHidden:YES];
		[self.view3 setHidden:YES];
	}
	else if (iIndex == 2)
	{
		[self.view2 setCenter:CGPointMake(160, 170)];
		[self.view2 setBounds:CGRectMake(0, 0, 320, 340)];
		[self.view2 setHidden:NO];
		
		[self.view0 setHidden:YES];
		[self.view1 setHidden:YES];
		[self.view3 setHidden:YES];
	}
	else if (iIndex == 3)
	{
		[self.view3 setCenter:CGPointMake(160, 170)];
		[self.view3 setBounds:CGRectMake(0, 0, 320, 340)];
		[self.view3 setHidden:NO];
		
		[self.view0 setHidden:YES];
		[self.view1 setHidden:YES];
		[self.view2 setHidden:YES];
	}
}

- (IBAction)onDownloadConfigFile
{
	NSString *strServerIDs = "US01,US02";
	[akiServerInfo downloadVPNConfig:strServerIDs];
	//[[iToast makeText:NSLocalizedString(@"The activity has been successfully saved.", @"")] show];
	//[tblViewServerInfo reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   
{
	return [akiServerInfo.arrServerEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *aKIConnectCellIdentifier = @"AKIConnectCellIdentifier";
	AKIConnectCell *cell = (AKIConnectCell *)[aTableView dequeueReusableCellWithIdentifier:aKIConnectCellIdentifier];
	NSInteger row = [indexPath row];
	AkiServerEntry *serverEntry = [akiServerInfo.arrServerEntries objectAtIndex:row];
	
	if (cell == nil || refresh == 1)
	{
		if (row == [akiServerInfo.arrServerEntries count] - 1)
			refresh = 0;
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKIConnectCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];//这里是设置成0，而不是1，因为数组的count属性==1
	
		if (serverEntry.selected == YES)
		{
			[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x + 30, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
			[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x + 30, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
			[cell.imgCheck setAlpha:1];
		}
		
		[[cell lblDesc] setText:serverEntry.desc];
		[[cell lblCode] setText:serverEntry.code];
	}
	
	return cell;	
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	AKIConnectCell *cell = (AKIConnectCell*) [aTableView cellForRowAtIndexPath:indexPath];
	
	AkiServerEntry *serverEntry = [akiServerInfo.arrServerEntries objectAtIndex:row];
	[serverEntry setSelected:(1 - serverEntry.selected)];
	
	if (serverEntry.selected == YES)
	{
		[cell.imgCheck setAlpha:0];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.1f];
		[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x + 40, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
		[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x + 40, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
		[cell.imgCheck setAlpha:1];
		[UIView commitModalAnimations];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.05f];
		[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x - 10, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
		[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x - 10, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
		[UIView commitAnimations];
	}
	else
	{
		[cell.imgCheck setAlpha:1];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.1f];
		[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x - 40, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
		[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x - 40, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
		[cell.imgCheck setAlpha:0];
		[UIView commitModalAnimations];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationDuration:0.05f];
		[cell.lblDesc setFrame:CGRectMake(cell.lblDesc.frame.origin.x + 10, cell.lblDesc.frame.origin.y, cell.lblDesc.frame.size.width, cell.lblDesc.frame.size.height)];
		[cell.imgCheck setFrame:CGRectMake(cell.imgCheck.frame.origin.x + 10, cell.imgCheck.frame.origin.y, cell.imgCheck.frame.size.width, cell.imgCheck.frame.size.height)];
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
	[arrViews release];
    [super dealloc];
}


@end
