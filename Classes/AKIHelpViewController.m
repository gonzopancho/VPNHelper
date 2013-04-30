//
//  AKIHelpViewController.m
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AkiVPNAppDelegate.h"
#import "AKIHelpViewController.h"
#import <UIKit/UIAlertView.h>
#import "AKIHelpCell.h"

#define TAG_VALUE 8010

@implementation AKIHelpViewController

@synthesize view0, view1;
@synthesize iCurrentView;
@synthesize arrChatBubbles;
@synthesize segView;
@synthesize textSend;
@synthesize tblViewChat;
@synthesize webViewFAQ;
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

//按完Done键以后关闭键盘
- (IBAction)textFieldDoneEditing:(id)sender
{
	//UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"hello" message:@"ipad ,i come" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	//[alert show];
	//[alert release];
	//[sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender
{
	//[self textFieldShouldReturn:textSend];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.        
    NSTimeInterval animationDuration = 0.30f;        
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];        
    [UIView setAnimationDuration:animationDuration];        
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);        
    self.view.frame = rect;        
    [UIView commitAnimations];        
    [textField resignFirstResponder];
	
	[self restoreInput];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[self startInput];
	
	//CGRect frame = textField.frame;
	int offset = 216;//frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
	NSTimeInterval animationDuration = 0.30f;                
	[UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                
	[UIView setAnimationDuration:animationDuration];
	float width = self.view.frame.size.width;                
	float height = self.view.frame.size.height;        
	if(offset > 0)
	{
		CGRect rect = CGRectMake(0.0f, -offset,width,height);                
		self.view.frame = rect;        
	}        
	[UIView commitAnimations];
	return YES;
}

- (void)startInput
{
	if (textSend.textColor == [UIColor grayColor])
	{
		[textSend setText:@""];
		[textSend setTextColor:[UIColor blackColor]];
	}
}

- (void)restoreInput
{
	if ([textSend.text isEqualToString:@""])
	{
		[textSend setText:@"please type your queston here.."];
		[textSend setTextColor:[UIColor grayColor]];
	}
}

- (void)forceRestoreInput
{
	[textSend setText:@"please type your queston here.."];
	[textSend setTextColor:[UIColor grayColor]];
}

- (IBAction)onClickSend
{
	[self forceRestoreInput];
}

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
	if (iIndex == iCurrentView)
		return;
	else
	{
		iCurrentView = iIndex;
	}
	//[self openViewAtIndex:iIndex];
	
	[timer invalidate];
	if (iCurrentView == 0)
		timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	else
	{
		timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(handleTimer2:) userInfo:nil repeats:YES];
		refresh = 0;
	}
	
	if (iIndex == 0)
	{
		UIView *srcView = [arrViews objectAtIndex:(1 - iIndex)];
		UIView *destView = [arrViews objectAtIndex:iIndex];
		[destView setFrame:CGRectMake(-320, 60, destView.frame.size.width, destView.frame.size.height)];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.2];
		[srcView setFrame:CGRectMake(320, 60, srcView.frame.size.width, srcView.frame.size.height)];
		[destView setFrame:CGRectMake(0, 60, destView.frame.size.width, destView.frame.size.height)];
		[UIView commitAnimations];
	}
	else if (iIndex == 1)
	{
		UIView *srcView = [arrViews objectAtIndex:(1 - iIndex)];
		UIView *destView = [arrViews objectAtIndex:iIndex];
		[destView setFrame:CGRectMake(320, 60, destView.frame.size.width, destView.frame.size.height)];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.2];
		[srcView setFrame:CGRectMake(-320, 60, srcView.frame.size.width, srcView.frame.size.height)];
		[destView setFrame:CGRectMake(0, 60, destView.frame.size.width, destView.frame.size.height)];
		[UIView commitAnimations];
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
	[rightButton addTarget:self action:@selector(selfDownload3) forControlEvents:UIControlEventTouchUpInside];
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
	
	[tblViewChat setBackgroundColor:[UIColor clearColor]];
	
	switches = [[NSArray arrayWithObjects:
				 [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:@"FAQ", @"LIVE-SUPPORT", nil], @"titles", [NSValue valueWithCGSize:CGSizeMake(151,47)], @"size", @"bottombarblue.png", @"button-image", @"bottombarblue_pressed.png", @"button-highlight-image", @"blue-divider2.png", @"divider-image", [NSNumber numberWithFloat:14.0], @"cap-width", nil], nil] retain];
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
	iCurrentView = 0;
	//self.navigationController.navigationBar.tintColor = COLOR(2, 100, 162);
	[self initUI];
	
	textSend.delegate = self;
	[textSend setText:@"please type your queston here.."];
	[textSend setTextColor:[UIColor grayColor]];
	
	//[self openViewAtIndex:0];
	arrViews = [[NSMutableArray alloc] init];
	[arrViews addObject:view0];
	[arrViews addObject:view1];
	
	tblViewChat.separatorStyle = NO;
	
	AkiVPNAppDelegate *appDelegate = (AkiVPNAppDelegate *) [UIApplication sharedApplication].delegate;
	akiHelpInfo = appDelegate.akiHelpInfo;
	akiHelpInfo.delegate = self;
	akiChatInfo = appDelegate.akiChatInfo;
	akiChatInfo.delegate = self;
	
	arrChatBubbles = [[NSMutableArray alloc] init];
	
	[webViewFAQ loadHTMLString:akiHelpInfo.strHelp baseURL:nil];
	webViewFAQ.backgroundColor=[UIColor clearColor];
	for (UIView *_aView in [webViewFAQ subviews])
	{
		if ([_aView isKindOfClass:[UIScrollView class]])
		{
			[(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
			[(UIScrollView *)_aView setShowsHorizontalScrollIndicator:NO];
			for (UIView *_inScrollview in _aView.subviews)
			{
				if ([_inScrollview isKindOfClass:[UIImageView class]])
				{
					_inScrollview.hidden = YES;
					//上下滚动出边界时的黑色的图片
				}
			}
		}
	}
	
	//UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStylePlain target:self action:@selector(selfDownload3)];
	//self.navigationItem.rightBarButtonItem = refreshButton;
	//[refreshButton release];
	
	if (akiHelpInfo.hasBeenLoaded == 0)
	{
		[akiHelpInfo downloadInformation];
		[self showWaiting];
	}
	else
	{
		[self reloadUI];
	}
	if (akiChatInfo.hasBeenLoaded == 0)
	{
		[akiChatInfo downloadInformation];
		[self showWaiting];	
	}
	else
	{
		[self reloadUI2];
	}

	refresh = 0;
}

- (void)handleTimer:(NSTimer *)timer
{
	[self selfDownload];
}

- (void)selfDownload
{
	[akiHelpInfo downloadInformation];
	if (iCurrentView == 0)
		[self showWaiting];
}

- (void)handleTimer2:(NSTimer *)timer
{
	[self selfDownload2];
}

- (void)selfDownload2
{
	[akiChatInfo downloadInformation];
	if (iCurrentView == 1)
		[self showWaiting];
}

- (void)selfDownload3
{
	[self selfDownload];
	[self selfDownload2];
}

- (void)showWaiting
{
	if (self.navigationItem.rightBarButtonItem == nil)
		return;
	
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
	
	if (self.navigationItem.rightBarButtonItem == nil)
	{
		[self initRightButtonItem];
	}
	//UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStylePlain target:self action:@selector(selfDownload)];
	//self.navigationItem.rightBarButtonItem = refreshButton;
	//[refreshButton release];
}

- (void)finishDownloading
{
	[self reloadUI];
	[self hideWaiting];
}

- (void)finishDownloading2
{
	[self reloadUI2];
	[self hideWaiting];
}

- (void)reloadUI
{
	[akiHelpInfo.strHelp setString:@""];
	for (AkiHelpEntry *helpEntry in akiHelpInfo.arrHelpEntries)
	{
		[akiHelpInfo.strHelp appendFormat:@"<font color=red>[Question]:</font> %@</br>", helpEntry.question];
		[akiHelpInfo.strHelp appendFormat:@"<font color=blue>[Answer]:</font> %@</br>", helpEntry.answer];
	}
	[webViewFAQ loadHTMLString:akiHelpInfo.strHelp baseURL:nil];
	//[webViewFAQ loadHTMLString:@"<font color=red>fesfsfsfdf</font>" baseURL:nil];
}

- (void)reloadUI2
{
	refresh = 1;
	[self loadBubbles];
	[tblViewChat reloadData];
}

- (IBAction)onSelectView
{
    NSInteger iIndex = segView.selectedSegmentIndex;
	if (iIndex == iCurrentView)
		return;
	else
	{
		iCurrentView = iIndex;
	}
	//[self openViewAtIndex:iIndex];
	
	[timer invalidate];
	if (iCurrentView == 0)
		timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	else
	{
		timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(handleTimer2:) userInfo:nil repeats:YES];
		refresh = 0;
	}
	
	if (iIndex == 0)
	{
		UIView *srcView = [arrViews objectAtIndex:(1 - iIndex)];
		UIView *destView = [arrViews objectAtIndex:iIndex];
		[destView setFrame:CGRectMake(-320, 60, destView.frame.size.width, destView.frame.size.height)];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.2];
		[srcView setFrame:CGRectMake(320, 60, srcView.frame.size.width, srcView.frame.size.height)];
		[destView setFrame:CGRectMake(0, 60, destView.frame.size.width, destView.frame.size.height)];
		[UIView commitAnimations];
	}
	else if (iIndex == 1)
	{
		UIView *srcView = [arrViews objectAtIndex:(1 - iIndex)];
		UIView *destView = [arrViews objectAtIndex:iIndex];
		[destView setFrame:CGRectMake(320, 60, destView.frame.size.width, destView.frame.size.height)];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.2];
		[srcView setFrame:CGRectMake(-320, 60, srcView.frame.size.width, srcView.frame.size.height)];
		[destView setFrame:CGRectMake(0, 60, destView.frame.size.width, destView.frame.size.height)];
		[UIView commitAnimations];
	}
}

- (void)openViewAtIndex:(NSInteger) iIndex
{
	if (iIndex == 0)
	{
		[self.view0 setHidden:NO];
		[self.view1 setHidden:YES];
	}
	else if (iIndex == 1)
	{
		[self.view1 setHidden:NO];
		[self.view0 setHidden:YES];
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)loadBubbles
{
	[arrChatBubbles removeAllObjects];
	
	for (AkiChatEntry *chatEntry in akiChatInfo.arrChatEntries)
	{
		UIView *chatView;
		if ([chatEntry.direction isEqualToString:@"q"])
			chatView = [self bubbleView:[NSString stringWithFormat:@"%@\n%@: %@", [akiChatInfo.formatter stringFromDate:[chatEntry date]],
							  chatEntry.nickname, chatEntry.content] from:YES];
		else
			chatView = [self bubbleView:[NSString stringWithFormat:@"%@\n%@: %@", [akiChatInfo.formatter stringFromDate:[chatEntry date]],
							  chatEntry.nickname, chatEntry.content] from:NO];
		[arrChatBubbles addObject:chatView];
	}

	[self.tblViewChat reloadData];
	if ((NSInteger) ([self.arrChatBubbles count]) > 0)
	{
		[self.tblViewChat scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.arrChatBubbles count] - 1 inSection:0] 
						  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
	}
}

- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf {
	// build single chat bubble cell with given text
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];
	
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"bubble":@"bubbleSelf" ofType:@"png"]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:fromSelf?30:14 topCapHeight:14]];
	
	UIFont *font = [UIFont systemFontOfSize:13];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(150.0f, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
	
	UILabel *bubbleText;
	if (fromSelf)
		bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(23.0f, 14.0f, size.width+10, size.height+10)];
	else
		bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, 14.0f, size.width+10, size.height+10)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.lineBreakMode = UILineBreakModeWordWrap;
	bubbleText.text = text;
	
	bubbleImageView.frame = CGRectMake(0.0f, 14.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
	if(!fromSelf)
		returnView.frame = CGRectMake(290.0f-bubbleText.frame.size.width, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	else
		returnView.frame = CGRectMake(0.0f, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
	
	[returnView addSubview:bubbleImageView];
	[bubbleImageView release];
	[returnView addSubview:bubbleText];
	[bubbleText release];
	
	return [returnView autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section   
{
	return [akiChatInfo.arrChatEntries count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UIView *chatView = [arrChatBubbles objectAtIndex:[indexPath row]];
	return chatView.frame.size.height+10;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
	static NSString *aKIHelpCellIdentifier = @"AKIHelpCellIdentifier";
	AKIHelpCell *cell = (AKIHelpCell *)[aTableView dequeueReusableCellWithIdentifier:aKIHelpCellIdentifier];
	NSInteger row = [indexPath row];
	AkiChatEntry *chatEntry = [akiChatInfo.arrChatEntries objectAtIndex:row];
	
	if (cell == nil || refresh == 1)
	{
		if (row == [akiChatInfo.arrChatEntries count] - 1)
			refresh = 0;
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKIHelpCell" owner:self options:nil];
		cell = [nib objectAtIndex:0];//这里是设置成0，而不是1，因为数组的count属性==1
	
		UIView *chatView = [arrChatBubbles objectAtIndex:row];
		[cell.contentView addSubview:chatView];
	
		if ([chatEntry.direction isEqualToString:@"a"])
		{
			chatView.frame = CGRectMake([self view].frame.size.width - chatView.frame.size.width - 20, 0.0f,  chatView.frame.size.width, chatView.frame.size.height);
		}
		else
		{
			chatView.frame = CGRectMake(0.0f, 0.0f,  chatView.frame.size.width, chatView.frame.size.height);
		}
		[cell.contentView addSubview:chatView];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	//[[cell lblDesc] setText:serverEntry.desc];
	//[[cell lblCode] setText:serverEntry.code];
	
	return cell;	
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSInteger row = [indexPath row];
	//[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	//AKIHelpCell *cell = (AKIHelpCell*) [aTableView cellForRowAtIndexPath:indexPath];
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidAppear:(BOOL)animated
{
	if (iCurrentView == 0)
		timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
	else
	{
		timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(handleTimer2:) userInfo:nil repeats:YES];
		refresh = 0;
	}
	
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[timer invalidate];
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[arrViews release];
	[arrChatBubbles release];
    [super dealloc];
}

@end
