//
//  PINStoreDescController.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/11/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINStoreDescController.h"
#import "PINTextView.h"

@interface PINStoreDescController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property (strong, nonatomic) PINTextView *descTextview;

@property (weak, nonatomic) id delegate;

@end

@implementation PINStoreDescController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店故事";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self findFirstResponder] resignFirstResponder];
}

- (void)initBaseParams {
    self.delegate = [self.postParams objectForKey:@"delegate"];
}

- (void)saveDesc {
    [[self findFirstResponder] resignFirstResponder];

    if (self.descTextview.text.length == 0) {
        [self chatShowHint:@"请填写门店故事"];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:NSSelectorFromString(@"resetDescText:")]) {
        SUPPRESS_PERFORMSELECTOR_LEAK_WARNING([self.delegate performSelector:NSSelectorFromString(@"resetDescText:") withObject:self.descTextview.text]);
        [super backAction];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 20;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = Building_UIViewWithFrame(CGRectMake(0, 0, SCREEN_WITH, 0));
    if (section == 1) {
        view.height = 20;
    } else {
        view.height = 0;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *descCellId = @"descCellId";
        UITableViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:descCellId];
        if (descCell == nil) {
            descCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:descCellId];
            descCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.descTextview = [[PINTextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WITH, 200)];
            self.descTextview.font = Font(fFont16);
            self.descTextview.placeholder = @"请填写门店故事，字数最多不超过800";
            self.descTextview.text = [self.postParams objectForKey:@"desc"];
            [descCell.contentView addSubview:_descTextview];
        }
        return descCell;
    } else {
        static NSString *buttonCellId = @"cellId";
        UITableViewCell *buttonCell = [tableView dequeueReusableCellWithIdentifier:buttonCellId];
        if (buttonCell == nil) {
            buttonCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttonCellId];
            buttonCell.selectionStyle = UITableViewCellSelectionStyleNone;
            buttonCell.backgroundColor = HEXCOLOR(pinColorMainBackground);
            
            UIButton *creatStoreButton = Building_UIButtonWithSuperView(buttonCell.contentView, self, @selector(saveDesc), [UIColor clearColor]);
            [creatStoreButton setTitle:@"保存" forState:UIControlStateNormal];
            creatStoreButton.titleLabel.font = FontNotSou(fFont16);
            [creatStoreButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
            [creatStoreButton setBackgroundColor:HEXCOLOR(pinColorGreen)];
            creatStoreButton.layer.cornerRadius = 5;
            creatStoreButton.layer.masksToBounds = YES;
            [creatStoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(buttonCell.contentView).offset(20);
                make.right.equalTo(buttonCell.contentView).offset(-20);
                make.top.bottom.equalTo(buttonCell.contentView);
            }];
        }
        return buttonCell;
    }
}

@end
