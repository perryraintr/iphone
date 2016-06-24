//
//  DetailVoteModel.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/6/1.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "DetailVoteModel.h"

@implementation DetailVoteModel

- (float)vote_rate_a {
    float voteA = (int)((double)self.vote_count_a / (self.vote_count_a + self.vote_count_b) * 100) * 0.01;
    PLog(@"ghasgdhgasdhgasgdh  %zd, %zd, %f", self.vote_count_a, self.vote_count_b, voteA);

    return voteA;
}

- (float)vote_rate_b {
    float voteB = 1 - (int)((double)self.vote_count_a / (self.vote_count_a + self.vote_count_b) * 100) * 0.01;
    PLog(@"yghdhashdyyquiyui  %zd, %zd, %f", self.vote_count_a, self.vote_count_b, voteB);
    return voteB;
}

@end
