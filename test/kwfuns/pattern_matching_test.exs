defmodule Kwfuns.PatternMatchingTest do

  use ExUnit.Case
  use Kwfuns


  @moduletag :wip
  setup do
    defmodule F do
      defkw fun(true, x), do: x 
      defkw fun(_, x), do: :error

      # Mixing keywords with different arity and using defkw when
      # there are no keyword parameters with default in the head
      defkw bad_map([], result, fun: kw_required), do: Enum.reverse(result)
      defkw bad_map([], _), do: [] 
      defkw bad_map(list, fun: fn x -> x end), do: bad_map(list, [], fun: fun)
      defkw bad_map([h|t], sofar, fun: ","), do bad_map(t, [fun.(h) | sofar], fun: fun)

      # A better approach is to make sure is to have only the same arity for each
      # function
      defkw better_map(list, fun: fn x -> x end), do: bmap(list, [], fun: fun) 
      defkwp bmap([], result, _), do: Enum.reverse result
      defkwp bmap([h|t], sofar, fun: kw_required), do: bmap(t, [fun.(h) | sofar], fun: fun)

      # But really, to use defkwp for the private function makes no sense
      # whatsoever
      defkw map(list, fun: fn x -> x end), do: bmap(list, [], fun)
      defp bmap([], result, _), do: Enum.reverse result
      defp bmap([h|t], sofar, fun), do: bmap(t, [fun.(h) | sofar], fun: fun)

      # But the example above is contrieved anyway, you should not use defkw
      # for just one default and no other keyword parameters
      def best_map(list, fun \\ fn x -> x end), do: bmap(list, [], fun)
      defp bmap([], result, _), do: Enum.reverse result
      defp bmap([h|t], sofar, fun), do: bmap(t, [fun.(h) | sofar], fun: fun)
    end
  end

  test "even bad join will work, but the generated code is brittle" do
    assert "1,2," == F.bad_join([1,2])
  end
  test "true case" do
    assert F.fun(true, 42) == 42
  end

  test "default case" do
    assert F.fun(42, 42) == :error
  end
end
