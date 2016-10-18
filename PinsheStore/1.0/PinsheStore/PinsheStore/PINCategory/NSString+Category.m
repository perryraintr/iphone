//
//  NSString+Category.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

// 去除空格
NSString *getTrimString(NSString *str) {
    if (str) {
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return @"";
}

// 验证是否为手机号
BOOL validateMobile(NSString *mobile) {
    NSString *mobileRegex = @"^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\\d{8}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [mobileTest evaluateWithObject:mobile];
}

// 日期转字符串
+ (NSString *)stringFromDateyyyy_MM_dd_HH_mm_ss:(NSDate *)aDate
{
    NSString *dateString = [[NSString sharedDateFormatteryyyy_MM_dd_HH_mm_ss] stringFromDate:aDate];
    return [dateString length] > 0?dateString:@"";
}

+ (NSDateFormatter *)sharedDateFormatteryyyy_MM_dd_HH_mm_ss
{
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [_dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    });
    return _dateFormatter;
}

// 将post请求参数Dic拼接成字符串
NSString *paramsFromDictionary(NSDictionary *params) {
    if (params == nil) {
        return @"";
    }
    NSArray *allkey = [params allKeys];
    NSArray *sortAllkey = [allkey sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *paramsString = [NSMutableString string];
    for (int i = 0; i < sortAllkey.count; i++) {
        id obj = params[sortAllkey[i]];
        if ([obj isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray *)obj;
            for (int j = 0; j < array.count; j++) {
                [paramsString appendFormat:@"%@=%@&", sortAllkey[i], array[j]];
            }
        } else if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSNull class]]) {
            continue;
        } else {
            [paramsString appendFormat:@"%@=%@&", sortAllkey[i], [obj description]];
        }
    }
    NSString *resultParams = @"";
    if (paramsString.length > 0) {
        resultParams = [paramsString substringToIndex:paramsString.length - 1];
    }
    return resultParams;
}

//返回字符串所占用的尺寸.
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/// 设置段的间距倍数
NSAttributedString *resetLineHeightMultiple(NSInteger lineHeightMultiple, NSInteger lineSpacing, NSString *str) {
    if (str.length == 0) {
        str = @"";
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    //设置缩进、行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 0;//缩进
    style.firstLineHeadIndent = 0;
    style.lineHeightMultiple = lineHeightMultiple;
    style.lineSpacing = lineSpacing;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    return attributedString;
}

+ (float)getTextHeight:(float)textWidth text:(NSString *)text withLineHiehtMultipe:(NSInteger)lineHiehtMultipe withLineSpacing:(NSInteger)lineSpacing fontSize:(float)fontSize isSuo:(BOOL)isSuo {
    if ([text length] == 0) {
        return 0;
    }
    UIFont *font = isSuo ? Font(fontSize) : FontNotSou(fontSize);
    UILabel *describeLabel = Building_UILabel(font, HEXCOLOR(pinColorTextLightGray), NSTextAlignmentLeft, 0);
    describeLabel.frame = CGRectMake(0, 0, textWidth, 50);
    describeLabel.attributedText = resetLineHeightMultiple(lineHiehtMultipe, lineSpacing, text);

    CGSize size = CGSizeMake(textWidth, 500000);
    CGSize labelSize = [describeLabel sizeThatFits:size];
    return labelSize.height;
}

+ (float)getTextHeight:(float)textWidth text:(NSString *)text fontSize:(float)fontSize isSuo:(BOOL)isSuo {
    if ([text length] == 0) {
        return 0;
    }
    UIFont *font = isSuo ? Font(fontSize) : FontNotSou(fontSize);
    float origin = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                      context:nil].size.height;
    return ceilf(origin);
}

+ (float)getTextWidth:(float)textHeight text:(NSString *)text fontSize:(float)fontSize isSuo:(BOOL)isSuo {
    if ([text length] == 0) {
        return 0;
    }
    UIFont *font = isSuo ? Font(fontSize) : FontNotSou(fontSize);
    float origin = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, textHeight)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil]
                                      context:nil].size.width;
    return ceilf(origin);
}

NSMutableAttributedString *getAttributedString(NSString *markStr, NSUInteger markColor, NSString *defalutStr, NSUInteger defalutColor, float markFont, float defalutFont, BOOL isSou) {
    NSMutableAttributedString *replyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", markStr, defalutStr]];
    // ----- 设置字体颜色 -----
    [replyString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(markColor) range:NSMakeRange(0, markStr.length)];
    [replyString addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(defalutColor) range:NSMakeRange(markStr.length, defalutStr.length)];
    // ----- 设置字体大小 -----
    [replyString addAttribute:NSFontAttributeName value:(isSou ? Font(markFont) : FontNotSou(markFont)) range:NSMakeRange(0, markStr.length)];
    [replyString addAttribute:NSFontAttributeName value:(isSou ? Font(defalutFont) : FontNotSou(defalutFont)) range:NSMakeRange(markStr.length, defalutStr.length)];
    return replyString;
}
@end
