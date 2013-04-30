//
//  AKIDataPlanViewController.h
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePlot-CocoaTouch.h>
#import "AkiVPNModels.h"

@interface AKIDataPlanViewController : UIViewController <CPTPieChartDataSource, CPTPieChartDelegate, AkiVPNModelsDelegate> {
	CPTXYGraph *pieChart;
	NSMutableArray *dataForChart;
	CPTGraphHostingView *pieChartView;
	
	AkiDataInfo *akiDataInfo;
	
	UILabel *lblPrimaryPlan;
	UILabel *lblMinorPlan;
	UILabel *lblTrafficUsed;
	UILabel *lblTrafficTotal;
	UILabel *lblValidDate;
	UILabel *lblRestriction;
	
	NSTimer *timer;
	NSInteger refresh;
}

@property(readwrite, retain, nonatomic) NSMutableArray *dataForChart;
@property(nonatomic, retain) IBOutlet CPTGraphHostingView *pieChartView;

@property(nonatomic, retain) IBOutlet UILabel *lblPrimaryPlan;
@property(nonatomic, retain) IBOutlet UILabel *lblMinorPlan;
@property(nonatomic, retain) IBOutlet UILabel *lblTrafficUsed;
@property(nonatomic, retain) IBOutlet UILabel *lblTrafficTotal;
@property(nonatomic, retain) IBOutlet UILabel *lblValidDate;
@property(nonatomic, retain) IBOutlet UILabel *lblRestriction;
@property NSInteger refresh;

- (void)selfDownload;
- (void)prepareGraph;
- (void)showWaiting;
- (void)reloadUI;

@end
