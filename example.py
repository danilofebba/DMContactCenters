# coding: utf-8
import random

NumberPhonesPerLead = 1
NumberCustomersPortfolio = 2
PhoneType = 3 # {"phone":1,"cell phone":2, "both":3}3

def fnSocialSecurityNumber():
    # the first nine digits of the social security number
    Digits = []
    for a in range(9):
        Digits.append(random.randint(0,9))
    # tenth digit validator
    TenthDigit = ((Digits[0] * 10) + (Digits[1] * 9) + (Digits[2] * 8) + (Digits[3] * 7) + (Digits[4] * 6) + (Digits[5] * 5) + (Digits[6] * 4) + (Digits[7] * 3) + (Digits[8] * 2)) % 11
    if (TenthDigit == 0 or TenthDigit == 1):
        Digits.append(0)
    else:
        Digits.append(11 - TenthDigit)
    # eleventh digit validator
    EleventhDigit = ((Digits[0] * 11) + (Digits[1] * 10) + (Digits[2] * 9) + (Digits[3] * 8) + (Digits[4] * 7) + (Digits[5] * 6) + (Digits[6] * 5) + (Digits[7] * 4) + (Digits[8] * 3) + (TenthDigit * 2)) % 11
    if (EleventhDigit == 0 or EleventhDigit == 1):
        Digits.append(0)
    else:
        Digits.append(11 - EleventhDigit)
    return ''.join(str(a) for a in Digits)

def fnPhoneNumbers():
    global PhoneType
    lvPhoneType = PhoneType
    # select direct distance dialing
    DDDList = [11,12,13,14,15,16,17,18,19,21,22,24,27,28,31,32,33,34,35,37,38,41,42,43,44,45,46,47,48,49,51,53,54,55,61,62,63,64,65,66,67,68,69,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,92,93,94,95,96,97,98,99]
    DDD = str(DDDList[random.randrange(0, len(DDDList))])
    # choose the type of phone
    # both
    if lvPhoneType == 3:
        lvPhoneType = random.randrange(1,3)
    # phone
    pnn = []
    if lvPhoneType == 1:
        pn1 = str(random.randrange(2,6))
        for a in range(0,7):
            pnn.append(str(random.randrange(0,10)))
        return DDD + pn1 + ''.join(pnn)
    # cell phone
    elif lvPhoneType == 2:
        pn1 = str(random.randrange(6,10))
        for a in range(0,8):
            pnn.append(str(random.randrange(0,10)))
        return DDD + pn1 + ''.join(pnn)
    else:
        return 'NULL'

for a in range(NumberCustomersPortfolio):

    PhoneFieldNames = []
    for b in range(NumberPhonesPerLead):
        PhoneFieldNames.append("Phone" + str(b + 1))

    PhoneNumbers = []
    for b in range(NumberPhonesPerLead):
        PhoneNumbers.append(fnPhoneNumbers())

    print("INSERT INTO tblMailing (SocialSecurityNumber, FullName, " + ', '.join(PhoneFieldNames) + ") VALUES (" + fnSocialSecurityNumber() + ", NULL, " + ', '.join(PhoneNumbers) + ")")

def fnFullName():
    return "João da Silva Santos"