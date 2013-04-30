//
//  AKIServerInfoCell.h
//  AkiVPN
//
//  Created by luo  on 12-2-3.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AKIServerInfoCell : UITableViewCell {
	UILabel *lblDesc;
	UILabel *lblCode;
	UILabel *lblStatus;
	UILabel *lblPing;
}

@property(nonatomic, retain) IBOutlet UILabel *lblDesc;
@property(nonatomic, retain) IBOutlet UILabel *lblCode;
@property(nonatomic, retain) IBOutlet UILabel *lblStatus;
@property(nonatomic, retain) IBOutlet UILabel *lblPing;

@end
