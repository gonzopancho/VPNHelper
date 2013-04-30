//
//  AKIHelpViewController.h
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AkiVPNModels.h"
#import "CustomSegmentedControl.h"

@interface AKIHelpViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AkiVPNModelsDelegate, AkiVPNModelsDelegate2, CustomSegmentedControlDelegate> {
	UIView *view0;
	UIView *view1;
	NSMutableArray *arrViews;
	NSInteger iCurrentView;
	
	AkiHelpInfo *akiHelpInfo;
	AkiChatInfo *akiChatInfo;
	NSMutableArray *arrChatBubbles;
	
	UISegmentedControl *segView;
	NSArray *switches;
	NSMutableArray *buttons;
	
	UITextField *textSend;
	UITableView *tblViewChat;
	
	UIWebView *webViewFAQ;
	
	NSTimer *timer;
	NSInteger refresh;
}

@property (nonatomic, retain) IBOutlet UIView *view0;
@property (nonatomic, retain) IBOutlet UIView *view1;
@property NSInteger iCurrentView;
@property (nonatomic, retain) NSMutableArray *arrChatBubbles;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segView;
@property(nonatomic, retain) IBOutlet UITextField *textSend;
@property(nonatomic, retain) IBOutlet UITableView *tblViewChat;
@property(nonatomic, retain) IBOutlet UIWebView *webViewFAQ;
@property NSInteger refresh;

- (IBAction)textFieldDoneEditing:(id)sender;//按下Done键关闭键盘
- (IBAction)backgroundTap:(id)sender;
- (IBAction)onClickSend;
- (IBAction)onSelectView;
- (void)openViewAtIndex:(NSInteger) iIndex;

- (void)startInput;
- (void)restoreInput;
- (void)forceRestoreInput;

- (void)selfDownload;
- (void)selfDownload2;
- (void)selfDownload3;
- (void)showWaiting;
- (void)reloadUI;
- (void)reloadUI2;

- (void)loadBubbles;
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf;

@end
