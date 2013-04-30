//
//  AKIHistoryCell.h
//  AkiVPN
//
//  Created by luo  on 12-2-11.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AKIHistoryCell : UITableViewCell {
	UILabel *lblDate;
	UILabel *lblIntro;
	UILabel *lblPrice;
}

@property(nonatomic, retain) IBOutlet UILabel *lblDate;
@property(nonatomic, retain) IBOutlet UILabel *lblIntro;
@property(nonatomic, retain) IBOutlet UILabel *lblPrice;

@end
