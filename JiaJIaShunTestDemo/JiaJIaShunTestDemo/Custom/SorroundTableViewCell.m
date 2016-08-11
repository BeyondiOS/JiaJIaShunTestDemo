//
//  SorroundTableViewCell.m
//  JiaJIaShunTestDemo
//
//  Created by Myth on 16/8/5.
//  Copyright © 2016年 Myth. All rights reserved.
//

#import "SorroundTableViewCell.h"

@interface SorroundTableViewCell ()

@property(weak, nonatomic) IBOutlet UILabel *deptNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *addrLabel;
@property(weak, nonatomic) IBOutlet UILabel *snCodeLabel;
@property(weak, nonatomic) IBOutlet UIImageView *phoneImageV;
@property(weak, nonatomic) IBOutlet UILabel *letterLabel;

@end

@implementation SorroundTableViewCell

- (void)awakeFromNib {
  // ------字母
  self.letterLabel.textAlignment = NSTextAlignmentCenter;
  self.letterLabel.layer.cornerRadius =
      CGRectGetWidth(self.letterLabel.frame) / 2;
  self.letterLabel.layer.masksToBounds = YES;
  self.letterLabel.layer.borderWidth = 1;
  self.letterLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;

  // ------详细地址
  self.addrLabel.numberOfLines = 2;

  // ------拨打电话
  self.phoneImageV.userInteractionEnabled = YES;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(handleSingleFingerEvent:)];
  tap.delegate = self;
  [self.phoneImageV addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender {
  UIWebView *phoneWebV = [[UIWebView alloc] initWithFrame:CGRectZero];
  NSString *phone =
      [self.model.phone stringByReplacingOccurrencesOfString:@" "
                                                  withString:@""];
  NSURL *phoneUrl =
      [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
  [phoneWebV loadRequest:[NSURLRequest requestWithURL:phoneUrl]];
  [self addSubview:phoneWebV];
}

- (void)setModel:(Sorround *)model {
  if (_model != model) {
    _model = model;
    self.letterLabel.text = model.letter;
    self.deptNameLabel.text = model.deptName;
    self.addrLabel.text = model.addr;
    self.snCodeLabel.text =
        [NSString stringWithFormat:@"%ld", [model.snCode integerValue]];
  }
}

@end
