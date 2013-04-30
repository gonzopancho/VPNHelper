//
//  AKIDevelopViewController.h
//  AkiVPN
//
//  Created by luo  on 12-2-4.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AkiVPNModels.h"


@interface AKIDevelopViewController : UIViewController {
	UILabel *lblUDID;
	UILabel *lblUDIDLength;
	UILabel *lblPing;
	UITextField *txtPing;
	
	UILabel *lblIndex;
	UILabel *lblBaseURL;
	
	UITextField *txtUserID;
	
	NSTimer *timer;
}

@property(nonatomic, retain) IBOutlet UILabel *lblUDID;
@property(nonatomic, retain) IBOutlet UILabel *lblUDIDLength;
@property(nonatomic, retain) IBOutlet UILabel *lblPing;
@property(nonatomic, retain) IBOutlet UITextField *txtPing;

@property(nonatomic, retain) IBOutlet UILabel *lblIndex;
@property(nonatomic, retain) IBOutlet UILabel *lblBaseURL;

@property(nonatomic, retain) IBOutlet UITextField *txtUserID;

- (void)reloadUI;
- (IBAction)onClickPing;
- (IBAction)onClickUpdateBaseURL;
- (IBAction)onClickRefreshAllInfos;
- (IBAction)onClickRegister;

@end
