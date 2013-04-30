//
//  AKIDataUsageCell.h
//  AkiVPN
//
//  Created by luo  on 12-2-3.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AKIDataUsageCell : UITableViewCell {
	UILabel *lblStart;
	UILabel *lblDuration;
	UILabel *lblTraffic;
}

@property(nonatomic, retain) IBOutlet UILabel *lblStart;
@property(nonatomic, retain) IBOutlet UILabel *lblDuration;
@property(nonatomic, retain) IBOutlet UILabel *lblTraffic;

@end
