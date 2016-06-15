//
//  MyCentralSegmentView.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/15.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompletionIndexBlock) (NSUInteger index);

@interface MyCentralSegmentView : UIView

@property (nonatomic, copy) CompletionIndexBlock completionIndexBlock;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)segmentChangeSelect:(CompletionIndexBlock)completion;


@end
