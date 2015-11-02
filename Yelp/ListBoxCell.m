//
//  ListBoxCell.m
//  Yelp
//
//  Created by Ramasamy Dayanand on 11/1/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "ListBoxCell.h"

@interface ListBoxCell ()

@property (weak, nonatomic) IBOutlet UILabel *listBoxLabel;
@end


@implementation ListBoxCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
