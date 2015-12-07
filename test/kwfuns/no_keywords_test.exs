defmodule Kwfuns.NoKeywordsTest do 
  use ExUnit.Case
  
  test "defkw without kw params" do
    assert_raise ArgumentError, "do not use defkw but simply def if you do not define any keyword parameters", fn ->
      defmodule X do
        use Kwfuns
        defkw nop(), do: nil
      end
    end
  end
  test "defkwp without kw params" do
    assert_raise ArgumentError, "do not use defkwp but simply defp if you do not define any keyword parameters", fn ->
      defmodule X do
        use Kwfuns
        defkwp nop(), do: nil
      end
    end
  end
end

