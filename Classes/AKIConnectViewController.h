//
//  AKIConnectViewController.h
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AkiVPNModels.h"

@interface AKIConnectViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AkiVPNModelsDelegate> {
	UIView *view0;
	UIView *view1;
	UIView *view2;
	UIView *view3;
	NSMutableArray *arrViews;
	UIView *viewContainer;
	UIButton *btnBack;
	UIButton *btnNext;
	NSInteger iCurrentView;
	
	AkiServerInfo *akiServerInfo;
	UITableView *tblViewServerInfo;
	
	NSTimer *timer;
	NSInteger refresh;
}

@property (nonatomic, retain) IBOutlet UIView *view0;
@property (nonatomic, retain) IBOutlet UIView *view1;
@property (nonatomic, retain) IBOutlet UIView *view2;
@property (nonatomic, retain) IBOutlet UIView *view3;
@property (nonatomic, retain) IBOutlet UIView *viewContainer;
@property (nonatomic, retain) IBOutlet UIButton *btnBack;
@property (nonatomic, retain) IBOutlet UIButton *btnNext;
@property (nonatomic, retain) IBOutlet UITableView *tblViewServerInfo;
@property NSInteger refresh;

- (void)handleTimer:(NSTimer *)timer;
- (IBAction)onClickBack;
- (IBAction)onClickNext;
- (void)openViewAtIndex:(NSInteger) iIndex;
- (IBAction)onDownloadConfigFile;

- (void)selfDownload;
- (void)showWaiting;
- (void)reloadUI;

@end
