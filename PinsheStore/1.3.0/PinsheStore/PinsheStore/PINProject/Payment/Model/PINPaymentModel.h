//
//  PINPaymentModel.h
//  PinsheStore
//
//  Created by 史瑶荣 on 2016/11/4.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PINPaymentModel : NSObject

@property (assign, nonatomic) int guid;

@property (assign, nonatomic) int type;

@property (strong, nonatomic) NSString *company;

@property (strong, nonatomic) NSString *account;

@property (strong, nonatomic) NSString *holder;

@end
