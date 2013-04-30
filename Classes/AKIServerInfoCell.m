//
//  AKIServerInfoCell.m
//  AkiVPN
//
//  Created by luo  on 12-2-3.
//  Copyright 2012 AkiSoft. All rights reserved.
//

#import "AKIServerInfoCell.h"


@implementation AKIServerInfoCell

@synthesize lblDesc;
@synthesize lblCode;
@synthesize lblStatus;
@synthesize lblPing;

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
