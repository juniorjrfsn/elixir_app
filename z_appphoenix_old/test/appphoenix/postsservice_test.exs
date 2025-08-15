defmodule Appphoenix.PostsserviceTest do
  use Appphoenix.DataCase

  alias Appphoenix.Postsservice

  describe "posts" do
    alias Appphoenix.Postsservice.Postservice

    import Appphoenix.PostsserviceFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list_posts/0 returns all posts" do
      postservice = postservice_fixture()
      assert Postsservice.list_posts() == [postservice]
    end

    test "get_postservice!/1 returns the postservice with given id" do
      postservice = postservice_fixture()
      assert Postsservice.get_postservice!(postservice.id) == postservice
    end

    test "create_postservice/1 with valid data creates a postservice" do
      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %Postservice{} = postservice} = Postsservice.create_postservice(valid_attrs)
      assert postservice.title == "some title"
      assert postservice.body == "some body"
    end

    test "create_postservice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Postsservice.create_postservice(@invalid_attrs)
    end

    test "update_postservice/2 with valid data updates the postservice" do
      postservice = postservice_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %Postservice{} = postservice} = Postsservice.update_postservice(postservice, update_attrs)
      assert postservice.title == "some updated title"
      assert postservice.body == "some updated body"
    end

    test "update_postservice/2 with invalid data returns error changeset" do
      postservice = postservice_fixture()
      assert {:error, %Ecto.Changeset{}} = Postsservice.update_postservice(postservice, @invalid_attrs)
      assert postservice == Postsservice.get_postservice!(postservice.id)
    end

    test "delete_postservice/1 deletes the postservice" do
      postservice = postservice_fixture()
      assert {:ok, %Postservice{}} = Postsservice.delete_postservice(postservice)
      assert_raise Ecto.NoResultsError, fn -> Postsservice.get_postservice!(postservice.id) end
    end

    test "change_postservice/1 returns a postservice changeset" do
      postservice = postservice_fixture()
      assert %Ecto.Changeset{} = Postsservice.change_postservice(postservice)
    end
  end
end
