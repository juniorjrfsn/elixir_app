defmodule Appphoenix.PostWebsTest do
  use Appphoenix.DataCase

  alias Appphoenix.PostWebs

  describe "posts" do
    alias Appphoenix.PostWebs.PostWeb

    import Appphoenix.PostWebsFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list_posts/0 returns all posts" do
      post_web = post_web_fixture()
      assert PostWebs.list_posts() == [post_web]
    end

    test "get_post_web!/1 returns the post_web with given id" do
      post_web = post_web_fixture()
      assert PostWebs.get_post_web!(post_web.id) == post_web
    end

    test "create_post_web/1 with valid data creates a post_web" do
      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %PostWeb{} = post_web} = PostWebs.create_post_web(valid_attrs)
      assert post_web.title == "some title"
      assert post_web.body == "some body"
    end

    test "create_post_web/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PostWebs.create_post_web(@invalid_attrs)
    end

    test "update_post_web/2 with valid data updates the post_web" do
      post_web = post_web_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %PostWeb{} = post_web} = PostWebs.update_post_web(post_web, update_attrs)
      assert post_web.title == "some updated title"
      assert post_web.body == "some updated body"
    end

    test "update_post_web/2 with invalid data returns error changeset" do
      post_web = post_web_fixture()
      assert {:error, %Ecto.Changeset{}} = PostWebs.update_post_web(post_web, @invalid_attrs)
      assert post_web == PostWebs.get_post_web!(post_web.id)
    end

    test "delete_post_web/1 deletes the post_web" do
      post_web = post_web_fixture()
      assert {:ok, %PostWeb{}} = PostWebs.delete_post_web(post_web)
      assert_raise Ecto.NoResultsError, fn -> PostWebs.get_post_web!(post_web.id) end
    end

    test "change_post_web/1 returns a post_web changeset" do
      post_web = post_web_fixture()
      assert %Ecto.Changeset{} = PostWebs.change_post_web(post_web)
    end
  end
end
