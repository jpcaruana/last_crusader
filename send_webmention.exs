#! /usr/bin/env elixir
Mix.install([{:webmentions, "~> 3.0.0"}])

defmodule Sender do
  def send_webmention(source) do
    IO.puts("Sending webmentions to #{inspect(source)}")
    {:ok, webmention_response} = Webmentions.send_webmentions(source)
    Enum.each(webmention_response, fn x -> IO.puts("- #{inspect(x)}\n") end)
    IO.puts("DONE Sending webmentions to #{inspect(source)}")
  end
end

Enum.map(
  System.argv(),
  fn source ->
    Task.async(fn -> Sender.send_webmention(source) end)
  end
)
|> Task.await_many(:infinity)

IO.puts("All done!")
