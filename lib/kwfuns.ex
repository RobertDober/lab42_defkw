defmodule Kwfuns do

  @moduledoc """
  Kwfuns allows to specify keyword list arguments with default values.

  It exposes the macros `defkw`  and `defkwp` to define a function with keyword list arguments available in the body of the function
  exactly the same as positional parameters.

  While the former defines a public function the later defines a private one.
  
      defkw say_hello(to, greeting: "Hello") do
        IO.puts( "\#{greeting}, \#{to}" )
      end

  If values are required that can be specified with the likewise exposed `kw_required` function

      defkw say_hello(to: kw_required, greeting: "Hello") do
        IO.puts( "\#{greeting}, \#{to}" )
      end

  ### Caveat:

  For the time being `defkw` and `defkwp` do not support positional arguments with defaults.
  If you try you will get a rather cryptic error message. Implemenation of this feature is
  scheduled for version 0.1
  """


  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @doc """
  A placeholder to designate required keywords. It is made available to the module using `Kwfuns`

      iex> use Kwfuns
      iex> kw_required
      nil
  """
  def kw_required, do: nil

  @doc """
  Define a function with defaulted keyword parameters that are syntactically
  available in the same way as positional parameters.

  Here is a simple example: 

      iex> defmodule A do            
      ...>   use Kwfuns              
      ...>   defkw hello(a: 1), do: a
      ...> end    
      iex> A.hello
      1
      iex> A.hello(a: 2)
      2
  
  As such the following macro invocation

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

  However if required keywords are specified as follows:

      defkw multiply_sum( factor: kw_required, lhs: 0, rhs: 0 ) do
        factor * ( lhs + rhs )
      end

  The corresponding code is a little bit more complex

      def multiply_sum( keywords // [] ) do
        missing_keywords = [:factor] -- Keyword.keys( keywords )
        unless Enum.empty?(missing_keywords) do
          raise ArgumentError, message: "The following required keywords have not been provided: factor" 
        end
        %{factor: factor, lhs: lhs, rhs: rhs} =
          Keyword.merge( [lhs: 0, rhs: 0], keywords ) 
          |> Enum.into( %{} )
        factor * ( lhs + rhs )
      end
  """

  defmacro defkw( {name, _, params}, do: body ) do

    {positional_params, keywords_with_defaults, keyword_matches} =
      prepare_dynamic_ast( params, "" )

    quote do
      def unquote(name)(unquote_splicing(positional_params), keywords \\ []) do
        #e.g. def multiply_sum( factor, keywords \\ [] ) do
        unquote( body_with_keyword_match(keywords_with_defaults, keyword_matches, body ))
      end
    end

  end

  @doc """
  Same semantics as `defkw` but a _private_ function is defined.
  """
  defmacro defkwp( {name, _, params}, do: body ) do

    {positional_params, keywords_with_defaults, keyword_matches} =
      prepare_dynamic_ast( params, "p" )

    quote do
      defp unquote(name)(unquote_splicing(positional_params), keywords \\ []) do
        unquote( body_with_keyword_match(keywords_with_defaults, keyword_matches, body ))
      end
    end

  end

  defp body_with_keyword_match(keywords_with_defaults, keyword_matches, original_body) do
    required_keywords =
      for {key, defval} <- keywords_with_defaults, keyword_required?(defval), do: key
    quote do
      unquote(unless Enum.empty?( required_keywords) do
        check_for_required_keywords_ast(required_keywords)
      end)

      %{unquote_splicing(keyword_matches)} = 
        Keyword.merge( unquote(keywords_with_defaults), keywords ) |> Enum.into(%{})
      unquote(original_body)
    end
  end


  defp check_for_required_keywords_ast(required_keywords) do
    quote do
      missing_keywords = unquote(required_keywords) -- Keyword.keys( keywords )
      unless Enum.empty?(missing_keywords) do
        raise ArgumentError, message: "The following required keywords have not been provided: #{Enum.join( missing_keywords, ", " )}" 
      end
    end
  end

  defp prepare_dynamic_ast( params, pub_or_priv_str ) do
    {positionals, keywords} =  params |> Enum.split_while(&is_tuple/1)

    keywords_with_defaults  =  extract_keywords_with_defaults( keywords, pub_or_priv_str )
    keyword_matches = ast_for_pattern_match(Keyword.keys keywords_with_defaults)
    { 
      make_positional_parlist(positionals),
      keywords_with_defaults,
      keyword_matches
    }
  end
  defp extract_keywords_with_defaults keywords, pub_or_priv_str do
    case keywords do
      []     -> raise ArgumentError, "do not use defkw#{pub_or_priv_str} but simply def#{pub_or_priv_str} if you do not define any keyword parameters"
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
