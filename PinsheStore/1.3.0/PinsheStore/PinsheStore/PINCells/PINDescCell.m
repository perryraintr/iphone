


//
//  PINDescCell.m
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/2.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINDescCell.h"
#import "PINStoreModel.h"

@implementation PINDescCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self buildingUI];
    }
    return self;
}

- (void)buildingUI {
    self.descLabel = Building_UILabelWithSuperView(self.contentView, Font(fFont16), HEXCOLOR(pinColorTextDarkGray), NSTextAlignmentLeft, 0);
    
    self.descButton = Building_UIButtonWithSuperView(self.contentView, self, @selector(descAction), nil);
    [self.descButton setTitle:@"阅读全文" forState:UIControlStateNormal];
    [self.descButton setTitleColor:HEXCOLOR(pinColorPink) forState:UIControlStateNormal];
    self.descButton.titleLabel.font = Font(fFont16);
    self.descButton.hidden = NO;
}

- (void)descAction {
    if (self.descBlock) {
        self.descBlock();
    }
}

- (void)descBlockAction:(DescBlock)block {
    self.descBlock = block;
}

- (void)layoutUI:(NSString *)descString isExpand:(BOOL)isExpand {
    
    CGFloat descHeight = [NSString getTextHeight:SCREEN_WITH - 40 text:descString withLineHiehtMultipe:0 withLineSpacing:10 fontSize:fFont16 isSuo:YES];
    
    if (isExpand || descHeight <= 200) {
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(5);
            make.height.equalTo(@(descHeight));
        }];
        
        self.descButton.frame = CGRectZero;
        self.descButton.hidden = YES;
        
    } else {
        
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.contentView).offset(5);
            make.height.equalTo(@(descHeight > 200 ? 200 : descHeight));
        }];
        
        self.descButton.hidden = NO;
        [self.descButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.top.equalTo(self.descLabel.mas_bottom).offset(5);
            make.height.equalTo(@(25));
        }];
    }
    
}

- (void)resetDescCell:(PINStoreModel *)model isExpand:(BOOL)isExpand {
    self.descLabel.attributedText = resetLineHeightMultiple(0, 10, model.storeDescription);
    [self layoutUI:model.storeDescription isExpand:isExpand];
}

@end
