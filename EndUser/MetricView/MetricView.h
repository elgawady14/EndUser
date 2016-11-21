//
//  MetricView.h
//  DevBoy
//
//  Created by Ahmad Abdul-Gawad Mahmoud on 10/26/16.
//  Copyright © 2016 Ahmad Abdul-Gawad Mahmoud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetricView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title color:(UIColor *)color;

@end
