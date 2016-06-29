//
//  PINMainModuleService.m
//  PINNetworkingManager
//
//  Created by 雷亮 on 16/5/31.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import "PINMainModuleService.h"
#import "NSObject+YYModel.h"
#import "IndexVote.h"
#import "PinUser.h"
#import "PINNetActivityIndicator.h"

static NSString *const kAddUserPath    = @"adduser.a";
static NSString *const kAddVotePath    = @"addvote.a";
static NSString *const kAddPostPath    = @"addpost.a";
static NSString *const kAddCommentPath = @"addcomment.a";
static NSString *const kModifyUserPath = @"modifyuser.a";
static NSString *const kModifyVotePath = @"modifyvote.a";
static NSString *const kModifyPostPath = @"modifypost.a";
static NSString *const kVotePath       = @"vote.a";
static NSString *const kPostPath       = @"post.a";
static NSString *const kTagPath        = @"tag.a";
static NSString *const kMessagePath    = @"message.a";
static NSString *const kCommentPath    = @"comment.a";

@interface PINMainModuleService ()

@property (nonatomic, strong) PINNetworkingManager *manger;

@end

@implementation PINMainModuleService

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manger = [[PINNetworkingManager alloc] init];
    }
    return self;
}

// 登录
- (void)loginRequestWithWechat:(NSString *)wecaht wcid:(NSString *)wcid avatar:(NSString *)avater finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:wecaht forKey:@"name"];
    [paramDic setObject:wecaht forKey:@"wechat"];
    [paramDic setObject:wcid forKey:@"wcid"];
    [paramDic setObject:avater forKey:@"avatar"];
    

    [_manger POST:kAddUserPath params:paramDic finished:^(NSDictionary *result, NSString *message) {
        [PINBaseRefreshSingleton instance].refreshCompare = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralCollection = 1;
        [PINBaseRefreshSingleton instance].refreshMyCentralPublish = 1;
        [PINBaseRefreshSingleton instance].refreshRecommend = 1;
        [PINBaseRefreshSingleton instance].refreshShit = 1;
        
        [UserDefaultManagement instance].userId = [[result objectForKey:@"guid"] intValue];
        [UserDefaultManagement instance].pinUser = [PinUser modelWithDictionary:result];
        
        finished(result, message);
        
        [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
        
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    }];
}

// 未登录获取id
- (void)addUserRequestWithIndicatorStyle:(PinIndicatorStyle)indicatorStyle finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:indicatorStyle];
    
    [_manger GET:kAddUserPath params:@"" finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    }];
}

// 获取品选列表
- (void)voteRequestWithIndicatorStyle:(PinIndicatorStyle)indicatorStyle voteArray:(NSMutableArray *)voteArray finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:indicatorStyle];

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    if (voteArray.count > 0) {
        NSString *paramString = @"";
        for (IndexVote *indexVote in voteArray) {
            paramString = [NSString stringWithFormat:@"%@,%zd", paramString, indexVote.vote_guid];
        }
        paramString = [paramString substringFromIndex:1];
        [paramDic setObject:paramString forKey:@"vids"];
        PLog(@"vids ===== %@", paramString);
    }
    
    [_manger POST:kVotePath params:paramDic finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    }];
    
}

- (void)compareRequestWithVoteId:(int)voteId finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"vid=%zd", voteId];
    [_manger GET:kVotePath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

- (void)modifyVoteRequest:(int)voteId isLeft:(BOOL)isLeft finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&id=%zd&%@", [UserDefaultManagement instance].userId, voteId, isLeft ? @"a=1" : @"b=1"];

    [_manger GET:kModifyVotePath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 推荐页
- (void)recommendSceneRequestWithCurrentPage:(int)currentPage indicatorStyle:(PinIndicatorStyle)indicatorStyle finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:indicatorStyle];

    NSString *paramStr = [NSString stringWithFormat:@"t1=1&page=%zd", currentPage];
    
    [_manger GET:kTagPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    }];
}

// 推荐吐槽列表
- (void)listRequestWithCurrentPage:(int)currentPage isPost:(BOOL)isPost finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&t1=%zd&page=%zd", [UserDefaultManagement instance].userId, isPost ? 1 : 2, currentPage];

    [_manger GET:kPostPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 点赞移除赞
- (void)zanRequestWithMethodName:(NSString *)methodName zanId:(NSString *)zanId finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"%@&uid=%zd", zanId, [UserDefaultManagement instance].userId];
    
    [_manger GET:methodName params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 消息列表页
- (void)messageRequestWithIndicatorStyle:(PinIndicatorStyle)indicatorStyle currentPage:(int)currentPage finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:indicatorStyle];
    
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&page=%zd", [UserDefaultManagement instance].userId, currentPage];

    [_manger GET:kMessagePath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    }];
}

// 消息小红点
- (void)messageCountRequestWithFinished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    NSString *messageTime = @"";
    if ([UserDefaultManagement instance].messageClickTime.length > 0) {
        messageTime = [UserDefaultManagement instance].messageClickTime;
    } else {
        messageTime = [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]];
        [UserDefaultManagement instance].messageClickTime = messageTime;
    }
    [paramsDic setObject:messageTime forKey:@"time"];
    [paramsDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    
    [_manger GET:kMessagePath params:paramsFromDictionary(paramsDic) finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 评论列表页
- (void)commentRequestWithCurrentPage:(int)currentPage currentId:(NSString *)currentId finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"%@&page=%zd", currentId, currentPage];
    
    [_manger GET:kCommentPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 回复评论
- (void)replyRequestUid:(int)uid ubid:(int)ubid currentId:(NSString *)currentId replyStr:(NSString *)replyStr finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"&uid=%zd&uaid=%zd&ubid=%zd", uid, [UserDefaultManagement instance].userId, ubid];
    NSString *paramString = [NSString stringWithFormat:@"%@%@&m=%@", currentId, paramStr, replyStr];
    
    [_manger GET:kAddCommentPath params:paramString finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 更改用户信息
- (void)updateUserInfoWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address picImageChange:(BOOL)picImageChange picImage:(UIImage *)picImage finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"id"];
    
    if (picImageChange) {
        NSString *fileName = [NSString stringWithFormat:@"%zd%@userImage.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
        [paramDic setObject:@[picImage] forKey:@"imageArray"];
        [paramDic setObject:@[fileName] forKey:@"fileNameArray"];
        [paramDic setObject:@"file" forKey:@"key"];
    }
    
    if (STR_Not_NullAndEmpty(name)) {
        [paramDic setObject:name forKey:@"name"];
    }
    if (STR_Not_NullAndEmpty(phone)) {
        [paramDic setObject:phone forKey:@"phone"];
    }
    if (STR_Not_NullAndEmpty(address)) {
        [paramDic setObject:address forKey:@"address"];
    }

    [_manger UploadImagesWithMethodName:kModifyUserPath params:paramDic imageNames:[paramDic objectForKey:@"fileNameArray"] images:[paramDic objectForKey:@"imageArray"] finished:^(NSDictionary *result, NSString *message) {
        [UserDefaultManagement instance].pinUser = [PinUser modelWithDictionary:result];
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    }];
}

/// 个人中心
// 收藏和发布
- (void)myCentralRequestWithMethodName:(NSString *)methodName indicatorStyle:(PinIndicatorStyle)indicatorStyle currentPage:(int)currentPage finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:indicatorStyle];
    
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&page=%zd", [UserDefaultManagement instance].userId, currentPage];
    
    [_manger GET:methodName params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    }];
}

// 详情
- (void)detailRequestWithMethodName:(NSString *)methodName currentId:(NSString *)currentId finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&%@", [UserDefaultManagement instance].userId, currentId];

    [_manger GET:methodName params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    }];
}

// top10页面商品和轮播图
- (void)topProductAndLoopScrollAdWithMethodName:(NSString *)methodName indicatorStyle:(PinIndicatorStyle)indicatorStyle tag_t2:(int)tag_t2 finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:indicatorStyle];
    NSString *paramStr = [NSString stringWithFormat:@"t1=1&t2=%zd", tag_t2];
    
    [_manger GET:methodName params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:indicatorStyle];
    }];
}

// top10，推荐列表
- (void)topListWithCurrentPage:(int)currentPage tag_t2:(int)tag_t2 finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSString *paramStr = [NSString stringWithFormat:@"uid=%zd&t1=1&t2=%zd&page=%zd", [UserDefaultManagement instance].userId, tag_t2, currentPage];
    [_manger GET:kPostPath params:paramStr finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

- (void)votePublishRequestWithImageArray:(NSArray *)imageArray name:(NSString *)name finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];

    NSString *firstFileName = [NSString stringWithFormat:@"%zd%@tag311.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    NSString *secondFileName = [NSString stringWithFormat:@"%zd%@tag322.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    NSArray *fileNameArry = @[firstFileName, secondFileName];
    [paramDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    [paramDic setObject:name forKey:@"name"];

    [_manger UploadImagesWithMethodName:kAddVotePath params:paramDic imageNames:fileNameArry images:imageArray finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 品选编辑发布
- (void)voteEditPublishRequestWithID:(int)vid imageArray:(NSArray *)imageArray name:(NSString *)name finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    NSString *firstFileName = [NSString stringWithFormat:@"%zd%@tag311.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    NSString *secondFileName = [NSString stringWithFormat:@"%zd%@tag322.png", [UserDefaultManagement instance].userId, [CommonFunction stringFromDateyyyy_MM_dd_HH_mm_ss:[NSDate date]]];
    NSArray *fileNameArry = @[firstFileName, secondFileName];
    [paramDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    [paramDic setObject:name forKey:@"name"];
    [paramDic setObject:[NSNumber numberWithInt:vid] forKey:@"id"];
    
    [_manger UploadImagesWithMethodName:kModifyVotePath params:paramDic imageNames:fileNameArry images:imageArray finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 获取发布帖子信息
- (void)postInfoRequestWithGuid:(int)guid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    [PINNetActivityIndicator startActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    [_manger GET:kPostPath params:[NSString stringWithFormat:@"pid=%zd", guid] finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
        [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
        [PINNetActivityIndicator stopActivityIndicator:PinIndicatorStyle_DefaultIndicator];
    }];
}

// 发布推荐，吐槽帖子
- (void)postPublishRequestWithImageArray:(NSMutableArray *)imageArray fileNameArray:(NSMutableArray *)fileNameArray t1:(NSString *)t1 name:(NSString *)name description:(NSString *)description mechandiseArray:(NSMutableArray *)mechandiseArray finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (imageArray.count > 1) {
        [imageArray removeLastObject];
    }
    [paramDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    [paramDic setObject:t1 forKey:@"t1"];
    // 名称
    if (STR_Not_NullAndEmpty(name)) {
        [paramDic setObject:name forKey:@"name"];
    }
    // 推荐语
    if (STR_Not_NullAndEmpty(description)) {
        [paramDic setObject:description forKey:@"description"];
    }
    // 商品类别
    if (mechandiseArray.count > 0) {
        NSString *mechandse = @"";
        for (NSNumber *number in mechandiseArray) {
            NSString *str = [NSString stringWithFormat:@",%zd", [number integerValue] + 1];
            mechandse = [mechandse stringByAppendingString:str];
        }
        mechandse = [mechandse substringFromIndex:1];
        [paramDic setObject:mechandse forKey:@"t2"];
    }
    
    [_manger UploadImagesWithMethodName:kAddPostPath params:paramDic imageNames:fileNameArray images:imageArray finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

// 发布推荐，吐槽帖子
- (void)postEditPublishRequestWithGuid:(int)guid imageArray:(NSMutableArray *)imageArray fileNameArray:(NSMutableArray *)fileNameArray t1:(NSString *)t1 name:(NSString *)name description:(NSString *)description mechandiseArray:(NSMutableArray *)mechandiseArray finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure {
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    if (imageArray.count > 1) {
        [imageArray removeLastObject];
    }
    [paramDic setObject:[NSNumber numberWithInt:[UserDefaultManagement instance].userId] forKey:@"uid"];
    [paramDic setObject:t1 forKey:@"t1"];
    // 名称
    if (STR_Not_NullAndEmpty(name)) {
        [paramDic setObject:name forKey:@"name"];
    }
    // 推荐语
    if (STR_Not_NullAndEmpty(description)) {
        [paramDic setObject:description forKey:@"description"];
    }
    // 商品类别
    if (mechandiseArray.count > 0) {
        NSString *mechandse = @"";
        for (NSNumber *number in mechandiseArray) {
            NSString *str = [NSString stringWithFormat:@",%zd", [number integerValue] + 1];
            mechandse = [mechandse stringByAppendingString:str];
        }
        mechandse = [mechandse substringFromIndex:1];
        [paramDic setObject:mechandse forKey:@"t2"];
    }
    
    [paramDic setObject:[NSNumber numberWithInt:guid] forKey:@"id"];

    [_manger UploadImagesWithMethodName:kModifyPostPath params:paramDic imageNames:fileNameArray images:imageArray finished:^(NSDictionary *result, NSString *message) {
        finished(result, message);
    } failure:^(NSDictionary *result, NSString *message) {
        failure(result, message);
    }];
}

@end
