//
//  IndexVote.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/18.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "IndexVote.h"

@implementation IndexVote

- (float)vote_rate_a:(BOOL)isLeft {
    if (isLeft) {
        self.vote_count_a += 1;
    }
   float voteA = (int)((double)self.vote_count_a / (self.vote_count_a + self.vote_count_b) * 100) * 0.01;
    PLog(@"ghasgdhgasdhgasgdh  %zd, %zd, %f", self.vote_count_a, self.vote_count_b, voteA);
    return voteA;
}

- (float)vote_rate_b:(BOOL)isLeft {
    if (!isLeft) {
        self.vote_count_b += 1;
    }
    
    float voteB = 1 - (int)((double)self.vote_count_a / (self.vote_count_a + self.vote_count_b) * 100) * 0.01;
    PLog(@"yghdhashdyyquiyui  %zd, %zd, %f", self.vote_count_a, self.vote_count_b, voteB);
    return voteB;
}

@end
