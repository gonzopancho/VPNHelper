//
//  AKIMessageCell.h
//  AkiVPN
//
//  Created by luo  on 12-5-4.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AKIMessageCell : UITableViewCell {
	UITextView *txtTitle;
}

@property(nonatomic, retain) IBOutlet UITextView *txtTitle;

@end
