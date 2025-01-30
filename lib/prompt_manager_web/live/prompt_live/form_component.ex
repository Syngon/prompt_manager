defmodule PromptManagerWeb.PromptLive.FormComponent do
  use PromptManagerWeb, :live_component

  alias PromptManager.Prompts
  import PromptManagerWeb.Components.InputField

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Create you prompt and inputs so you can use anytime!</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="prompt-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:created_by_id]} type="hidden" value={@current_account.id} />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:text]} type="textarea" label="Prompt text" />

        <div class="flex justify-between">
          <h2 class="font-bold">Inputs {Enum.count(@form[:inputs].value)}</h2>
          <button
            type="button"
            phx-target={@myself}
            class="py-2 px-4 rounded-full bg-green-300"
            phx-click="add_input"
          >
            +
          </button>
        </div>

        <.inputs_for :let={input_nested} field={@form[:inputs]}>
          <.input_field
            name={"input_field:" <> Integer.to_string(input_nested.index)}
            index={input_nested.index}
            type={input_nested[:type].value}
            input_nested={input_nested}
            myself={@myself}
          />
        </.inputs_for>

        <:actions>
          <.button phx-disable-with="Salvando...">Salvar prompt</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{prompt: prompt} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn -> to_form(Prompts.change_prompt(prompt)) end)}
  end

  def handle_event("add_input", _params, socket) do
    socket =
      update(socket, :form, fn %{source: changeset} ->
        existing = Ecto.Changeset.get_embed(changeset, :inputs)
        changeset = Ecto.Changeset.put_embed(changeset, :inputs, existing ++ [%{}])
        to_form(changeset)
      end)

    {:noreply, socket}
  end

  def handle_event("delete_input", %{"index" => index}, socket) do
    index = String.to_integer(index)

    socket =
      update(socket, :form, fn %{source: changeset} ->
        existing = Ecto.Changeset.get_embed(changeset, :inputs)
        {to_delete, rest} = List.pop_at(existing, index)

        inputs =
          if Ecto.Changeset.change(to_delete).data.id do
            List.replace_at(existing, index, Ecto.Changeset.change(to_delete, delete: true))
          else
            rest
          end

        changeset
        |> Ecto.Changeset.put_embed(:inputs, inputs)
        |> to_form()
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"prompt" => prompt_params}, socket) do
    changeset =
      Prompts.change_prompt(socket.assigns.prompt, prompt_params) |> struct!(action: :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"prompt" => prompt_params}, socket) do
    save_prompt(socket, socket.assigns.action, prompt_params)
  end

  defp save_prompt(socket, :edit, prompt_params) do
    case Prompts.update_prompt(socket.assigns.prompt, prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        {:noreply,
         socket
         |> put_flash(:info, "Prompt updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_prompt(socket, :new, prompt_params) do
    case Prompts.create_prompt(prompt_params) do
      {:ok, prompt} ->
        notify_parent({:saved, prompt})

        {:noreply,
         socket
         |> put_flash(:info, "Prompt created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
