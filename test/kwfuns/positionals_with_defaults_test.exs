defmodule Kwfuns.PositionalsWithDefaultsTest do

  use ExUnit.Case
  use Kwfuns

  @moduletag :wip

  # For 0.1
  setup do
    defmodule D do
       defkw fun(pos \\ :pos, kw: :kw), do: {pos, kw}
    end
  end
  
  test "all defaults" do
    assert D.fun() == {:pos, :kw}
  end
end
