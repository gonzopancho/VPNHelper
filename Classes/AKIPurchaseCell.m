//
//  AKIPurchaseCell.m
//  AkiVPN
//
//  Created by luo  on 12-2-3.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "AKIPurchaseCell.h"

@implementation AKIPurchaseCell

@synthesize lblIntro;
@synthesize lblDesc;
@synthesize lblPrice;
@synthesize imgCheck;

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
