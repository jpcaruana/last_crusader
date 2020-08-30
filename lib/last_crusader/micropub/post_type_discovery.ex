defmodule LastCrusader.Micropub.PostTypeDiscovery do
  @moduledoc """
    Indieweb Post Type discovery implementation

    see https://indieweb.org/post-type-discovery

    The Post Type Discovery algorithm ("the algorithm") discovers the type of a post given a data structure representing a post with a flat set of properties (e.g. Activity Streams (1.0 or 2.0) JSON, or JSON output from parsing [microformats2]), each with one or more values, by following these steps until reaching the first "it is a(n) ... post" statement at which point the "..." is the discovered post type.

        1. If the post has an "rsvp" property with a valid value,
        Then it is an RSVP post.
        2. If the post has an "in-reply-to" property with a valid URL,
        Then it is a reply post.
        3. If the post has a "repost-of" property with a valid URL,
        Then it is a repost (AKA "share") post.
        4. If the post has a "like-of" property with a valid URL,
        Then it is a like (AKA "favorite") post.
        5. If the post has a "video" property with a valid URL,
        Then it is a video post.
        6. If the post has a "photo" property with a valid URL,
        Then it is a photo post.
        7. If the post has a "content" property with a non-empty value,
        Then use its first non-empty value as the content
        8. Else if the post has a "summary" property with a non-empty value,
        Then use its first non-empty value as the content
        9. Else it is a note post.
        10. If the post has no "name" property
          or has a "name" property with an empty string value (or no value)
        Then it is a note post.
        11. Take the first non-empty value of the "name" property
        12. Trim all leading/trailing whitespace
        13. Collapse all sequences of internal whitespace to a single space (0x20) character each
        14. Do the same with the content
        15. If this processed "name" property value is NOT a prefix of the processed content,
        Then it is an article post.
        16. It is a note post.

    Quoted property names in the algorithm are defined in h-entry.
  """
  import LastCrusader.Utils.IdentifierValidator

  def discover(m = %{rvsp: value}) do
    case valid_rvsp_value(value) do
      true -> :rvsp
      _ -> pop_and_continue(m, :rvsp)
    end
  end
  def discover(m = %{"in-reply-to": url}) do
    #case validate_user_profile_url(url) do   # KO car fait une requete DNS pour de vrai :(
    #  :invalid -> pop_and_continue(m, "in-reply-to")
    #  _ -> :in_reply_to
    #end
    :in_reply_to
  end
  def discover(%{"repost-of": url}) do
    URI.parse(url)
    :repost_of
  end
  def discover(%{"like-of": url}) do
    URI.parse(url)
    :like_of
  end
  def discover(%{video: url}) do
    URI.parse(url)
    :video
  end
  def discover(%{photo: url}) do
    URI.parse(url)
    :photo
  end
  def discover(_) do
    :note
  end

  defp valid_rvsp_value(value) do
    String.downcase(value) in ["yes", "no", "maybe", "interested"]
  end

  defp pop_and_continue(map, key) do
    {_, new_map} = Map.pop(map, key)
    discover(new_map)
  end

end
