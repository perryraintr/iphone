//
//  UITableView+Building.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Building)

/// plain
UITableView *Building_UITableView(id <UITableViewDataSource, UITableViewDelegate> delegate, UITableViewCellSeparatorStyle separatorStyle);

UITableView *Building_UITableViewWithFrame(CGRect frame, id <UITableViewDataSource, UITableViewDelegate> delegate, UITableViewCellSeparatorStyle separatorStyle);

/// style
UITableView *Building_UITableViewWithStyle(UITableViewStyle style, id <UITableViewDataSource, UITableViewDelegate> delegate, UITableViewCellSeparatorStyle separatorStyle);

UITableView *Building_UITableViewWithStyleAndFrame(CGRect frame, UITableViewStyle style, id <UITableViewDataSource, UITableViewDelegate> delegate, UITableViewCellSeparatorStyle separatorStyle);

@end
