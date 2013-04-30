//
//  AKIPurchaseCell.h
//  AkiVPN
//
//  Created by luo  on 12-2-3.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AKIPurchaseCell : UITableViewCell {
	UILabel *lblIntro;
	UILabel *lblDesc;
	UILabel *lblPrice;
	UIImageView *imgCheck;
}

@property(nonatomic, retain) IBOutlet UILabel *lblIntro;
@property(nonatomic, retain) IBOutlet UILabel *lblDesc;
@property(nonatomic, retain) IBOutlet UILabel *lblPrice;
@property(nonatomic, retain) IBOutlet UIImageView *imgCheck;

@end
