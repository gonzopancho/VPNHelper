//
//  AKIHistoryCell.m
//  AkiVPN
//
//  Created by luo  on 12-2-11.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "AKIHistoryCell.h"


@implementation AKIHistoryCell

@synthesize lblDate;
@synthesize lblIntro;
@synthesize lblPrice;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    [super dealloc];
}


@end
