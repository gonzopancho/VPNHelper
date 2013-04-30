//
//  AKIDataUsageViewController.h
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot-CocoaTouch.h>
#import "AkiVPNModels.h"

@interface AKIDataUsageViewController : UIViewController <CPTPlotDataSource, UITableViewDelegate, UITableViewDataSource, AkiVPNModelsDelegate> {
	CPTXYGraph *barChart;
	CPTGraphHostingView *barChartView;
	
	AkiUsageInfo *akiUsageInfo;
	UITableView *tblViewDataUsage;
	
	NSTimer *timer;
	NSInteger refresh;
}

@property(nonatomic, retain) IBOutlet CPTGraphHostingView *barChartView;
@property (nonatomic, retain) IBOutlet UITableView *tblViewDataUsage;
@property NSInteger refresh;

- (void)selfDownload;
- (void)prepareGraph;
- (void)showWaiting;
- (void)reloadUI;

@end
