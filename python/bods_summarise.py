import json
import pandas as pd
import sys

temp = (sys.argv[1])

with open(temp) as myfile:
    obj = json.load(myfile)


ownerType = []
beneficialOwnershipOrControl = []
entityID = []
personID = []

for x in obj:
	if x['statementType'] == 'ownershipOrControlStatement':
		beneficialOwnershipOrControl.append(x['interests'][0][u'beneficialOwnershipOrControl'])
		if list(x['interestedParty'])[0] == 'describedByEntityStatement':
			ownerType.append('entity')
		else:
			ownerType.append('person')
	if x['statementType'] == 'entityStatement':
		if 'identifiers' in x:
			entityID.append(x['identifiers'][0])
	if x['statementType'] == 'personStatement':
		if 'identifiers' in x:
			personID.append(x['identifiers'][0])

zipped = list(zip(ownerType,beneficialOwnershipOrControl))
df = pd.DataFrame(zipped, columns = ['ownerType','beneficialOwnershipOrControl'])
ct = pd.crosstab(index = df['ownerType'], columns = df['beneficialOwnershipOrControl'])


# Beneficial ownership statements according to owner type

print("\n1. Summary of beneficialOwnershipOrControl by type of interested party\n")
print(ct)


# Identifiers

print("\n2. Summary of identifiers in person statements\n")
if len(personID) >0:
	print(pd.DataFrame(personID))
else:
	print("There are no identifiers in the person statements\n")


print("\n3. Summary of identifiers in entity statements\n")
if len(entityID) >0:
	print(pd.DataFrame(entityID))
else:
	print("There are no identifiers in the entity statements\n")