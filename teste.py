
#result = []
#while len(result) != 4:
#    r = randint(0, 100)
#    if r not in result:
#        result.append(r)

import random

PhoneType = 3 # {"phone":1,"cell phone":2, "both":3}

def fnPhoneNumbers():
    global PhoneType
    pt = PhoneType
    DDDList = [11,12,13,14,15,16,17,18,19,21,22,24,27,28,31,32,33,34,35,37,38,41,42,43,44,45,46,47,48,49,51,53,54,55,61,62,63,64,65,66,67,68,69,71,73,74,75,77,79,81,82,83,84,85,86,87,88,89,91,92,93,94,95,96,97,98,99]
    DDD = str(DDDList[random.randrange(0, len(DDDList))])
    pnn = []
    if pt == 3:
        pt = random.randrange(1,3)
    if pt == 1:
        pn1 = str(random.randrange(2,6))
        for a in range(0,7):
            pnn.append(str(random.randrange(0,10)))
        return DDD + pn1 + ''.join(pnn)
    elif pt == 2:
        pn1 = str(random.randrange(6,10))
        for a in range(0,8):
            pnn.append(str(random.randrange(0,10)))
        return DDD + pn1 + ''.join(pnn)
    else:
        return 'NULL'

for i in range(10):
    print(fnPhoneNumbers())