//
//  ImageCell.m
//  CollectionView
//
//  Created by silent on 16/3/31.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (void)awakeFromNib {

    //边框宽度
    self.imageView.layer.borderWidth = 2;
    
    //边框颜色
    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //圆角
    self.imageView.layer.cornerRadius = 3;
    
    //裁剪超出圆角部分
    self.imageView.clipsToBounds = YES;
}

@end
