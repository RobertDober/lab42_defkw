defmodule Kwfuns.PatternMatchingTest do

  use ExUnit.Case
  use Kwfuns


  @moduletag :wip
  setup do
    defmodule F do
      defkw fun(true, x), do: x 
      defkw fun(_, x), do: :error
    end
  end

  test "true case" do
    assert F.fun(true, 42) == 42
  end

  test "default case" do
    assert F.fun(42, 42) == :error
  end
end
