//
//  NSString+Category.h
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

// 判断是否为String类型
#define STR_Class(str) [str isKindOfClass:[NSString class]]

// 判断字符串是否为空或者为空字符串
#define STR_Is_NullOrEmpty(str) (str==nil||[str isEqualToString:@""])

// 判断字符串不为空并且不为空字符串
#define STR_Not_NullAndEmpty(str) (str!=nil&&![str isEqualToString:@""])

/// 获取一个字符串转换为URL
#define STR_Url(str) [NSURL URLWithString:str]


#pragma mark - 顺便加一下NSDictionary、NSArray的非空判断
/// 判断dic存在，且是NSDictionary类型，且count值大于0
#define XONE_Dic_Is_Valid(dic) (dic && [dic isKindOfClass:[NSDictionary class]] && dic.count > 0)

/// 判断dic不存在，或不是NSDictionary类型，或count值小于等于0
#define XONE_Dic_Not_Valid(dic) (!dic || ![dic isKindOfClass:[NSDictionary class]] || dic.count <= 0)


/// 判断ary存在，且是NSArray类型，且count值大于0
#define XONE_Ary_Is_Valid(ary) (ary && [ary isKindOfClass:[NSArray class]] && ary.count > 0)

/// 判断ary不存在，或不是NSArray类型，或count值小于等于0
#define XONE_Ary_Not_Valid(ary) (!ary || ![ary isKindOfClass:[NSArray class]] || ary.count <= 0)


@interface NSString (Category)

NSString *getTrimString(NSString *str);

NSAttributedString *resetLineHeightMultiple(NSInteger lineHeightMultiple, NSString *str);

+ (float)getTextHeight:(float)textWidth text:(NSString *)text withLineHiehtMultipe:(NSInteger)lineHiehtMultipe fontSize:(float)fontSize isSuo:(BOOL)isSuo;

+ (float)getTextHeight:(float)textWidth text:(NSString *)text fontSize:(float)fontSize isSuo:(BOOL)isSuo;

+ (float)getTextWidth:(float)textHeight text:(NSString *)text fontSize:(float)fontSize isSuo:(BOOL)isSuo;

NSMutableAttributedString *getAttributedString(NSString *markStr, NSUInteger markColor, NSString *defalutStr, NSUInteger defalutColor, float markFont, float defalutFont, BOOL isSou);

// 将post请求参数拼接成字符串
NSString *paramsFromDictionary(NSDictionary *params);

NSString *getPushName(NSInteger pinLoginType);

NSString *getPlaceholder(NSInteger pinLoginType);

NSString *getTopSenceTitle(NSInteger pinSenceType);

NSString *getUserName(NSString *name);

NSString *getRequestUrl(void);

@end
