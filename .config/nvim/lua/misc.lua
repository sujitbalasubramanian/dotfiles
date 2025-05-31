local add, later = MiniDeps.add, MiniDeps.later

later(function()
  add { source = "vuciv/golf" }
end)
