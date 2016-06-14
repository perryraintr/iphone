//
//  UITableView+Building.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/7.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "UITableView+Building.h"

@implementation UITableView (Building)

UITableView *Building_UITableView(id <UITableViewDataSource, UITableViewDelegate> delegate, UITableViewCellSeparatorStyle separatorStyle) {
    return Building_UITableViewWithFrame(CGRectZero, delegate, separatorStyle);
}

UITableView *Building_UITableViewWithFrame(CGRect frame, id <UITableViewDataSource, UITableViewDelegate> delegate, UITableViewCellSeparatorStyle separatorStyle) {
    return Building_UITableViewWithStyleAndFrame(CGRectZero, UITableViewStylePlain, delegate, separatorStyle);
}

UITableView *Building_UITableViewWithStyle(UITableViewStyle style, id <UITableViewDataSource, UITableViewDelegate> delegate, UITableViewCellSeparatorStyle separatorStyle) {
    return Building_UITableViewWithStyleAndFrame(CGRectZero, style, delegate, separatorStyle);
}

UITableView *Building_UITableViewWithStyleAndFrame(CGRect frame, UITableViewStyle style, id <UITableViewDataSource, UITableViewDelegate> delegate, UITableViewCellSeparatorStyle separatorStyle) {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    if (delegate) { tableView.dataSource = delegate; }
    if (delegate) { tableView.delegate = delegate; }
    tableView.separatorStyle = separatorStyle;
    /// default
    tableView.backgroundColor = [UIColor clearColor];
    return tableView;
}

@end
