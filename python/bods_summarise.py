import json

with open('data/Chaarat-Kapan-2021-02-19.json',encoding = 'utf-8') as myfile:
    obj = json.load(myfile)

for x in obj:
	temp =  x['statementType']
	if temp == 'entityStatement':
		print("name = " + x['name'])
	if temp == 'personStatement':
		print(x['names'])
