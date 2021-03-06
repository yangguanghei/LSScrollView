//
//  ViewController.m
//  14.scroll慢动作
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#import "ViewController.h"

#import "NextViewController.h"

#define num 4 // 几页
#define scrollBarH 10 // 滚动条的高度
#define miniScrollBarW 20 // 滚动条最小的宽度

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * scrollControl;
@property (nonatomic, assign) CGFloat starOffsetX;
@property (nonatomic, strong) NSMutableArray * views;
/// 是否禁止滚动协议
@property (nonatomic, assign) BOOL isForbidScrollDelegate;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor greenColor];
  [self.view addSubview:self.scrollView];
  [self.view addSubview:self.scrollControl];
  self.scrollControl.frame = CGRectMake(0, 50, self.scrollView.frame.size.width / num, scrollBarH);
  for (NSInteger i = 0; i < num; i ++) {
    UIView * yellowView = [UIView new];
    yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellowView];
    yellowView.frame = CGRectMake(i * self.scrollControl.frame.size.width, 48, self.scrollControl.frame.size.width, 2);
    [self.views addObject:yellowView];
  }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  NextViewController * nextVC = [NextViewController new];
  [self presentViewController:nextVC animated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  self.starOffsetX = scrollView.contentOffset.x;
  self.isForbidScrollDelegate = NO;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if (self.isForbidScrollDelegate) {  // 当通过代码设置scrollView的偏移量时，不再走此方法
    return;
  }
  CGFloat progress = 0;
  CGFloat sourceIndex = 0;
  CGFloat targetIndex = 0;
  CGFloat contentOffsetX = scrollView.contentOffset.x;
  CGFloat scrollWidth = scrollView.bounds.size.width;
  CGFloat offsetIndex = contentOffsetX / scrollWidth;
  if (contentOffsetX > 0) {  // 左滑
    progress = offsetIndex - floor(offsetIndex);
    sourceIndex = (int)(contentOffsetX / scrollWidth);
    targetIndex = sourceIndex + 1;
    if (targetIndex >= num) {
      UIView * view = self.views[num-1];
      CGFloat width = view.frame.size.width*(1-progress*3.5);
      if (width <= miniScrollBarW) {
        width = miniScrollBarW;
      }
      CGFloat x = view.frame.origin.x + (view.frame.size.width - width);
      self.scrollControl.frame = CGRectMake(x, self.scrollControl.frame.origin.y, width, self.scrollControl.frame.size.height);
      return;
    }
    if (contentOffsetX - self.starOffsetX == scrollWidth) {
      progress = 1;
      targetIndex = sourceIndex;
    }
  }else{  // 右滑
    progress = 1 - (offsetIndex - floor(offsetIndex));
    if (contentOffsetX <= 0) {
      UIView * view = self.views[0];
      CGFloat pro = -offsetIndex / 1;
      CGFloat width = view.frame.size.width - pro*view.frame.size.width * 3.5;
      if (width <= miniScrollBarW) {
        width = miniScrollBarW;
      }
      self.scrollControl.frame = CGRectMake(view.frame.origin.x, self.scrollControl.frame.origin.y, width, self.scrollControl.frame.size.height);
      return;
    }
    targetIndex = (int)(contentOffsetX / scrollWidth);
    sourceIndex = targetIndex + 1;
    if (sourceIndex >= num) {
      sourceIndex = num - 1;
    }
    if (progress == 1) {
      sourceIndex = targetIndex;
    }
  }
//  NSLog(@"sourceIndex:%d😄targetIndex:%d😄progress:%f😄offsetIndex:%f😄floor(offsetIndex):%f", (int)sourceIndex, (int)targetIndex, progress, offsetIndex, floor(offsetIndex));
  UIView * sourceView = self.views[(int)sourceIndex];
  UIView * targetView = self.views[(int)targetIndex];
  CGFloat totalMoveX = targetView.frame.origin.x - sourceView.frame.origin.x;
  CGFloat moveLength = totalMoveX * progress;
  self.scrollControl.frame = CGRectMake(sourceView.frame.origin.x + moveLength, self.scrollControl.frame.origin.y, self.scrollControl.frame.size.width, self.scrollControl.frame.size.height);
}

- (UIScrollView *)scrollView{
  if (_scrollView == nil) {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * num, _scrollView.frame.size.height);
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.backgroundColor = [UIColor redColor];
  }
  return _scrollView;
}
- (UIView *)scrollControl{
  if (_scrollControl == nil) {
    _scrollControl = [UIView new];
    _scrollControl.backgroundColor = [UIColor greenColor];
    _scrollControl.layer.cornerRadius = scrollBarH * 0.5;
    _scrollControl.layer.masksToBounds = YES;
  }
  return _scrollControl;
}
- (NSMutableArray *)views{
  if (_views == nil) {
    _views = [NSMutableArray array];
  }
  return _views;
}

@end
