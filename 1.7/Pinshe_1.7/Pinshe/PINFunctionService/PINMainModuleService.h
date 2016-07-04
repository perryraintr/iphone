//
//  PINMainModuleService.h
//  PINNetworkingManager
//
//  Created by 雷亮 on 16/5/31.
//  Copyright © 2016年 Leiliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PINNetworking.h"

@interface PINMainModuleService : NSObject

/// 以下是请求返回的数据，在controller里面使用的数据

/// 登录
- (void)loginRequestWithWechat:(NSString *)wecaht wcid:(NSString *)wcid avatar:(NSString *)avater finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 首页
// 未登录获取id
- (void)addUserRequestWithIndicatorStyle:(PinIndicatorStyle)indicatorStyle finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 请求品选列表
- (void)voteRequestWithIndicatorStyle:(PinIndicatorStyle)indicatorStyle voteArray:(NSMutableArray *)voteArray finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 点击品选接口
- (void)compareRequestWithVoteId:(int)voteId finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 编辑
- (void)modifyVoteRequest:(int)voteId isLeft:(BOOL)isLeft finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 推荐页
- (void)recommendSceneRequestWithCurrentPage:(int)currentPage indicatorStyle:(PinIndicatorStyle)indicatorStyle finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 推荐吐槽列表
- (void)listRequestWithCurrentPage:(int)currentPage isPost:(BOOL)isPost finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 点赞移除赞
- (void)zanRequestWithMethodName:(NSString *)methodName zanId:(NSString *)zanId finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 消息列表页
- (void)messageRequestWithIndicatorStyle:(PinIndicatorStyle)indicatorStyle currentPage:(int)currentPage finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 消息小红点
- (void)messageCountRequestWithFinished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 评论列表页
- (void)commentRequestWithCurrentPage:(int)currentPage currentId:(NSString *)currentId finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 回复评论
- (void)replyRequestUid:(int)uid ubid:(int)ubid currentId:(NSString *)currentId replyStr:(NSString *)replyStr finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 更改用户信息
- (void)updateUserInfoWithName:(NSString *)name phone:(NSString *)phone address:(NSString *)address picImageChange:(BOOL)picImageChange picImage:(UIImage *)picImage finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

/// 个人中心
// 收藏和发布
- (void)myCentralRequestWithMethodName:(NSString *)methodName indicatorStyle:(PinIndicatorStyle)indicatorStyle currentPage:(int)currentPage finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 详情
- (void)detailRequestWithMethodName:(NSString *)methodName currentId:(NSString *)currentId finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// top10页面商品和轮播图
- (void)topProductAndLoopScrollAdWithMethodName:(NSString *)methodName indicatorStyle:(PinIndicatorStyle)indicatorStyle tag_t2:(int)tag_t2 finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// top10，推荐列表
- (void)topListWithCurrentPage:(int)currentPage tag_t2:(int)tag_t2 finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 品选发布
- (void)votePublishRequestWithImageArray:(NSArray *)imageArray name:(NSString *)name finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 品选编辑发布
- (void)voteEditPublishRequestWithID:(int)vid imageArray:(NSArray *)imageArray name:(NSString *)name finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 获取发布帖子信息
- (void)postInfoRequestWithGuid:(int)guid finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 发布推荐，吐槽帖子
- (void)postPublishRequestWithImageArray:(NSMutableArray *)imageArray fileNameArray:(NSMutableArray *)fileNameArray t1:(NSString *)t1 name:(NSString *)name description:(NSString *)description mechandiseArray:(NSMutableArray *)mechandiseArray finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 发布编辑推荐，吐槽帖子
- (void)postEditPublishRequestWithGuid:(int)guid imageArray:(NSMutableArray *)imageArray fileNameArray:(NSMutableArray *)fileNameArray t1:(NSString *)t1 name:(NSString *)name description:(NSString *)description mechandiseArray:(NSMutableArray *)mechandiseArray finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

// 发布品类
- (void)tagDetailRequestWithCurrentPage:(int)currentPage finished:(PINServiceCallback)finished failure:(PINServiceFailure)failure;

@end
