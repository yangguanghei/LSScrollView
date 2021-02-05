//
//  ThirdViewController.m
//  14.scroll慢动作
//
//  Created by 梁森 on 2021/2/5.
//  Copyright © 2021 apple. All rights reserved.
//

#import "ThirdViewController.h"


#define num 4 // 几页
#define scrollBarH 10 // 滚动条的高度
#define miniScrollBarW 20 // 滚动条最小的宽度

@interface ThirdViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * scrollControl;
@property (nonatomic, assign) CGFloat starOffsetX;
@property (nonatomic, strong) NSMutableArray * views;

@end

@implementation ThirdViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor greenColor];
  [self.view addSubview:self.scrollView];
  [self.view addSubview:self.scrollControl];
		
  self.scrollControl.frame = CGRectMake(0, 50, self.scrollView.frame.size.width / num, scrollBarH);
	
	UIView * subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.scrollControl.frame.size.width * 0.5, scrollBarH)];
	subView.backgroundColor = [UIColor blackColor];
	subView.center = CGPointMake(self.scrollControl.frame.size.width * 0.5, self.scrollControl.frame.size.height * 0.5);
	[self.scrollControl addSubview:subView];
	
  for (NSInteger i = 0; i < num; i ++) {
	UIView * yellowView = [UIView new];
	yellowView.backgroundColor = [UIColor yellowColor];
	[self.view addSubview:yellowView];
	yellowView.frame = CGRectMake(i * self.scrollControl.frame.size.width, 48, self.scrollControl.frame.size.width, 2);
	[self.views addObject:yellowView];
  }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  self.starOffsetX = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	if (scrollView.isTracking == YES || scrollView.isDecelerating == YES) {	// 用户滑动引起的才处理
		CGFloat progress = 0;	// 从源位置滑动到目标位置滑动的进度
		CGFloat sourceIndex = 0;	// 源偏移下标
		CGFloat targetIndex = 0;	// 目标偏移下标
		CGFloat contentOffsetX = scrollView.contentOffset.x;	// 偏移量
		CGFloat scrollWidth = scrollView.bounds.size.width;	// scroll宽度
		CGFloat offsetIndex = contentOffsetX / scrollWidth;	// 偏移下标（float类型）
		if (contentOffsetX > 0) {  //
			progress = offsetIndex - (int)(offsetIndex);
			sourceIndex = (int)(offsetIndex);
			targetIndex = sourceIndex + 1;	// 即使目标下标比源下标小也可这样处理
			int maxIndex = (int)(scrollView.contentSize.width / scrollView.bounds.size.width);	// 最后的偏移下标
			if (targetIndex + 1 > maxIndex) {	// 滑动到最右端
				return;
			}
		}
		CGFloat sourceX = self.scrollControl.frame.size.width * sourceIndex;
		CGFloat moveX = self.scrollControl.frame.size.width;
		CGFloat moveL = moveX * progress;
		self.scrollControl.frame = CGRectMake(sourceX + moveL, self.scrollControl.frame.origin.y, self.scrollControl.frame.size.width, self.scrollControl.frame.size.height);
	}
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
