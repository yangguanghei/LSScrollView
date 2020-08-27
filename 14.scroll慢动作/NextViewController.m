//
//  NextViewController.m
//  14.scroll慢动作
//
//  Created by apple on 2020/8/27.
//  Copyright © 2020 apple. All rights reserved.
//

#import "NextViewController.h"

#import "LSScrollView.h"

@interface NextViewController ()

@property (nonatomic, strong) LSScrollView * scrollView;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.view.backgroundColor = [UIColor yellowColor];
  [self.view addSubview:self.scrollView];
  
}

- (LSScrollView *)scrollView{
  if (_scrollView == nil) {
    _scrollView = [[LSScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width) withTitles:@[@"", @"", @"", @""]];
  }
  return _scrollView;
}

@end
