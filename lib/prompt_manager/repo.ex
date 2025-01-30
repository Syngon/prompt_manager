defmodule PromptManager.Repo do
  use Ecto.Repo,
    otp_app: :prompt_manager,
    adapter: Ecto.Adapters.Postgres
end
