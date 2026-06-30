variable "rgVariables" {
  type = map(object({
    rgName = string,
    rgLocation = string,
    rgTags = map(string)
  }))
}

