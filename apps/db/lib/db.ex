defmodule DB do
  @moduledoc """
  This module provides API functions for other sub apps. These functions
  encapsulate database replication architecture.
  """

  @doc """
  Returns a repository module for primary database.
  """
  def primary do
    DB.Repo
  end

  @doc """
  Returns one of repository modules for replica databases.
  But for now it is same as primary one.
  """
  def replica do
    DB.Repo
  end

  @doc """
  Returns all repository modules.
  """
  def repos do
    [DB.Repo]
  end
end
