# coding: utf-8

NumberPhonesPerLead = 1
NumberCustomersPortfolio = 1

def fnSocialSecurityNumber():
    return "99.999.999-99"

def fnFullName():
    return "João da Silva Santos"

def fnEmail():
    return "joao.silva.santos@gmail.com"

def fnPhoneNumbers():
    return "(11) 2726-8693"

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