//
//  AKIConnectCell.h
//  AkiVPN
//
//  Created by luo  on 12-2-2.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AKIConnectCell : UITableViewCell {
	UILabel *lblDesc;
	UILabel *lblCode;
	UIImageView *imgCheck;
}

@property(nonatomic, retain) IBOutlet UILabel *lblDesc;
@property(nonatomic, retain) IBOutlet UILabel *lblCode;
@property(nonatomic, retain) IBOutlet UIImageView *imgCheck;

@end
