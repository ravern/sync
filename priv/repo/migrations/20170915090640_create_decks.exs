defmodule Sync.Repo.Migrations.CreateDecks do
  use Ecto.Migration

  def change do
    create table(:decks) do
      add :title, :citext
      add :password, :string

      timestamps()
    end

    create unique_index(:decks, [:title])
  end
end
