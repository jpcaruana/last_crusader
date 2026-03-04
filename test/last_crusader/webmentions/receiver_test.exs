defmodule LastCrusader.Webmentions.ReceiverTest do
  use ExUnit.Case, async: false
  import Tesla.Mock
  alias LastCrusader.Webmentions.Receiver
  alias LastCrusader.Webmentions.ReceivedWebmention
  alias LastCrusader.Repo

  setup do
    Repo.delete_all(ReceivedWebmention)
    :ok
  end

  describe "accept/2" do
    test "stores a pending record and returns {:ok, id}" do
      source = "https://example.com/post"
      target = "https://mysite.com/note/1"

      assert {:ok, id} = Receiver.accept(source, target)
      assert is_integer(id)

      record = Repo.get!(ReceivedWebmention, id)
      assert record.source == source
      assert record.target == target
      assert record.status == "pending"
    end
  end

  describe "verify/3 (synchronous status update)" do
    test "updates status to valid when source links to target" do
      source = "https://example.com/post"
      target = "https://mysite.com/note/1"
      {:ok, id} = Receiver.accept(source, target)

      mock(fn %{method: :get, url: ^source} ->
        {:ok, %Tesla.Env{status: 200, body: ~s(<a href="#{target}">link</a>)}}
      end)

      Receiver.verify(id, source, target)

      record = Repo.get!(ReceivedWebmention, id)
      assert record.status == "valid"
    end

    test "updates status to invalid when source does not link to target" do
      source = "https://example.com/post"
      target = "https://mysite.com/note/1"
      {:ok, id} = Receiver.accept(source, target)

      mock(fn %{method: :get, url: ^source} ->
        {:ok, %Tesla.Env{status: 200, body: "<p>No links here</p>"}}
      end)

      Receiver.verify(id, source, target)

      record = Repo.get!(ReceivedWebmention, id)
      assert record.status == "invalid"
    end
  end
end
