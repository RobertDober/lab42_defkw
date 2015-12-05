defmodule Kwfuns do

  defmacro __using__(options) do
    quote do
      import unquote(__MODULE__)
    end
  end


  @doc """
  Define a function with defaulted keyword parameters that are syntactically
  available in the same way as positional parameters.

  Ex:
  defkw multiply_sum( factor, lhs: 0, rhs: 1 ) do
    factor * ( lhs + rhs )
  end

  would correspond to the following code

  def multiply_sum( factor, keywords // [] ) do
    %{lhs: lhs, rhs: rhs} =
      Keyword.merge( [lhs: 0, rhs: 0], keywords ) 
      |> Enum.into( %{} )
    factor * ( lhs + rhs )
  end
  """
  defmacro defkw( {name, _, params}, do: body ) do

    {positionals, keywords} =  params |> Enum.split_while(&is_tuple/1)
    positional_params = make_positional_parlist(positionals)
    # e.g. [factor]

    keywords_with_defaults  =  extract_keywords_with_defaults( keywords )
    keyword_matches = ast_for_pattern_match(Keyword.keys keywords_with_defaults)

    quote do
      def unquote(name)(unquote_splicing(positional_params), keywords \\ []) do
      #e.g. def multiply_sum( factor, keywords \\ [] ) do

        %{unquote_splicing(keyword_matches)} = 
          Keyword.merge( unquote(keywords_with_defaults), keywords ) |> Enum.into(%{})
        # e.g.         %{lhs: lhs, rhs: rhs} = Keyword.merge( [lhs: 0, rhs: 1], keywords ) |> Enum.into(%{})

        unquote(body)
      end
    end

  end

  defp extract_keywords_with_defaults keywords do
    case keywords do
      []     -> raise ArgumentError, "do not use defkw but simply def if you do not have any default values"
      [kwds] -> kwds
    end
  end
  defp make_positional_parlist positionals do
    for {positional, _, _} <- positionals, do: Macro.var( positional, nil)
  end


  @doc """
  Transforms a list of atoms designating the keyword parameters to
  the ast of a pattern match map to assign them as variables inside
  the eventual function.
  [:var1, ..., :varn] --> %{var1: var1, ..., varn: varn}
  """
  defp ast_for_pattern_match var_names do
    for var_name <- var_names do 
      quote do
        {unquote(var_name), unquote(Macro.var(var_name, nil))}
      end
    end
  end

end
