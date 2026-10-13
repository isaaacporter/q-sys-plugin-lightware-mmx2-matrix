table.insert(props, {
    Name = "IP Address",
    Type = "string",
    Value = "127.0.0.1"
})
table.insert(props, {
    Name = "Model",
    Type = "enum",
    Choices = {"MMX2-4x1", "MMX2-4x3"},
    Value = "MMX2-4x1"
})
--[[ -- for future use
table.insert(props, {
    Name = "Independent Audio",
    Type = "boolean",
    Value = false
})]]
