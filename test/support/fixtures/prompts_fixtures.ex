defmodule PromptManager.PromptsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PromptManager.Prompts` context.
  """

  @doc """
  Generate a prompt.
  """
  def prompt_fixture(attrs \\ %{}) do
    {:ok, prompt} =
      attrs
      |> Enum.into(%{
        inputs: [],
        text: "some text"
      })
      |> PromptManager.Prompts.create_prompt()

    prompt
  end
end
