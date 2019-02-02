# coding: utf-8
import random

NumberPhonesPerLead = 2
NumberCustomersPortfolio = 5
PhoneType = 3 # {"phone":1,"cell phone":2, "both":3}

def fnSocialSecurityNumber():
    return "99.999.999-99"

def fnFullName():
    return "João da Silva Santos"

def fnEmail():
    return "joao.silva.santos@gmail.com"

def fnPhoneNumbers():
    global PhoneType
    lvPhoneType = PhoneType
    DDDList = [11,12,13,14,15,16,17,18,19,21,22,24,27,28,31,32,33,34,35,37,38,41,42,43,44,45,46,47,48,49,51,53,54,55,61,62,63,64,65,66,67,68,69,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,92,93,94,95,96,97,98,99]
    DDD = str(DDDList[random.randrange(0, len(DDDList))])
    pnn = []
    if lvPhoneType == 3:
        lvPhoneType = random.randrange(1,3)
    if lvPhoneType == 1:
        pn1 = str(random.randrange(2,6))
        for a in range(0,7):
            pnn.append(str(random.randrange(0,10)))
        return DDD + pn1 + ''.join(pnn)
    elif lvPhoneType == 2:
        pn1 = str(random.randrange(6,10))
        for a in range(0,8):
            pnn.append(str(random.randrange(0,10)))
        return DDD + pn1 + ''.join(pnn)
    else:
        return 'NULL'

for a in range(NumberCustomersPortfolio):

    SocialSecurityNumber = "SocialSecurityNumber"
    FullName = "FullName"
    Email = "Email"

    PhoneFieldNames = []
    for b in range(NumberPhonesPerLead):
        PhoneFieldNames.append("Phone" + str(b + 1))

    PhoneNumbers = []
    for b in range(NumberPhonesPerLead):
        PhoneNumbers.append(fnPhoneNumbers())

    print("INSERT INTO tblMailing (SocialSecurityNumber, FullName, Email, " + ', '.join(PhoneFieldNames) + ") VALUES (" + fnSocialSecurityNumber() + ", '" + fnFullName() + "', " + fnEmail() + ", " + ', '.join(PhoneNumbers) + ")")