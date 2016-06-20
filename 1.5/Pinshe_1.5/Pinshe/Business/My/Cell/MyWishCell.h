//
//  MyWishCell.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/5/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyWishModel;

typedef void(^MyWishPushDetailBlock)(MyWishModel *mywishModel);
typedef void(^MyWishSupportBlock)(MyWishModel *mywishModel);

@interface MyWishCell : UITableViewCell

@property (nonatomic, copy) MyWishPushDetailBlock myWishPushDetailBlock;
@property (nonatomic, copy) MyWishSupportBlock myWishSupportBlock;

@property (nonatomic, strong) MyWishModel *myWishModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)resetMyWishCell:(NSMutableArray *)collectionArray;

- (void)wishPushDetail:(MyWishPushDetailBlock)block;
- (void)wishSupoort:(MyWishSupportBlock)block;


@end
