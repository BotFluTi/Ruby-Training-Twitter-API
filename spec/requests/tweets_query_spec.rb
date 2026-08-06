# frozen_string_literal: true

require "rails_helper"

RSpec.describe "tweets query", type: :request do
  fixtures :tweets, :resources

  subject(:perform_request) do
    post "/graphql",
         params: { query: query },
         as: :json
  end

  let(:query) do
    <<~GRAPHQL
      query {
        tweets {
          uuid
          message
          resources {
            title
            description
            url
            image {
              url
              byteSize
            }
          }
        }
      }
    GRAPHQL
  end

  let(:returned_tweets) do
    JSON.parse(response.body).dig("data", "tweets")
  end

  let(:expected_tweet) do
    tweet = tweets(:with_url)
    resource = resources(:twelve_ft)

    {
      "uuid" => tweet.uuid,
      "message" => tweet.content,
      "resources" => [
        {
          "title" => resource.title,
          "description" => resource.description,
          "url" => resource.url,
          "image" => {
            "url" => resource.image_url,
            "byteSize" => resource.image_byte_size
          }
        }
      ]
    }
  end

  it "returns all tweets with their resources" do
    perform_request

    returned_tweet = returned_tweets.find do |tweet|
      tweet["uuid"] == tweets(:with_url).uuid
    end

    expect(returned_tweet).to eq(expected_tweet)
  end

  it "returns an empty list without URL" do
    perform_request

    returned_tweet = returned_tweets.find do |tweet|
      tweet["uuid"] == tweets(:without_url).uuid
    end

    expect(returned_tweet["resources"]).to eq([])
  end
end
