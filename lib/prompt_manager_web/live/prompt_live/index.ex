defmodule PromptManagerWeb.PromptLive.Index do
  use PromptManagerWeb, :live_view

  alias PromptManager.Prompts
  alias PromptManager.Prompts.Prompt

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :prompts, Prompts.list_prompts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit your Prompt")
    |> assign(:prompt, Prompts.get_prompt!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create a new Prompt")
    |> assign(:prompt, %Prompt{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing your Prompts")
    |> assign(:prompt, nil)
  end

  @impl true
  def handle_info({PromptManagerWeb.PromptLive.FormComponent, {:saved, prompt}}, socket) do
    {:noreply, stream_insert(socket, :prompts, prompt)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    prompt = Prompts.get_prompt!(id)
    {:ok, _} = Prompts.delete_prompt(prompt)

    {:noreply, stream_delete(socket, :prompts, prompt)}
  end
end
