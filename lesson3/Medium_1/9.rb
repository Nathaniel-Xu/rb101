def foo(param = "no")
  "yes"
end

def bar(param = "no")
  param == "no" ? "yes" : "no"
end

bar(foo)

#Will return "no" because foo always returns "yes" and bar returns "no" for
#any argument that is not "no"