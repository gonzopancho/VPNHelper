//
//  AKIMessageViewController.h
//  AkiVPN
//
//  Created by luo  on 12-5-4.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AkiVPNModels.h"

@interface AKIMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AkiVPNModelsDelegate> {
	AkiMessageInfo *akiMessageInfo;
	UITableView *tblViewMessage;
	
	NSTimer *timer;
	NSInteger refresh;
}

@property (nonatomic, retain) IBOutlet UITableView *tblViewMessage;
@property NSInteger refresh;

- (void)handleTimer:(NSTimer *)timer;

- (void)selfDownload;
- (void)showWaiting;
- (void)reloadUI;

@end
