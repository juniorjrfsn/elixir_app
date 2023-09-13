defmodule Appphoenix.PostsTest do
  use Appphoenix.DataCase

  alias Appphoenix.Posts

  describe "posts" do
    alias Appphoenix.Posts.Post

    import Appphoenix.PostsFixtures

    @invalid_attrs %{body: nil, title: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{body: "some body", title: "some title"}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.body == "some body"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{body: "some updated body", title: "some updated title"}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.body == "some updated body"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end

  describe "posts" do
    alias Appphoenix.Posts.Post

    import Appphoenix.PostsFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs)
      assert post.title == "some title"
      assert post.body == "some body"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.title == "some updated title"
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end

  describe "posts" do
    alias Appphoenix.Posts.PostWeb

    import Appphoenix.PostsFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list_posts/0 returns all posts" do
      post_web = post_web_fixture()
      assert Posts.list_posts() == [post_web]
    end

    test "get_post_web!/1 returns the post_web with given id" do
      post_web = post_web_fixture()
      assert Posts.get_post_web!(post_web.id) == post_web
    end

    test "create_post_web/1 with valid data creates a post_web" do
      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %PostWeb{} = post_web} = Posts.create_post_web(valid_attrs)
      assert post_web.title == "some title"
      assert post_web.body == "some body"
    end

    test "create_post_web/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post_web(@invalid_attrs)
    end

    test "update_post_web/2 with valid data updates the post_web" do
      post_web = post_web_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %PostWeb{} = post_web} = Posts.update_post_web(post_web, update_attrs)
      assert post_web.title == "some updated title"
      assert post_web.body == "some updated body"
    end

    test "update_post_web/2 with invalid data returns error changeset" do
      post_web = post_web_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post_web(post_web, @invalid_attrs)
      assert post_web == Posts.get_post_web!(post_web.id)
    end

    test "delete_post_web/1 deletes the post_web" do
      post_web = post_web_fixture()
      assert {:ok, %PostWeb{}} = Posts.delete_post_web(post_web)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post_web!(post_web.id) end
    end

    test "change_post_web/1 returns a post_web changeset" do
      post_web = post_web_fixture()
      assert %Ecto.Changeset{} = Posts.change_post_web(post_web)
    end
  end
end
