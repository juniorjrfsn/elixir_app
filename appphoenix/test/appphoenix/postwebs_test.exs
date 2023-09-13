defmodule Appphoenix.PostwebsTest do
  use Appphoenix.DataCase

  alias Appphoenix.Postwebs

  describe "posts" do
    alias Appphoenix.Postwebs.Postweb

    import Appphoenix.PostwebsFixtures

    @invalid_attrs %{title: nil, body: nil}

    test "list_posts/0 returns all posts" do
      postweb = postweb_fixture()
      assert Postwebs.list_posts() == [postweb]
    end

    test "get_postweb!/1 returns the postweb with given id" do
      postweb = postweb_fixture()
      assert Postwebs.get_postweb!(postweb.id) == postweb
    end

    test "create_postweb/1 with valid data creates a postweb" do
      valid_attrs = %{title: "some title", body: "some body"}

      assert {:ok, %Postweb{} = postweb} = Postwebs.create_postweb(valid_attrs)
      assert postweb.title == "some title"
      assert postweb.body == "some body"
    end

    test "create_postweb/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Postwebs.create_postweb(@invalid_attrs)
    end

    test "update_postweb/2 with valid data updates the postweb" do
      postweb = postweb_fixture()
      update_attrs = %{title: "some updated title", body: "some updated body"}

      assert {:ok, %Postweb{} = postweb} = Postwebs.update_postweb(postweb, update_attrs)
      assert postweb.title == "some updated title"
      assert postweb.body == "some updated body"
    end

    test "update_postweb/2 with invalid data returns error changeset" do
      postweb = postweb_fixture()
      assert {:error, %Ecto.Changeset{}} = Postwebs.update_postweb(postweb, @invalid_attrs)
      assert postweb == Postwebs.get_postweb!(postweb.id)
    end

    test "delete_postweb/1 deletes the postweb" do
      postweb = postweb_fixture()
      assert {:ok, %Postweb{}} = Postwebs.delete_postweb(postweb)
      assert_raise Ecto.NoResultsError, fn -> Postwebs.get_postweb!(postweb.id) end
    end

    test "change_postweb/1 returns a postweb changeset" do
      postweb = postweb_fixture()
      assert %Ecto.Changeset{} = Postwebs.change_postweb(postweb)
    end
  end
end
