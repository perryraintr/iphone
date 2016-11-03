//
//  PINUser.m
//  PinsheStore
//
//  Created by 史瑶荣 on 16/9/12.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PINUser.h"

@implementation PINUser

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.guid = [[coder decodeObjectForKey:@"guid"] intValue];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.avatar = [coder decodeObjectForKey:@"avatar"];
        self.wechat_id = [coder decodeObjectForKey:@"wechat_id"];
        self.current = [[coder decodeObjectForKey:@"current"] floatValue];
        self.amount = [[coder decodeObjectForKey:@"amount"] floatValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[NSNumber numberWithInt:self.guid] forKey:@"guid"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeObject:self.wechat_id forKey:@"wechat_id"];
    [coder encodeObject:[NSNumber numberWithFloat:self.current] forKey:@"current"];
    [coder encodeObject:[NSNumber numberWithFloat:self.amount] forKey:@"amount"];
}

@end
