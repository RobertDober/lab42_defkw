defmodule Kwfuns do

  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
    end
  end


  defmacro defkw( {name, _, params}, do: body ) do
    {positionals, [keywords]} =  params |> Enum.split_while(&is_tuple/1)
    keyword_matches = ast_for_vars!(Keyword.keys keywords)
    positional_params = make_positional_parlist(positionals)
    {:def, [context: Kwfuns, import: Kernel],
      [{name, [context: Kwfuns], positional_params ++
          [{:\\, [], [{:keywords, [], Kwfuns}, []]}]},
        block_from_asts([ {:=, [],
                [{:%{}, [], 
                    keyword_matches},
                  {:|>, [context: Kwfuns, import: Kernel],
                    [{{:., [], [{:__aliases__, [alias: false], [:Keyword]}, :merge]}, [],
                        [keywords, {:keywords, [], Kwfuns}]},
                      {{:., [], [{:__aliases__, [alias: false], [:Enum]}, :into]}, [],
                        [{:%{}, [], []}]}]}]}, body]) ]}

  end

  defp make_positional_parlist positionals do
    for {positional, _, _} <- positionals, do: bare_ast_for_var!(positional)
  end

  defp block_from_asts asts do
    [do: {:__block__, [], asts}]
  end

  defp bare_ast_for_var! var_name do
    {:var!, [context: Kwfuns, import: Kernel], [{var_name, [], Kwfuns}]}
  end

  defp ast_for_var! var_name do
    {var_name, bare_ast_for_var!( var_name ) }
  end
  defp ast_for_vars! var_names do
    for( var_name <- var_names, do: ast_for_var! var_name )
    |> Keyword.new
  end

end
