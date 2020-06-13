create function count_if_true(input boolean)
  returns null on null input
  returns int
  language java as 'if (input) return 1; else return 0;';