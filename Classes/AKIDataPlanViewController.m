//
//  AKIDataPlanViewController.m
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AkiVPNAppDelegate.h"
#import "AKIDataPlanViewController.h"


@implementation AKIDataPlanViewController

@synthesize dataForChart, pieChartView;
@synthesize lblPrimaryPlan, lblMinorPlan, lblTrafficUsed, lblTrafficTotal, lblValidDate, lblRestriction;
@synthesize refresh;

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	CGFloat margin = pieChart.plotAreaFrame.borderLineStyle.lineWidth + 5.0;
	
	CPTPieChart *piePlot = (CPTPieChart *)[pieChart plotWithIdentifier:@"Pie Chart 1"];
	CGRect plotBounds = pieChart.plotAreaFrame.bounds;
	CGFloat newRadius = MIN(plotBounds.size.width, plotBounds.size.height) / 2.0 - margin;
	
	CGFloat y = 0.0;
	
	if ( plotBounds.size.width > plotBounds.size.height ) {
		y = 0.5; 
	}
	else {
		y = (newRadius + margin) / plotBounds.size.height;
	}
	CGPoint newAnchor = CGPointMake(0.5, y);
	
	// Animate the change
	[CATransaction begin];
	{
		[CATransaction setAnimationDuration:1.0];
		[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
		
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"pieRadius"];
		animation.toValue = [NSNumber numberWithDouble:newRadius];
		animation.fillMode = kCAFillModeForwards;
		animation.delegate = self;
		[piePlot addAnimation:animation forKey:@"pieRadius"];
		
		animation = [CABasicAnimation animationWithKeyPath:@"centerAnchor"];
		animation.toValue = [NSValue valueWithBytes:&newAnchor objCType:@encode(CGPoint)];
		animation.fillMode = kCAFillModeForwards;
		animation.delegate = self;
		[piePlot addAnimation:animation forKey:@"centerAnchor"];
	}
	[CATransaction commit];
}

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
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self initUI];
	
	[self.pieChartView setBackgroundColor:[UIColor clearColor]];
	
	AkiVPNAppDelegate *appDelegate = (AkiVPNAppDelegate *) [UIApplication sharedApplication].delegate;
	akiDataInfo = appDelegate.akiDataInfo;
	akiDataInfo.delegate = self;
	
	if (akiDataInfo.hasBeenLoaded == 0)
	{
		lblPrimaryPlan.text = @"Loading..";
		lblMinorPlan.text = @"Loading..";
		lblTrafficUsed.text = @"Loading..";
		lblTrafficTotal.text = @"Loading..";
		lblValidDate.text = @"Loading..";
		lblRestriction.text = @"Loading..";
		
		[akiDataInfo downloadInformation];
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
	[akiDataInfo downloadInformation];
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
	lblPrimaryPlan.text = akiDataInfo.primaryPlan;
	lblMinorPlan.text = akiDataInfo.minorPlan;
	
	float fTrafficUsed = akiDataInfo.trafficUsed;
	fTrafficUsed /= 100;
	float fTrafficTotal = akiDataInfo.trafficTotal;
	fTrafficTotal /= 100;
	
	if (akiDataInfo.trafficTotal != 0)
	{
		lblTrafficUsed.text = [NSString stringWithFormat:@"%.2fMB used", fTrafficUsed];
		lblTrafficTotal.text = [NSString stringWithFormat:@"%.2fMB in total", fTrafficTotal];
		lblValidDate.text = [NSString stringWithFormat:@"%@\n~ %@", akiDataInfo.validDateStart, akiDataInfo.validDateEnd];
		lblRestriction.text = akiDataInfo.restriction;
		
		if (akiDataInfo.trafficUsed == 0)
		{
			NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:(akiDataInfo.trafficTotal * 0.01)], [NSNumber numberWithDouble:(akiDataInfo.trafficTotal * 0.99)], nil];
			self.dataForChart = contentArray;
		}
		else
		{
			NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:akiDataInfo.trafficUsed], [NSNumber numberWithDouble:(akiDataInfo.trafficTotal - akiDataInfo.trafficUsed)], nil];
			self.dataForChart = contentArray;
		}
		
		[self prepareGraph];
	}
	else
	{
		lblTrafficUsed.text = [NSString stringWithFormat:@"%.2fMB used", fTrafficUsed];
		lblTrafficTotal.text = [NSString stringWithFormat:@"Unlimited in total"];
		lblValidDate.text = [NSString stringWithFormat:@"%@\n~ %@", akiDataInfo.validDateStart, akiDataInfo.validDateEnd];
		lblRestriction.text = akiDataInfo.restriction;
		
		NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:akiDataInfo.trafficUsed], [NSNumber numberWithDouble:akiDataInfo.trafficUsed * 20], nil];
		self.dataForChart = contentArray;
		[self prepareGraph];
	}
}

- (void)viewDidAppear:(BOOL)animated
{
	//NSMutableArray *contentArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithDouble:48.0], [NSNumber numberWithDouble:2048.0 - 48.0], nil];
	//self.dataForChart = contentArray;
	//[self prepareGraph];
}

- (void)prepareGraph
{
	[pieChart release];
	
    // Create pieChart from theme
    pieChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	//CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //[pieChart applyTheme:theme];
    pieChartView.hostedGraph = pieChart;
	
    pieChart.paddingLeft = 2.0;
	pieChart.paddingTop = 2.0;
	pieChart.paddingRight = 2.0;
	pieChart.paddingBottom = 2.0;
	
	pieChart.axisSet = nil;
	
	CPTMutableTextStyle *whiteText = [CPTMutableTextStyle textStyle];
	whiteText.color = [CPTColor whiteColor];
	
	pieChart.titleTextStyle = whiteText;
	pieChart.title = @"";
	//pieChart.title = @"Data Chart";
	
    // Add pie chart
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.dataSource = self;
	piePlot.pieRadius = 60.0;
    piePlot.identifier = @"Pie Chart 1";
	piePlot.startAngle = M_PI_4;
	piePlot.sliceDirection = CPTPieDirectionCounterClockwise;
	piePlot.centerAnchor = CGPointMake(0.5, 0.5);
	
	CPTMutableLineStyle *lineStyle = [[CPTMutableLineStyle alloc] init];
	lineStyle.lineWidth = 0;
	piePlot.borderLineStyle = lineStyle;
	[lineStyle autorelease];
	
	piePlot.delegate = self;
    [pieChart addPlot:piePlot];
    [piePlot release];
}

- (NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.dataForChart count];
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
	if ( index >= [self.dataForChart count] ) return nil;
	
	if ( fieldEnum == CPTPieChartFieldSliceWidth ) {
		return [self.dataForChart objectAtIndex:index];
	}
	else {
		return [NSNumber numberWithInt:index];
	}
}

- (CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index 
{
	CPTTextLayer *label;
	//if (index == 0)
	//	label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"traffic used"]];
	//else
	//	label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"traffic remained"]];
	label = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@""]];
	
    CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
	textStyle.color = [CPTColor lightGrayColor];
    label.textStyle = textStyle;
    [textStyle release];
	return [label autorelease];

}

- (CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
	if (index == 0)
		return [CPTFill fillWithColor:CPT_DARK_BROWN];
	else
		return [CPTFill fillWithColor:CPT_LIGHT_GREEN];
}

- (CGFloat)radialOffsetForPieChart:(CPTPieChart *)piePlot recordIndex:(NSUInteger)index
{
	CGFloat offset = 2.0;	
	float fTrafficUsed = akiDataInfo.trafficUsed;
	float fTrafficTotal = akiDataInfo.trafficTotal;
	if (akiDataInfo.trafficTotal == 0)
		fTrafficTotal = fTrafficUsed * 20;
	float fRatio = fTrafficUsed / fTrafficTotal - 0.5;
	if (fRatio < 0)
		fRatio = -fRatio;
	fRatio += 0.5;
	
    return offset * fRatio;
}

/*-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index; 
 {
 return nil;
 }*/

- (void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)index
{
	//pieChart.title = [NSString stringWithFormat:@"Selected index: %lu", index];
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
	[dataForChart release];
    [super dealloc];
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	CPTPieChart *piePlot = (CPTPieChart *)[pieChart plotWithIdentifier:@"Pie Chart 1"];
	CABasicAnimation *basicAnimation = (CABasicAnimation *)theAnimation;
	
	[piePlot removeAnimationForKey:basicAnimation.keyPath];
	[piePlot setValue:basicAnimation.toValue forKey:basicAnimation.keyPath];
	[piePlot repositionAllLabelAnnotations];
}

@end
