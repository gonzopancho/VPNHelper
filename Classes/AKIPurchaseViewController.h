//
//  AKIPurchaseViewController.h
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AkiVPNModels.h"
#import "CustomSegmentedControl.h"

@interface AKIPurchaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AkiVPNModelsDelegate, CustomSegmentedControlDelegate> {
	AkiPurchaseInfo *akiPurchaseInfo;
	UITableView *tblViewPurchaseInfoTraffic;
	UITableView *tblViewPurchaseInfoSubscription;
	UITableView *tblViewHistoryInfo;
	UIView *view0;
	UIButton *btnShowHistory;
	NSInteger iShowHistory;
	
	NSInteger iDisplayType;
	UISegmentedControl *segType;
	NSMutableString *strSerial;
	NSInteger iSelected;
	NSInteger iSelectedDisplayType;
	
	NSArray *switches;
	NSMutableArray *buttons;
	
	NSTimer *timer;
	NSInteger refresh;
}

@property (nonatomic, retain) IBOutlet UITableView *tblViewPurchaseInfoTraffic;
@property (nonatomic, retain) IBOutlet UITableView *tblViewPurchaseInfoSubscription;
@property (nonatomic, retain) IBOutlet UITableView *tblViewHistoryInfo;
@property (nonatomic, retain) IBOutlet UIView *view0;
@property (nonatomic, retain) IBOutlet UIButton *btnShowHistory;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segType;
@property (nonatomic, retain) NSMutableString *strSerial;
@property NSInteger refresh;

- (void)selfDownload;
- (void)showWaiting;
- (IBAction)onSelectType;
- (void)reloadUI;
- (IBAction)onClickShowHistory;

@end
