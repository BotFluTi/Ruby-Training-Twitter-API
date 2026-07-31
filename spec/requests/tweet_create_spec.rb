# frozen_string_literal: true

require "rails_helper"

RSpec.describe "tweetCreate mutation", type: :request do
  let(:mutation) do
    <<~GRAPHQL
      mutation($input: TweetCreateInput!) {
        tweetCreate(input: $input) {
          tweet {
            uuid
          }
        }
      }
    GRAPHQL
  end

  it "creates a tweet" do
    variables = {
      input: {
        content: "I don't know what I am doing!"
      }
    }

    expect do
      post "/graphql",
           params: { query: mutation, variables: variables },
           as: :json
    end.to change(Tweet, :count).by(1)

    result = JSON.parse(response.body)

    expect(response).to have_http_status(:ok)
    expect(result["errors"]).to be_nil
    expect(result.dig("data", "tweetCreate", "tweet", "uuid")).to be_present
    expect(Tweet.last.content).to eq(
                                    "I don't know what I am doing!"
                                  )
  end
end
