defmodule Kwfuns do

  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
    end
  end


  defmacro defkw( {name, _, params}, do: body ) do
    {positionals, keywords} =  params |> Enum.split_while(&is_tuple/1)
    keywords = case keywords do
      []     -> raise ArgumentError, "do not use defkw but simply def if you do not have any default values"
      [kwds] -> kwds
    end
    keyword_matches = ast_for_vars!(Keyword.keys keywords)
    positional_params = make_positional_parlist(positionals)
    {:def, [context: __MODULE__, import: Kernel],
      [{name, [context: __MODULE__], positional_params ++
          [{:\\, [], [{:keywords, [], __MODULE__}, []]}]},
        block_from_asts([ {:=, [],
                [{:%{}, [], 
                    keyword_matches},
                  {:|>, [context: __MODULE__, import: Kernel],
                    [{{:., [], [{:__aliases__, [alias: false], [:Keyword]}, :merge]}, [],
                        [keywords, {:keywords, [], __MODULE__}]},
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
    {:var!, [context: __MODULE__, import: Kernel], [{var_name, [], __MODULE__}]}
  end

  defp ast_for_var! var_name do
    {var_name, bare_ast_for_var!( var_name ) }
  end
  defp ast_for_vars! var_names do
    for( var_name <- var_names, do: ast_for_var! var_name )
    |> Keyword.new
  end

end
