defmodule Kwfuns.KwRequiredTest do
  use ExUnit.Case

    use Kwfuns
    defkw required(a: kw_required, b: 1), do: a + b

  test "required and provided" do
    assert required(a: 1) == 2

  end

  test "required and not provided" do
    assert_raise ArgumentError, "The following required keywords have not been provided: a", fn ->
      required(b: 1)
    end
  end

  test "although kw_required is nil it cannot be replaced with nil" do
    defmodule B do
      use Kwfuns
      def check_kw_required do
        assert kw_required == nil
      end
      defkw but_nil_is_a_default(default: nil), do: default
    end
    B.check_kw_required
    assert B.but_nil_is_a_default == nil
  end
end

