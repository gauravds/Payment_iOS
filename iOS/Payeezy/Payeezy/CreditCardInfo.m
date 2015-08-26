//
//  CreditCardInfo.m
//
//  Created by gauravds on 7/11/15.
//  Copyright (c) 2015 Punchh. All rights reserved.
//

#import "CreditCardInfo.h"

@implementation CreditCardInfo

- (CardVarificationCode)cardValidation {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger month = [components month];
    NSInteger year = [components year];
    if (!self.cardNo) {
        return kCardNoNotFound;
    } else if (![[self class] isValidCreditCardNumber:self.cardNo]) {
        return kCardNoWrongInput;
    } else if (self.cardExpYear < year ||  self.cardExpYear > (year+20)) {
        return kCardExpYearWrongInput;
    } else if ((self.cardExpMonth < 1 && self.cardExpMonth > 12) ||
               (self.cardExpYear == year && self.cardExpMonth < month)) {
        return kCardExpMonthWrongInput;
    } else if (self.cardCVV != 0 && (self.cardCVV < 100 || self.cardCVV > 999) ) {
        return kCardCCVWrongInput;
    } else {
        return kCardValid;
    }
}

- (BOOL)isCardValid {
    return [self cardValidation] == kCardValid;
}

+ (NSString *)formattedStringForProcessing:(NSString*)string {
    //-- removing all chars except numbers 0-9
    NSCharacterSet *illegalCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [string componentsSeparatedByCharactersInSet:illegalCharacters];
    return [components componentsJoinedByString:@""];
}

+ (BOOL)isValidCreditCardNumber:(NSString *)string {
    //-- implmenting Luhn Algorithm
    NSString *formattedString;
    if (REMOVE_SPECIAL_CHAR_FROM_CREDITCARD_NUMBER) {
        formattedString = [self formattedStringForProcessing:string];
    } else {
        BOOL isDecimal = [NSNumberFormatter.new numberFromString:[string stringByReplacingOccurrencesOfString:@" " withString:@""]] != nil;
        if (isDecimal) {
            formattedString = [self formattedStringForProcessing:string];
        } else {
            return NO;
        }
    }

    if (formattedString == nil || formattedString.length < 9) {
        return NO;
    }
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[formattedString length]];
    [formattedString enumerateSubstringsInRange:NSMakeRange(0, [formattedString length]) options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];

    NSUInteger oddSum = 0, evenSum = 0;
    for (NSUInteger i = 0; i < [reversedString length]; i++) {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        if (i % 2 == 0) {
            evenSum += digit;
        } else {
            oddSum += digit / 5 + (2 * digit) % 10;
        }
    }
    return (oddSum + evenSum) % 10 == 0;
}

@end
