defmodule PromptManager.Prompts.Prompt do
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

  schema "prompts" do
    field :text, :string
    field :description, :string
    field :title, :string

    embeds_many :inputs, InputField, on_replace: :delete do
      field :title, :string, default: "Field Title"
      field :label, :string, default: "Field Label"
      field :options, :map

      field :type, Ecto.Enum,
        values: [
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
        ],
        default: :text
    end

    belongs_to :created_by, PromptManager.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prompt, attrs) do
    prompt
    |> cast(attrs, [:text, :title, :created_by_id, :description])
    |> cast_embed(:inputs, required: true, with: &input_field_changeset/2)
    |> validate_required([:text, :title, :created_by_id])
  end

  # input filed
  def get_types(), do: @types

  def type_to_enum(type_str) when is_binary(type_str),
    do: type_str |> String.downcase() |> String.to_existing_atom()

  def input_field_changeset(input, params) do
    input
    |> cast(params, [:title, :type, :label, :options])
    |> validate_required([:title, :type, :label])
  end
end
