defmodule Mnemonix.Store.Map.Behaviour do
  @moduledoc false

  @doc false
  defmacro __using__(_) do
    quote location: :keep do
      @behaviour unquote __MODULE__
      use Mnemonix.Store.Map.Functions
    end
  end

  alias Mnemonix.Store

  @typep store :: Store.t
  @typep key   :: Store.key
  @typep value :: Store.value
  # @typep ttl   :: Store.ttl # TODO: expiry

  @typep exception :: Exception.t
  @typep info      :: term

  ####
  # REQUIRED
  ##

  @doc """
  Removes the entry under `key` in `store`.

  If the `key` does not exist, the contents of `store` will be unaffected.
  """
  @callback delete(store, key) ::
    {:ok, store} |
    {:raise, exception, info}

  # TODO: expiry
  # @callback expires(store, key, ttl) ::
  #   {:ok, store} |
  #   {:raise, exception, msg}

  @doc """
  Retrieves the value of the entry under `key` in `store`.

  If the `key` does not exist, returns `:error`, otherwise
  returns `{:ok, value}`.
  """
  @callback fetch(store, key) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @doc """
  Creates a new entry for `value` under `key` in `store`.
  """
  @callback put(store, key, value) ::
    {:ok, store} |
    {:raise, exception, info}


  ####
  # OPTIONAL
  ##

  @optional_callbacks fetch!: 2
  @doc """
  Fetches the value for specific `key`.

  If `key` does not exist, triggers a `KeyError`.
  """
  @callback fetch!(store, key) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks get: 2
  @doc """
  Gets the value for a specific `key`.

  If `key` does not exist, returns `nil`.
  """
  @callback get(store, key) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks get: 3
  @doc """
  Gets the value for a specific `key` with `default`.

  If `key` does not exist, returns `default`.
  """
  @callback get(store, key, value) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks get_and_update: 3
  @doc """
  Gets the value from `key` and updates it, all in one pass.

  This `fun` argument receives the value of `key` (or `nil` if `key`
  is not present) and must return a two-element tuple: the "get" value
  (the retrieved value, which can be operated on before being returned)
  and the new value to be stored under `key`. The `fun` may also
  return `:pop`, implying the current value shall be removed
  from `store` and returned.

  The returned value is a tuple with the "get" value returned by
  `fun` and a reference to the `store` with the updated value under `key`.
  """
  @callback get_and_update(store, key, fun) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks get_and_update!: 3
  @doc """
  Gets the value from `key` and updates it. Raises if there is no `key`.

  This `fun` argument receives the value of `key` and must return a
  two-element tuple: the "get" value (the retrieved value, which can be
  operated on before being returned) and the new value to be stored under
  `key`.

  The returned value is a tuple with the "get" value returned by `fun` and a
  a reference to the `store` with the updated value under `key`.
  """
  @callback get_and_update!(store, key, fun) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks get_lazy: 3
  @doc """
  Gets the value for a specific `key`.

  If `key` does not exist, lazily evaluates `fun` and returns its result.

  This is useful if the default value is very expensive to calculate or
  generally difficult to setup and teardown again.
  """
  @callback get_lazy(store, key, fun) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks has_key?: 2
  @doc """
  Returns whether a given `key` exists in the given `store`.
  """
  @callback has_key?(store, key) ::
    {:ok, store, boolean} |
    {:raise, exception, info}

  @optional_callbacks pop: 2
  @doc """
  Returns and removes the value associated with `key` in `store`.

  If no value is associated with the `key`, `nil` is returned.
  """
  @callback pop(store, key) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks pop: 3
  @doc """
  Returns and removes the value associated with `key` in `store` with `default`.

  If no value is associated with the `key` but `default` is given,
  that will be returned instead without touching the store.
  """
  @callback pop(store, key, value) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks pop_lazy: 3
  @doc """
  Lazily returns and removes the value associated with `key` in `store`.

  This is useful if the default value is very expensive to calculate or
  generally difficult to setup and teardown again.
  """
  @callback pop_lazy(store, key, fun) ::
    {:ok, store, value} |
    {:raise, exception, info}

  @optional_callbacks put_new: 3
  @doc """
  Puts the given `value` under `key` unless the entry `key`
  already exists.
  """
  @callback put_new(store, key, value) ::
    {:ok, store} |
    {:raise, exception, info}

  @optional_callbacks put_new_lazy: 3
  @doc """
  Evaluates `fun` and puts the result under `key`
  in `store` unless `key` is already present.

  This is useful if the value is very expensive to calculate or
  generally difficult to setup and teardown again.
  """
  @callback put_new_lazy(store, key, fun) ::
    {:ok, store} |
    {:raise, exception, info}

  @optional_callbacks update: 4
  @doc """
  Updates the `key` in `store` with the given function.

  If the `key` does not exist, inserts the given `initial` value.
  """
  @callback update(store, key, value, fun) ::
    {:ok, store} |
    {:raise, exception, info}

  @optional_callbacks update!: 3
  @doc """
  Updates the `key` with the given function.

  If the `key` does not exist, triggers a `KeyError`.
  """
  @callback update!(store, key, fun) ::
    {:ok, store} |
    {:raise, exception, info}

end
