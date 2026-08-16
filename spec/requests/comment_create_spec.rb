# frozen_string_literal: true

require "rails_helper"

RSpec.describe "commentCreate mutation", type: :request do
  fixtures :tweets

  subject(:perform_request) do
    post "/graphql",
         params: { query: mutation, variables: variables },
         as: :json
  end

  let(:mutation) do
    <<~GRAPHQL
      mutation($input: CommentCreateInput!) {
        commentCreate(input: $input) {
          comment {
            uuid
          }
          errors
        }
      }
    GRAPHQL
  end

  let(:tweet) { tweets(:with_url) }
  let(:tweet_uuid) { tweet.uuid }
  let(:content) { "Nice link! https://12ft.io/" }

  let(:variables) do
    {
      input: {
        tweetUuid: tweet_uuid,
        content: content
      }
    }
  end

  it "creates a comment on the tweet" do
    expect { perform_request }
      .to change { tweet.comments.count }.by(1)
  end

  it "returns the comment UUID" do
    perform_request

    result = JSON.parse(response.body)

    expect(result.dig("data", "commentCreate", "comment", "uuid"))
      .to eq(tweet.comments.last.uuid)
  end

  it "returns no errors" do
    perform_request

    result = JSON.parse(response.body)

    expect(result.dig("data", "commentCreate", "errors")).to eq([])
  end

  it "adds the Open Graph scraper job for the comment" do
    expect { perform_request }
      .to have_enqueued_job(OpenGraphScraperJob)
            .with(record: an_instance_of(Comment))
  end

  context "when content is empty" do
    let(:content) { "" }

    it "does not create a comment" do
      expect { perform_request }
        .not_to change(Comment, :count)
    end

    it "does not add the scraper job" do
      expect { perform_request }
        .not_to have_enqueued_job(OpenGraphScraperJob)
    end

    it "returns the validation error" do
      perform_request

      result = JSON.parse(response.body)
      payload = result.dig("data", "commentCreate")

      expect(payload["comment"]).to be_nil
      expect(payload["errors"]).to include("Content can't be blank")
    end
  end

  context "when the tweet does not exist" do
    let(:tweet_uuid) { SecureRandom.uuid }

    it "returns a top-level error without creating a comment" do
      expect { perform_request }.not_to change(Comment, :count)

      result = JSON.parse(response.body)

      expect(result["errors"]).to be_present
      expect(result.dig("data", "commentCreate")).to be_nil
    end
  end
end
