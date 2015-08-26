//
//  CreditCardInfo.h
//
//  Created by gauravds on 7/11/15.
//  Copyright (c) 2015 Punchh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum cardVarificationNumber {
    kCardNoNotFound,
    kCardNoWrongInput,
    kCardExpMonthWrongInput,
    kCardExpYearWrongInput,
    kCardCCVWrongInput,
    kCardValid
} CardVarificationCode;

#ifndef REMOVE_SPECIAL_CHAR_FROM_CREDITCARD_NUMBER
    #define REMOVE_SPECIAL_CHAR_FROM_CREDITCARD_NUMBER false
#endif


@interface CreditCardInfo : NSObject

@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic) NSUInteger cardExpMonth, cardExpYear, cardCVV;

- (CardVarificationCode)cardValidation;
- (BOOL)isCardValid;

+ (NSString *)formattedStringForProcessing:(NSString*)str;
+ (BOOL)isValidCreditCardNumber:(NSString *)string;

@end
