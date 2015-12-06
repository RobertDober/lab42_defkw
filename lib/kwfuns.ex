defmodule Kwfuns do

  def kw_required, do: fn -> end

  defmacro __using__(_options) do
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

    {positional_params, keywords_with_defaults, keyword_matches} =
      prepare_dynamic_ast( params )

      ast =
    quote do
      def unquote(name)(unquote_splicing(positional_params), keywords \\ []) do
        #e.g. def multiply_sum( factor, keywords \\ [] ) do
        unquote( body_with_keyword_match(keywords_with_defaults, keyword_matches, body ))
      end
    end
    # IO.puts Macro.to_string ast
    ast

  end

  defmacro defkwp( {name, _, params}, do: body ) do

    {positional_params, keywords_with_defaults, keyword_matches} =
      prepare_dynamic_ast( params )

    quote do
      defp unquote(name)(unquote_splicing(positional_params), keywords \\ []) do
        unquote( body_with_keyword_match(keywords_with_defaults, keyword_matches, body ))
      end
    end

  end

  defp body_with_keyword_match(keywords_with_defaults, keyword_matches, original_body) do
    quote do
      unquote(check_for_required_keywords(keywords_with_defaults))

      %{unquote_splicing(keyword_matches)} = 
        Keyword.merge( unquote(keywords_with_defaults), keywords ) |> Enum.into(%{})
      unquote(original_body)
    end
  end

  defp check_for_required_keywords(keywords_with_defaults) do
    required_keywords =
      for {key, defval} <- keywords_with_defaults, keyword_required?(defval), do: key
    check_for_required_keywords_ast( required_keywords )
  end

  def check_for_required_keywords_ast(required_keywords) do
    quote do
      missing_keywords = unquote(required_keywords) -- Keyword.keys( keywords )
      unless Enum.empty?(missing_keywords) do
        raise ArgumentError, message: "The following required keywords have not been provided: #{Enum.join( missing_keywords, ", " )}" 
      end
    end
  end

  defp prepare_dynamic_ast( params ) do
    {positionals, keywords} =  params |> Enum.split_while(&is_tuple/1)

    keywords_with_defaults  =  extract_keywords_with_defaults( keywords )
    keyword_matches = ast_for_pattern_match(Keyword.keys keywords_with_defaults)
    { 
      make_positional_parlist(positionals),
      keywords_with_defaults,
      keyword_matches
    }
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

  defp keyword_required?( {:kw_required,_,_}), do: true
  defp keyword_required?( _ ),                 do: false

  # Transforms a list of atoms designating the keyword parameters to
  # the ast of a pattern match map to assign them as variables inside
  # the eventual function.
  # [:var1, ..., :varn] --> %{var1: var1, ..., varn: varn}
  defp ast_for_pattern_match var_names do
    for var_name <- var_names do 
    quote do
      {unquote(var_name), unquote(Macro.var(var_name, nil))}
    end
    end
  end

end
