//
//  ViewController.m
//  CollectionView
//
//  Created by silent on 16/3/31.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "ViewController.h"

#import "ImageCell.h"

#import "JLineLayout.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//存储图片名称的array
@property (nonatomic, strong)NSMutableArray *imageArr;

@property (nonatomic, weak)UICollectionView *collectionView;

@end

@implementation ViewController

//设置数据
- (NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
        
        for (int i = 1; i <= 20; i ++) {
            [_imageArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    return _imageArr;
}

static NSString *const identifier = @"ImageCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建collection view
    CGRect rect = CGRectMake(0, 100, 375, 200);
    
    JLineLayout *layout = [[JLineLayout alloc]init];
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:layout];
    
    //数据源
    collectionView.dataSource = self;
    
    //代理
    collectionView.delegate = self;
    
    //注册
    [collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
    
    
    self.collectionView = collectionView;
    
    [self.view addSubview:collectionView];
    
    //UICollectionViewLayout : 自定义布局
    //UICollectionViewFlowLayout : 流水布局
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建cell
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArr[indexPath.item]]];
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //CoreAnimation
    
    if ([self.collectionView.collectionViewLayout isKindOfClass:[JLineLayout class]]) {
        [self.collectionView setCollectionViewLayout:[[UICollectionViewFlowLayout alloc]init] animated:YES];
    } else{
        [self.collectionView setCollectionViewLayout:[[JLineLayout alloc]init] animated:YES];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //删除数据
    [self.imageArr removeObjectAtIndex:indexPath.item];
    //删ui（刷ui）
    [collectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
