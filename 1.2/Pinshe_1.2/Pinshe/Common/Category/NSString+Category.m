//
//  NSString+Category.m
//  Pinshe
//
//  Created by 史瑶荣 on 16/4/13.
//  Copyright © 2016年 shiyaorong. All rights reserved.
//

#import "NSString+Category.h"
#import "PinUser.h"

@implementation NSString (Category)

NSString *getTrimString(NSString *str) {
    if (str) {
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    return @"";
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
    UILabel *describeLabel = Building_UILabel(font, HEXCOLOR(pinColorGray), NSTextAlignmentLeft, 0);
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

NSString *getPushName(NSInteger pinLoginType) {
    switch (pinLoginType) {
        case PinLoginType_PulishComapre: // 登录挑战比较发布页
            return FORWARD_PUBLISHCOMPARE_VC;
            break;
        case PinLoginType_DetailCompare: // 登录跳转留言页面
            return FORWARD_TEXTVIEW_VC;
            break;
        default:
            break;
    }
    return @"";
}

NSString *getPlaceholder(NSInteger pinLoginType) {
    switch (pinLoginType) {
        case PinLoginType_DetailCompare: // 登录跳转留言页面
            return @"请填写您的留言";
            break;
        case PinLoginType_MyInstalled:
            return @"请输入您的地址"; // 系统设置
        default:
            break;
    }
    return @"";
}

NSString *getTopSenceTitle(NSInteger pinSenceType) {
    switch (pinSenceType) {
        case PinTopSceneType_WhiteCollar:
            return @"白领居家";
            break;
        case PinTopSceneType_Office:
            return @"办公室小确幸";
            break;
        case PinTopSceneType_Jouney:
            return @"人在旅途";
            break;
        case PinTopSceneType_Exercise:
            return @"生命在于运动";
            break;
        default:
            break;
    }
    return @"";
}

NSString *getRequestUrl(void) {
    NSString *requestUrl = REQUEST_URL;
#ifdef DEBUG
    if ([[UserDefaultManagement instance].debugRequestUrl length] > 0) {
        requestUrl = [UserDefaultManagement instance].debugRequestUrl;
    }
#endif
    return requestUrl;
}

@end
