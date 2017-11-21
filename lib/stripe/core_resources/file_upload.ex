defmodule Stripe.FileUpload do
  @moduledoc """
  Work with Stripe file_upload objects.

  You can:

  - Create a file
  - Retrieve a file
  - List all files

  Stripe API reference: https://stripe.com/docs/api#file_uploads
  """

  use Stripe.Entity
  import Stripe.Request

  @type t :: %__MODULE__{
    id: Stripe.id,
    object: String.t,
    created: Stripe.timestamp,
    purpose: String.t,
    size: integer,
    type: String.t | nil,
    url: String.t | nil
  }

  defstruct [
    :id,
    :object,
    :created,
    :purpose,
    :size,
    :type,
    :url
  ]

  @plural_endpoint "files"

  @doc """
  Create a file according to Stripe's file_upload rules.

  Takes the filepath and the purpose.
  """
  @spec create(map, Keyword.t) :: {:ok, t} | {:error, Stripe.Error.t}
  def create(%{file: _, purpose: _} = params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:post)
    |> put_params(params)
    |> make_file_upload_request()
  end

  @doc """
  Retrieve a file_upload.
  """
  @spec retrieve(Stripe.id | t, Stripe.options) :: {:ok, t} | {:error, Stripe.Error.t}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_file_upload_request()
  end

  @doc """
  List all file uploads, going back up to 30 days.
  """
  @spec list(map, Stripe.options) :: {:ok, Stripe.List.of(t)} | {:error, Stripe.Error.t}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after, :limit, :purpose])
    |> make_file_upload_request()
  end
end
