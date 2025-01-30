defmodule PromptManager.Structs.InputField do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  @types [
    :text,
    :button,
    :checkbox,
    :color,
    :date,
    :email,
    :file,
    :month,
    :number,
    :password,
    :radio,
    :range,
    :tel,
    :time,
    :week
  ]

  schema "input_field" do
    field :title, :string, default: "Campo"

    field :type, Ecto.Enum,
      values: @types,
      default: :text

    field :label, :string, default: "Campo"
    field :value, :string, default: nil
  end

  def get_types(), do: @types |> Enum.map(&Atom.to_string(&1)) |> Enum.map(&String.capitalize(&1))

  def type_to_enum(type_str) when is_binary(type_str),
    do: type_str |> String.downcase() |> String.to_existing_atom()

  def changeset(input, params) do
    params =
      params
      |> PromptManager.Transformer.transform()
      |> Map.update!(:type, &type_to_enum/1)

    changeset =
      input
      |> cast(params, [:title, :type, :label, :value])
      |> validate_required([:title, :type, :label])

    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end

  def cast_type_to_atom(changeset) do
    if get_field(changeset, :type) do
      put_change(changeset, :type, get_field(changeset, :type))
    else
      changeset
    end
  end
end
