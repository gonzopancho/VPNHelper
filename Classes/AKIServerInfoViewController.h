//
//  AKIServerInfoViewController.h
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AkiVPNModels.h"
#import "CustomSegmentedControl.h"

@interface AKIServerInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AkiVPNModelsDelegate, AkiVPNModelsDelegate3, CustomSegmentedControlDelegate> {
	AkiServerInfo *akiServerInfo;
	UITableView *tblViewServerInfo;
	NSMutableArray *arrServerEntries;
	
	NSTimer *timer;
	NSInteger refresh;
	
	UISegmentedControl *segSort;
	NSArray *switches;
	NSMutableArray *buttons;
	NSInteger iSort;
}

@property (nonatomic, retain) NSMutableArray *arrServerEntries;
@property (nonatomic, retain) IBOutlet UITableView *tblViewServerInfo;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segSort;
@property NSInteger refresh;

- (void)selfDownload;
- (void)showWaiting;
- (void)reloadUI;
- (void)startPing;

- (void) sortEntriesByName;
- (void) sortEntriesByLoad;
- (void) sortEntriesByPing;
- (IBAction)onSelectSort;
- (void)sortBySegmentIndex;

@end
