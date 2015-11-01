//
//  switchCell.h
//  Yelp
//
//  Created by Ramasamy Dayanand on 10/30/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
@class switchCell;

@protocol SwitchCellDelegate <NSObject>

-(void) switchCell: (switchCell *) switchCell didUpdateValue:(BOOL) value;

@end

@interface switchCell : UITableViewCell

@property (nonatomic,weak) id<SwitchCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,assign) BOOL on;

-(void) setON:(BOOL)on animated:(BOOL)animated;

@end
