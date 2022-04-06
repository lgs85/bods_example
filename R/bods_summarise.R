# args <- "data/dm_v1.json"
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

message("\n1. Summary of beneficial ownership or control statements\n")


if(is.null(beneficialOwnershipOrControl))
{
message("There are no ownership or control statement")
	} else
	{
		tibble::as_tibble(table(ownerType,beneficialOwnershipOrControl))

	}


# Identifiers

message("\n2. Summary of identifiers in person statements\n")

if(all(sapply(ps$identifiers,is.null)))
{
	message("There are no identifiers in the person statements\n")
}else
{
	tibble::as_tibble(dplyr::bind_rows(ps$identifiers))
}


message("\n3. Summary of identifiers in entity statements\n")

if(all(sapply(es$identifiers,is.null)))
{
	message("There are no identifiers in the entity statements\n")
} else
{
	tibble::as_tibble(dplyr::bind_rows(es$identifiers))
}
