defmodule Kwfuns.PublicDefaultsTest do
  use ExUnit.Case

  defmodule A do
    use Kwfuns

    defkw plyer(factor, a: 1, b: 42) do
      factor * (b - a)
    end
  end

  test "all defaults apply" do
    assert A.plyer(1) == 41
  end

  test "some defaults apply" do
    assert A.plyer(2,a: 2) == 80
    assert A.plyer(2,b: 2) ==  2 
  end

  test "no defaults apply" do
    assert A.plyer(3,a: 6, b: 8) == 6
  end

  test "order does not matter" do
    assert A.plyer(3, b: 8, a: 6) == 6 
  end

  test "keywords cannot be passed in as positionals" do
    assert_raise FunctionClauseError, fn ->
      A.plyer(3, 2)
    end
  end

  test "positional param is still needed" do
    assert_raise UndefinedFunctionError, fn ->
      A.plyer
    end
  end
  
end
