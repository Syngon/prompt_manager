defmodule PromptManager.Transformer do
  def transform(map) do
    map
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      # Converte a chave para o formato atomizado
      new_key = String.to_atom(key)

      # Converte valores que são strings numéricas para inteiros
      new_value =
        case Integer.parse(value) do
          {int_value, ""} -> int_value
          _ -> value
        end

      # Adiciona a nova chave e valor ao acumulador
      Map.put(acc, new_key, new_value)
    end)
  end
end
