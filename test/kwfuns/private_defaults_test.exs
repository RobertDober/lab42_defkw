defmodule Kwfuns.PrivateDefaultsTest do
  use ExUnit.Case

  defmodule A do
    use Kwfuns

    defkwp private(a: 1), do: 2 * a
    def public(a), do: private(a: a)

  end

  test "private" do
    assert_raise UndefinedFunctionError, fn ->
      assert A.private
    end
  end

  test "private in scope" do
    assert A.public(21) == 42
  end
  
end
