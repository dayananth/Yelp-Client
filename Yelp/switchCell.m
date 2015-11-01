//
//  switchCell.m
//  Yelp
//
//  Created by Ramasamy Dayanand on 10/30/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "switchCell.h"

@interface switchCell ()
@property (weak, nonatomic) IBOutlet UISwitch *switchComponent;
- (IBAction)switchValueChanged:(id)sender;

@end

@implementation switchCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchValueChanged:(id)sender {
    [self.delegate switchCell:self didUpdateValue:self.switchComponent.on];
    
}

- (void) setOn:(BOOL)on{
    [self setON:on animated:NO];
}

-(void) setON:(BOOL)on animated:(BOOL)animated{
    _on = on;
    [self.switchComponent setOn:on animated:animated];
}
@end
