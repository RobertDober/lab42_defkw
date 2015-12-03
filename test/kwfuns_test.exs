defmodule KwfunsTest do
  use ExUnit.Case
  doctest Kwfuns

  defmodule A do
    use Kwfuns
    # defkw add( lhs: 1, rhs: 41) do
    #   lhs + rhs 
    # end
    
    defkw plyer(factor, a: 1, b: 42) do
      factor * (a + b)
    end

    defkw adder(a: 1, b: 42) do
      a + b
    end


  end

  test "adder" do
    assert A.adder(a: 40, b: 2) == 42 
  end
  test "adder 1 default" do
    assert A.adder(b: 41) == 42
  end
  test "adder all defaults" do
    assert A.adder() == 43
  end

  test "plyer" do
    assert A.plyer(2) == 86
  end
end

