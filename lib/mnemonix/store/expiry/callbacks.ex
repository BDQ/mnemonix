defmodule Mnemonix.Store.Expiry.Callbacks do
  @moduledoc false

  @doc false
  defmacro __using__(_) do
    quote location: :keep do

      ####
      # OPTIONAL
      ##

      @doc false
      def handle_call({:expires, key, ttl}, _, store = %__MODULE__{impl: impl}) do
        case impl.expires(store, key, ttl) do
          {:ok, store}         -> {:reply, :ok, store}
          {:raise, type, args} -> {:reply, {:raise, type, args}, store}
        end
      end

      @doc false
      def handle_call({:persist, key}, _, store = %__MODULE__{impl: impl}) do
        case impl.persist(store, key) do
          {:ok, store}         -> {:reply, :ok, store}
          {:raise, type, args} -> {:reply, {:raise, type, args}, store}
        end
      end

    end
  end

end
