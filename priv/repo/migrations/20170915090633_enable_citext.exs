defmodule Sync.Repo.Migrations.EnableCitext do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;"
  end

  def down do
    execute "DROP EXTENSION IF EXISTS citext;"
  end
end
