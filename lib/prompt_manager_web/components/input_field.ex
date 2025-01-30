defmodule PromptManagerWeb.Components.InputField do
  @moduledoc false
  use Phoenix.Component
  import PromptManagerWeb.CoreComponents
  alias PromptManager.Prompts.Prompt

  defp get_prompt_types() do
    Prompt.get_types()
    |> Enum.map(fn type ->
      str_type =
        type
        |> Atom.to_string()
        |> String.capitalize()

      {str_type, type}
    end)
  end

  def input_field(assigns) do
    ~H"""
    <div class="w-full">
      <div class="flex">
        <div class="w-full basis-5/6">
          <.input
            field={@input_nested[:type]}
            type="select"
            label="Type"
            options={get_prompt_types()}
          />
        </div>

        <div class="w-full basis-1/6">
          <button
            type="button"
            phx-click="delete_input"
            phx-value-index={@input_nested.index}
            phx-target={@myself}
            class="w-full h-full"
          >
            <.icon name="hero-x-mark" class="w-6 h-6 cursor-pointer" />
          </button>
        </div>
      </div>
    </div>

    <.better_input type={@type} index={@index} input_nested={@input_nested} name={@name} />
    """
  end

  def better_input(%{type: :text} = assigns) do
    ~H"""
    <div>
      text
    </div>
    """
  end

  def better_input(%{type: :radio} = assigns) do
    ~H"""
    <div>
      radio
    </div>
    """
  end

  def better_input(%{type: :range} = assigns) do
    ~H"""
    <div>
      range
    </div>
    """
  end

  def better_input(%{type: :checkbox} = assigns) do
    ~H"""
    <div>
      checkbox
    </div>
    """
  end

  def better_input(assigns) do
    ~H"""
    <div>
      unknown
    </div>
    """
  end
end
