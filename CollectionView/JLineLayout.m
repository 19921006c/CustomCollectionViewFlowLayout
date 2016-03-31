//
//  JLineLayout.m
//  CollectionView
//
//  Created by silent on 16/3/31.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "JLineLayout.h"

@implementation JLineLayout

static const CGFloat JLineLayoutItemWH= 100;

- (instancetype)init
{
    if ( self = [super init]) {
        
    }
    return self;
}

//一些初始化方法最好在这里做
- (void)prepareLayout
{
    [super prepareLayout];
    
    //初始化
    self.itemSize = CGSizeMake(JLineLayoutItemWH, JLineLayoutItemWH);
    
    //水平方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //如果时竖直方向滚动，minimumLineSpacing则是行距。如果时水平方向轮动minimumLineSpacing则是cell间距
    self.minimumLineSpacing = 100;
    
    //最左边和最后边，设置间距使第一张和最后一张显示在中间
    CGFloat inset = (self.collectionView.frame.size.width - JLineLayoutItemWH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    //每一个cell都有自己的 UICollectionViewLayoutAttributes
    //每一个indexPath都有自己的UICollectionViewLayoutAttributes
    
}

//显示边界改变的时候是否重新布局布局 内部会重新掉用layoutAttributesForElementsInRect
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //0.计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    //去除默认cell的attribute
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width *0.5;
    
    //遍历所有的布局属性
    for (UICollectionViewLayoutAttributes *attr in array) {
        
        
        if (!CGRectIntersectsRect(visiableRect, attr.frame)) continue;//如果不是可见的 continue
        
        //每一个item中点X
        CGFloat itemCenterX = attr.center.x;
        
        
        //根据屏幕中点的距离的绝对值,差越大，缩放比例越小
        
        CGFloat scale =1 + (1 - ABS(itemCenterX - centerX) / self.collectionView.frame.size.width);
        
        NSLog(@"%f",attr.center.x);
        attr.transform3D = CATransform3DMakeScale(scale, scale, 1.0);
    }
    NSLog(@"layoutAttributesForElementsInRect");
    
    return array;
}

//用来设置手松开，不在滚动的时候那一刻的位置
/**
 *
 *
 *  @param proposedContentOffset 原本要停止的位置
 *  @param velocity              滚动速度
 *
 *  @return
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //1.计算出scorllview 最后停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width *0.5;
    
    //3.遍历所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in array) {
        
        if (ABS(attr.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attr.center.x - centerX;
        }
        
    }
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}


@end
