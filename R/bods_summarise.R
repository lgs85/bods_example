args = commandArgs(trailingOnly=TRUE)

# Read in file
ck <- jsonlite::fromJSON(args)


# Separate statement types
ps <- dplyr::filter(ck,statementType == "personStatement")
es <- dplyr::filter(ck,statementType == "entityStatement")
ocs <- dplyr::filter(ck,statementType == "ownershipOrControlStatement")


# Beneficial ownership statements according to owner type
ownerType <- ifelse(is.na(ocs$interestedParty$describedByPersonStatement),
	"entity",
	"person")

beneficialOwnershipOrControl <- dplyr::bind_rows(ocs$interests)$beneficialOwnershipOrControl

message("\n1. Summary of beneficialOwnershipOrControl by type of interested party\n")
table(ownerType,beneficialOwnershipOrControl)


# Identifiers

message("\n2. Summary of identifiers in person statements\n")

if(all(sapply(ps$identifiers,is.null)))
{
	message("There are no identifiers in the person statements\n")
}else
{
	dplyr::bind_rows(ps$identifiers)
}


message("\n3. Summary of identifiers in entity statements\n")

if(all(sapply(es$identifiers,is.null)))
{
	message("There are no identifiers in the person statements\n")
} else
{
	dplyr::bind_rows(es$identifiers)
}