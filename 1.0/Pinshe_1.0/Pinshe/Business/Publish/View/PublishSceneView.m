//
//  PublishSceneView.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/26.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PublishSceneView.h"
#import "PublishSceneCell.h"

@implementation PublishSceneView

- (instancetype)initWithPinTopSceneType:(PinTopSceneType)pinTopSceneType withTag2Array:(NSArray *)tag2Array {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WITH, SCREEN_HEIGHT);
        self.bgView = Building_UIViewWithFrameAndSuperView(pinSheAppDelegate().window, CGRectMake(0, 0, SCREEN_WITH, SCREEN_HEIGHT));
        self.bgView.hidden = YES;
        self.bgView.alpha = 0;
        self.bgView.backgroundColor = HEXACOLOR(pinColorBlack, 0.5);
        
        self.sceneView = Building_UIViewWithSuperView(self.bgView);
        self.sceneView.backgroundColor = HEXCOLOR(pinColorWhite);
        self.publishButton = Building_UIButtonWithSuperView(self.bgView, self, @selector(publishButtonAction), HEXCOLOR(pinColorPink));
        
        self.publishButton.backgroundColor = HEXCOLOR(pinColorLightGray);
        self.publishButton.enabled = NO;
        
        [self.publishButton setTitle:@"确认并发布" forState:UIControlStateNormal];
        [self.publishButton setTitleColor:HEXCOLOR(pinColorWhite) forState:UIControlStateNormal];
        self.publishButton.titleLabel.font = Font(fFont19);
        
        self.titleLabel = Building_UILabelWithSuperView(self.sceneView, FontBold(fFont12), HEXCOLOR(pinColorLightPink), NSTextAlignmentCenter, 1);
        self.titleLabel.text = @"请选择最适合它的情景";
        
        [self.publishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.bgView);
            make.height.equalTo(@(FITHEIGHT(56)));
        }];
        
        [self.sceneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.bottom.equalTo(self.publishButton.mas_top);
            make.height.equalTo(@(FITHEIGHT(300)));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.sceneView);
            make.height.equalTo(@(FITHEIGHT(62)));
        }];
        
        self.sceneArray = @[@"白领居家", @"办公室小确幸", @"人在旅途", @"生命在于运动"];
        self.dictionary = [NSMutableDictionary dictionary];
        
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, FITHEIGHT(62), SCREEN_WITH, FITHEIGHT(238)) style:UITableViewStylePlain];
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableview.delegate = self;
        self.tableview.dataSource = self;
        [self.sceneView addSubview:_tableview];
        self.tableview.showsHorizontalScrollIndicator = NO;
        self.tableview.showsVerticalScrollIndicator = NO;
        self.tableview.scrollEnabled = NO;
    
        int typeTag = pinTopSceneType - 1;
        for (int i = 0; i < self.sceneArray.count; i++) {
            if (tag2Array.count > 0) { // 来自我发布的
                for (NSNumber *number in tag2Array) {
                    if (i == [number intValue] - 1) {
                        [self.dictionary setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:i]];
                        break;
                    } else {
                        [self.dictionary setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:i]];
                    }
                }
                
            } else { // 来自top10 页面的
                if (i == typeTag) {
                    [self.dictionary setObject:[NSNumber numberWithBool:YES] forKey:[NSNumber numberWithInteger:i]];
                } else {
                    [self.dictionary setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithInteger:i]];
                }
            }
        }
        
        if (pinTopSceneType > 0 || tag2Array.count > 0) {
            self.publishButton.backgroundColor = HEXCOLOR(pinColorLightPink);
            self.publishButton.enabled = YES;
        }
    }
    return self;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FITHEIGHT(59);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    PublishSceneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PublishSceneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    BOOL isSelected = [[self.dictionary objectForKey:[NSNumber numberWithInteger:indexPath.row]] boolValue];
    [cell resetPublishSceneCell:isSelected withStr:[self.sceneArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BOOL isSelected = [[self.dictionary objectForKey:[NSNumber numberWithInteger:indexPath.row]] boolValue];
    
    NSMutableArray *sureArray = [self chooseArray];
    if (sureArray.count == 2 && !isSelected) {
        self.publishButton.backgroundColor = HEXCOLOR(pinColorLightPink);
        self.publishButton.enabled = YES;

    } else {
        if (sureArray.count == 0) {
            self.publishButton.backgroundColor = HEXCOLOR(pinColorLightPink);
            self.publishButton.enabled = YES;
        } else if (isSelected && sureArray.count == 1) {
            self.publishButton.backgroundColor = HEXCOLOR(pinColorLightGray);
            self.publishButton.enabled = NO;
        }
        [self.dictionary setObject:[NSNumber numberWithBool:!isSelected] forKey:[NSNumber numberWithInteger:indexPath.row]];
        [tableView reloadData];
    }

}

- (void)publishButtonAction {
    [self homeFrame];
    if (self.publishBlock) {
        self.publishBlock([self chooseArray]);
    }
}

- (void)publishBlock:(PublishSceneChooseBlock)block {
    self.publishBlock = block;
}

- (NSMutableArray *)chooseArray {
    NSMutableArray *sureArray = [NSMutableArray array];
    for (int i = 0; i < self.sceneArray.count; i++) {
        BOOL isCircleSel = [[self.dictionary objectForKey:[NSNumber numberWithInteger:i]] boolValue];
        if (isCircleSel) {
            [sureArray addObject:[NSNumber numberWithInteger:i]];
        }
    }
    return sureArray;
}


#pragma mark - 显示隐藏动画
- (void)homeFrame {
    [UIView animateWithDuration:0.2 animations:^{
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
    }];
}

- (void)showFrame {
    self.bgView.hidden = NO;
    self.bgView.alpha = 1;
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        
    }];
}

@end
