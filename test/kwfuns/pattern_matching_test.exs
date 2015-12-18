defmodule Kwfuns.PatternMatchingTest do

  use ExUnit.Case
  use Kwfuns

  # # For 0.1
  # defkw fun(true, x), do: x 
  # defkw fun(_, x), do: :error
  
  # test "true case" do
  #   assert fun(true, 42) == 42
  # end

  # test "default case" do
  #   assert fun(42, 42) == :error
  # end
end
