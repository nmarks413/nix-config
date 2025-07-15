const option = collectionDetails
                .fields
                .find(
                  (field): field is { type: "Option", slug: string, validations: WebflowValidations["Option"] } => 
                    field.slug === fieldData.path
                 )!
                .validations;

  if (fieldData.type
"Option" && typeof rawValue
"string")
return (
(
collectionDetails.fields. find (predicate: (field) ⇒ field.slug
| WebflowValidations["Option"]
| undefined
fieldData.path) ?. validations as
)?. options.find(predicate: (option) ⇒ option.id
rawValue) ?. name ?? fullMatch
);
