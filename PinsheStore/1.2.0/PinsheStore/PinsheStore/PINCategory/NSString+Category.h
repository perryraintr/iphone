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

#define XONE_Dic_Is_NullValid(dic) (dic && [dic isKindOfClass:[NSDictionary class]] && dic.count == 0)

/// 判断dic不存在，或不是NSDictionary类型，或count值小于等于0
#define XONE_Dic_Not_Valid(dic) (!dic || ![dic isKindOfClass:[NSDictionary class]] || dic.count <= 0)


/// 判断ary存在，且是NSArray类型，且count值大于0
#define XONE_Ary_Is_Valid(ary) (ary && [ary isKindOfClass:[NSArray class]] && ary.count > 0)

/// 判断ary不存在，或不是NSArray类型，或count值小于等于0
#define XONE_Ary_Not_Valid(ary) (!ary || ![ary isKindOfClass:[NSArray class]] || ary.count <= 0)


@interface NSString (Category)

// 去除空格
NSString *getTrimString(NSString *str);

// 验证是否为手机号
BOOL validateMobile(NSString *mobile);

// 日期转字符串
+ (NSString *)stringFromDateyyyy_MM_dd_HH_mm_ss:(NSDate *)aDate;

// 将post请求参数拼接成字符串
NSString *paramsFromDictionary(NSDictionary *params);

NSAttributedString *resetLineHeightMultiple(NSInteger lineHeightMultiple, NSInteger lineSpacing, NSString *str);

+ (float)getTextHeight:(float)textWidth text:(NSString *)text withLineHiehtMultipe:(NSInteger)lineHiehtMultipe withLineSpacing:(NSInteger)lineSpacing fontSize:(float)fontSize isSuo:(BOOL)isSuo;

+ (float)getTextHeight:(float)textWidth text:(NSString *)text fontSize:(float)fontSize isSuo:(BOOL)isSuo;

+ (float)getTextWidth:(float)textHeight text:(NSString *)text fontSize:(float)fontSize isSuo:(BOOL)isSuo;

NSMutableAttributedString *getAttributedString(NSString *markStr, NSUInteger markColor, NSString *defalutStr, NSUInteger defalutColor, float markFont, float defalutFont, BOOL isSou);

/**
 * 返回值是该字符串所占的大小(width, height)
 * @param font : 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 * @param maxSize : 为限制改字体的最大宽和高(如果显示一行, 则宽高都设置为MAXFLOAT, 如果显示为多行, 只需将宽设置一个有限定长值, 高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

#pragma mark 以下的方法仅作调试使用
//-(NSString *)stringDevicetoken:(NSData *)deviceToken;
//
//-(NSString *)idfa;
//
//-(NSString *)openUDID;


@end
