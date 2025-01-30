defmodule PromptManager.PromptsTest do
  use PromptManager.DataCase

  alias PromptManager.Prompts

  describe "prompts" do
    alias PromptManager.Prompts.Prompt

    import PromptManager.PromptsFixtures

    @invalid_attrs %{text: nil, inputs: nil}

    test "list_prompts/0 returns all prompts" do
      prompt = prompt_fixture()
      assert Prompts.list_prompts() == [prompt]
    end

    test "get_prompt!/1 returns the prompt with given id" do
      prompt = prompt_fixture()
      assert Prompts.get_prompt!(prompt.id) == prompt
    end

    test "create_prompt/1 with valid data creates a prompt" do
      valid_attrs = %{text: "some text", inputs: []}

      assert {:ok, %Prompt{} = prompt} = Prompts.create_prompt(valid_attrs)
      assert prompt.text == "some text"
      assert prompt.inputs == []
    end

    test "create_prompt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Prompts.create_prompt(@invalid_attrs)
    end

    test "update_prompt/2 with valid data updates the prompt" do
      prompt = prompt_fixture()
      update_attrs = %{text: "some updated text", inputs: []}

      assert {:ok, %Prompt{} = prompt} = Prompts.update_prompt(prompt, update_attrs)
      assert prompt.text == "some updated text"
      assert prompt.inputs == []
    end

    test "update_prompt/2 with invalid data returns error changeset" do
      prompt = prompt_fixture()
      assert {:error, %Ecto.Changeset{}} = Prompts.update_prompt(prompt, @invalid_attrs)
      assert prompt == Prompts.get_prompt!(prompt.id)
    end

    test "delete_prompt/1 deletes the prompt" do
      prompt = prompt_fixture()
      assert {:ok, %Prompt{}} = Prompts.delete_prompt(prompt)
      assert_raise Ecto.NoResultsError, fn -> Prompts.get_prompt!(prompt.id) end
    end

    test "change_prompt/1 returns a prompt changeset" do
      prompt = prompt_fixture()
      assert %Ecto.Changeset{} = Prompts.change_prompt(prompt)
    end
  end
end
