//
//  PinUser.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/22.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "PinUser.h"

@implementation PinUser

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.guid = [[coder decodeObjectForKey:@"guid"] intValue];
        self.name = [coder decodeObjectForKey:@"name"];
        self.wechat = [coder decodeObjectForKey:@"wechat"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.address = [coder decodeObjectForKey:@"address"];
        self.avatar = [coder decodeObjectForKey:@"avatar"];
        self.modify_time = [coder decodeObjectForKey:@"modify_time"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[NSNumber numberWithInt:self.guid] forKey:@"guid"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.wechat forKey:@"wechat"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.avatar forKey:@"avatar"];
    [coder encodeObject:self.modify_time forKey:@"modify_time"];
}

@end
