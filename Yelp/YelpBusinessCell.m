//
//  YelpBusinessCell.m
//  Yelp
//
//  Created by Ramasamy Dayanand on 10/28/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "YelpBusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface YelpBusinessCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingsImageView;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@end

@implementation YelpBusinessCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setYelpBusiness:(YelpBusiness *)yelpBusiness{
    _yelpBusiness = yelpBusiness;
    NSURLRequest *urlReq = [NSURLRequest requestWithURL:self.yelpBusiness.imageUrl];
    [self.thumbImageView setImageWithURLRequest:urlReq placeholderImage:NULL success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        [UIView transitionWithView:self.thumbImageView
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.thumbImageView.image = image;
                        }
                        completion:NULL];
    }
                                   failure:NULL];
//    [self.thumbImageView` setImageWithURL:self.yelpBusiness.imageUrl];
    self.nameLabel.text = self.yelpBusiness.name;
    self.distanceLabel.text= self.yelpBusiness.distance;
    [self.ratingsImageView setImageWithURL:self.yelpBusiness.ratingImageUrl];
    self.reviewsLabel.text = [NSString stringWithFormat:@"%d Reviews",self.yelpBusiness.reviewCount.intValue];
    self.addressLabel.text = self.yelpBusiness.address;
    self.categoryLabel.text = self.yelpBusiness.categories;
}

@end
