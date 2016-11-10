//
//  Created by Vlad Kochergin on 11.08.16.
//  Copyright © 2016 All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface KVStyle : NSObject

+ (KVStyle *)initWithFillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor lineWidth:(NSInteger)lineWidth radius:(NSInteger)radius;

@property (strong, nonatomic) UIColor      *fillColor;
@property (strong, nonatomic) UIColor      *strokeColor;
@property (nonatomic)         NSInteger     lineWidth;
@property (nonatomic)         NSInteger     radius;

@end
