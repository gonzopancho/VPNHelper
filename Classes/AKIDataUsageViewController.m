//
//  AKIDataUsageViewController.m
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AkiVPNAppDelegate.h"
#import "AKIDataUsageViewController.h"
#import "AKIDataUsageCell.h"

@implementation AKIDataUsageViewController

@synthesize barChartView;
@synthesize tblViewDataUsage;
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
	
	[tblViewDataUsage setBackgroundColor:[UIColor clearColor]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self initUI];
	
	AkiVPNAppDelegate *appDelegate = (AkiVPNAppDelegate *) [UIApplication sharedApplication].delegate;
	akiUsageInfo = appDelegate.akiUsageInfo;
	akiUsageInfo.delegate = self;
	
	if (akiUsageInfo.hasBeenLoaded == 0)
	{
		[akiUsageInfo downloadInformation];
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
	[akiUsageInfo downloadInformation];
	[self showWaiting];
}

-(void)viewDidAppear:(BOOL)animated
{
}

-(void)prepareGraph
{
	int iMaxTraffic = 0;
	for (int i = 0; i < 14; i ++)
	{
		if (iMaxTraffic < [[akiUsageInfo.arrTrafficByDay objectAtIndex:i] intValue])
			iMaxTraffic = [[akiUsageInfo.arrTrafficByDay objectAtIndex:i] intValue];
	}
	
	int iMagnitude = 1;
	int iTemp = iMaxTraffic;
	while (iTemp != 0)
	{
		iTemp = iTemp / 10;
		iMagnitude *= 10;
	}
	iMagnitude /= 100;
	if (iMagnitude == 0)
		iMagnitude = 1;
	
	iMaxTraffic = iMaxTraffic * 1.3 / iMagnitude * iMagnitude + iMagnitude;
	float fMaxTraffic = iMaxTraffic / 100;
	
	float fYInterval = iMaxTraffic / 4 / 100;
	
	[barChart release];
	
    // Create barChart from theme
    barChart = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
	//CPTTheme *theme = [CPTTheme themeNamed:kCPTDarkGradientTheme];
    //[barChart applyTheme:theme];
    barChartView.hostedGraph = barChart;
    
    // Border
    barChart.plotAreaFrame.borderLineStyle = nil;
    barChart.plotAreaFrame.cornerRadius = 0.0f;
	
    // Paddings
    barChart.paddingLeft = 0.0f;
    barChart.paddingRight = 0.0f;
    barChart.paddingTop = 0.0f;
    barChart.paddingBottom = 0.0f;
	
    barChart.plotAreaFrame.paddingLeft = 60.0;
	barChart.plotAreaFrame.paddingTop = 20.0;
	barChart.plotAreaFrame.paddingRight = 10.0;
	barChart.plotAreaFrame.paddingBottom = 50.0;
    
    // Graph title
    barChart.title = @"";//@"Data traffic in last two weeks";
    CPTMutableTextStyle *textStyle = [CPTTextStyle textStyle];
    textStyle.color = CPT_DARK_GREEN;
    textStyle.fontSize = 18.0f;
	textStyle.textAlignment = CPTTextAlignmentCenter;
    barChart.titleTextStyle = textStyle;
    barChart.titleDisplacement = CGPointMake(0.0f, -20.0f);
    barChart.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
	
	// Add plot space for horizontal bar charts
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)barChart.defaultPlotSpace;
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(fMaxTraffic)];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(16.0f)];
    
	
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)barChart.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
    x.axisLineStyle = nil;
    x.majorTickLineStyle = nil;
    x.minorTickLineStyle = nil;
    x.majorIntervalLength = CPTDecimalFromString(@"5");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	x.title = @"days of last two weeks";
	CPTMutableTextStyle *textStyleX = [CPTTextStyle textStyle];
    textStyleX.color = CPT_DARK_GREEN;
    textStyleX.fontSize = 14.0f;
	textStyleX.textAlignment = CPTTextAlignmentCenter;
	x.titleTextStyle = textStyleX;
    x.titleLocation = CPTDecimalFromFloat(7.5f);
	x.titleOffset = 25.0f;
	
	// Define some custom labels for the data elements
	x.labelRotation = M_PI/4;
	x.labelingPolicy = CPTAxisLabelingPolicyNone;
	NSArray *customTickLocations = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1], [NSDecimalNumber numberWithInt:8], [NSDecimalNumber numberWithInt:12], [NSDecimalNumber numberWithInt:15], nil];
	NSArray *xAxisLabels = [NSArray arrayWithObjects:@"two weeks ago", @"-7", @"-3", @"today", nil];
	NSUInteger labelLocation = 0;
	NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
	for (NSNumber *tickLocation in customTickLocations) {
		CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:x.labelTextStyle];
		newLabel.tickLocation = [tickLocation decimalValue];
		newLabel.offset = x.labelOffset + x.majorTickLength;
		newLabel.rotation = 0;//M_PI/4;
		[customLabels addObject:newLabel];
		[newLabel release];
	}
	
	x.axisLabels =  [NSSet setWithArray:customLabels];
	
	CPTXYAxis *y = axisSet.yAxis;
    y.axisLineStyle = nil;
    y.majorTickLineStyle = nil;
    y.minorTickLineStyle = nil;
    y.majorIntervalLength = CPTDecimalFromFloat(fYInterval);//CPTDecimalFromString(@"500");
    y.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	y.title = @"data usage in MBytes";
	CPTMutableTextStyle *textStyleY = [CPTTextStyle textStyle];
    textStyleY.color = CPT_DARK_GREEN;
    textStyleY.fontSize = 14.0f;
	textStyleY.textAlignment = CPTTextAlignmentCenter;
	y.titleTextStyle = textStyleY;
	y.titleOffset = 40.0f;
    y.titleLocation = CPTDecimalFromFloat(fMaxTraffic / 2);
	
    // First bar plot
    CPTBarPlot *barPlot = [CPTBarPlot tubularBarPlotWithColor:CPT_LIGHT_GREEN horizontalBars:NO];
    barPlot.baseValue = CPTDecimalFromString(@"0");
    barPlot.dataSource = self;
    barPlot.barOffset = CPTDecimalFromFloat(-0.25f);
    barPlot.identifier = @"Bar Plot 1";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];
    
    // Second bar plot
	/*
    barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    barPlot.dataSource = self;
    barPlot.baseValue = CPTDecimalFromString(@"0");
    barPlot.barOffset = CPTDecimalFromFloat(0.25f);
    barPlot.barCornerRadius = 2.0f;
    barPlot.identifier = @"Bar Plot 2";
    [barChart addPlot:barPlot toPlotSpace:plotSpace];*/
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
	[tblViewDataUsage reloadData];
	[self prepareGraph];
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
	return [akiUsageInfo.arrUsageEntries count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *aKIDataUsageCellIdentifier = @"AKIDataUsageCellIdentifier";
	AKIDataUsageCell *cell = (AKIDataUsageCell *)[aTableView dequeueReusableCellWithIdentifier:aKIDataUsageCellIdentifier];
	NSInteger row = [indexPath row];
	AkiUsageEntry *usageEntry = [akiUsageInfo.arrUsageEntries objectAtIndex:row];
	
	if (cell == nil || refresh == 1)
	{
		if (row == [akiUsageInfo.arrUsageEntries count] - 1)
			refresh = 0;
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKIDataUsageCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];//这里是设置成0，而不是1，因为数组的count属性==1

		[[cell lblStart] setText:[NSString stringWithFormat:@"%@ ~ %@", [akiUsageInfo.formatter stringFromDate:[usageEntry dateStart]], [akiUsageInfo.formatter stringFromDate:[usageEntry dateEnd]]]];
		
		int iHour, iMinute;//, iSecond;
		iHour = [usageEntry duration] / 3600;
		iMinute = ([usageEntry duration] - iHour * 3600) / 60;
		//iSecond = [usageEntry duration] - iHour * 3600 - iMinute * 60;
		[[cell lblDuration] setText:[NSString stringWithFormat:@"Duration: %dH%dM", iHour, iMinute]];
		
		float tmpFloat = usageEntry.traffic;
		tmpFloat = tmpFloat / 100;
		[[cell lblTraffic] setText:[NSString stringWithFormat:@"Traffic Used: %.2fMB", tmpFloat]];
		
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

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 14;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index 
{
    NSDecimalNumber *num = nil;
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
		switch ( fieldEnum ) {
			case CPTBarPlotFieldBarLocation:
				num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index + 1)];
				break;
			case CPTBarPlotFieldBarTip:
				//num = (NSDecimalNumber *)[NSDecimalNumber numberWithUnsignedInteger:(index + 5) * (index + 5)];
				if (index < [akiUsageInfo.arrTrafficByDay count])
				{
					NSNumber *temp = [akiUsageInfo.arrTrafficByDay objectAtIndex:index];
					float tmp = [temp floatValue] / 100;
					num = (NSDecimalNumber *) [NSDecimalNumber numberWithFloat:tmp];
				}
				else
					num = (NSDecimalNumber *) [NSDecimalNumber numberWithUnsignedInteger:0];
				//if ( [plot.identifier isEqual:@"Bar Plot 2"] ) 
				//	num = [num decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"10"]];
				break;
		}
    }
	
    return num;
}

-(CPTFill *) barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSNumber *)index; 
{
	return [CPTFill fillWithColor:CPT_LIGHT_GREEN];
	//return nil;
}

@end
