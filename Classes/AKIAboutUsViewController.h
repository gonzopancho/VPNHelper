//
//  AKIAboutUsViewController.h
//  AkiVPN
//
//  Created by luo  on 12-1-31.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AKIAboutUsViewController : UIViewController <MFMailComposeViewControllerDelegate> {
	UIButton *btnRateUs;
	UITextView *textView;
}

@property(nonatomic, retain) IBOutlet UIButton *btnRateUs;
@property(nonatomic, retain) IBOutlet UITextView *textView;

- (IBAction)sendEmail;
- (IBAction)onClickRateUs;

@end
