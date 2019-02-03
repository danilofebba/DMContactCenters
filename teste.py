# coding: utf-8

#result = []
#while len(result) != 4:
#    r = randint(0, 100)
#    if r not in result:
#        result.append(r)

import pyodbc

server = '192.168.43.100'
database = 'master'
username = 'sa'
password = '123456'
connection = pyodbc.connect('DRIVER={SQL Server Native Client 11.0};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password)
cursor = connection.cursor()
cursor.execute("SELECT @@version")
##rows = cursor.fetchall()
for row in cursor:  
    print (row)