# Check if there exactly one value defined in the given list.
def exactly_one(values):
  found = False;
  for v in values:
    if v:
      if found:
        return False
      end
      found = True
    end
  end
  return found
end
