//
//  AKIConnectCell.m
//  AkiVPN
//
//  Created by luo  on 12-2-2.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "AKIConnectCell.h"


@implementation AKIConnectCell

@synthesize lblDesc;
@synthesize lblCode;
@synthesize imgCheck;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		//[imgCheck setHidden:YES];
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
