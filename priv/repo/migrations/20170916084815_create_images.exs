defmodule Sync.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :image, :string
      add :deck_id, references(:decks), on_delete: :delete_all

      timestamps()
    end
  end
end
