//
//  APAppItemCollectionViewCell.m
//  AppStore
//
//  Created by Dan Mac Hale on 10/11/2014.
//  Copyright (c) 2014 iElmo. All rights reserved.
//

#import "APAppItemCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface APAppItemCollectionViewCell ()
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *kind;
@property (nonatomic, weak) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *itemIndexLabel;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@end

@implementation APAppItemCollectionViewCell

#define FREE_PRICE 0.00

-(void)decorateCellWithAppItem:(APAppItemObject *)appItem {
    self.image.image = nil;
    self.name.text = appItem.name;
    self.kind.text = appItem.kind;
    self.price.text = [self priceForItem:appItem];
    self.itemIndexLabel.text = [NSString stringWithFormat:@"%li.", appItem.itemIndex];
    [self.image setImageWithURL:appItem.imageUrl placeholderImage:nil];
}

-(NSString *)priceForItem:(APAppItemObject *)appItem {
    NSString *priceString;
    if (appItem.price == FREE_PRICE) {
        priceString = @"FREE";
    }
    else priceString = [NSString stringWithFormat:@"%@ %.2f", appItem.currencySymbol, appItem.price];
    return priceString;
}
@end
