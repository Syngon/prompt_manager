defmodule PromptManager.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :text, :string
      add :description, :string
      add :title, :string
      add :inputs, {:array, :map}
      add :created_by_id, references(:accounts, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:prompts, [:created_by_id])
  end
end
