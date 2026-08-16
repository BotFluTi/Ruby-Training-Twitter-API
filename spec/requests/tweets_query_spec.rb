# frozen_string_literal: true

require "rails_helper"

RSpec.describe "tweets query", type: :request do
  fixtures :tweets, :resources, :comments

  # Rebuilds the whole data set with a fixed number of tweets and a varying
  # number of comments per tweet, then counts the queries the request runs.
  def queries_for(comments_per_tweet:)
    Resource.delete_all
    Comment.delete_all
    Tweet.delete_all

    2.times do |tweet_index|
      tweet = Tweet.create!(content: "Tweet #{tweet_index} https://12ft.io/")

      comments_per_tweet.times do |comment_index|
        comment = tweet.comments.create!(
          content: "Comment #{comment_index} https://12ft.io/"
        )

        comment.resources.create!(
          title: "A resource found in a comment",
          description: "An Open Graph description from a comment",
          url: "https://12ft.io/commented",
          image_url: "https://12ft.io/commented-banner.png",
          image_byte_size: 2048
        )
      end
    end

    # Not `perform_request`: it is a memoized subject and would only run once.
    count_queries do
      post "/graphql",
           params: { query: query },
           as: :json
    end
  end

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
          comments {
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
      }
    GRAPHQL
  end

  let(:returned_tweets) do
    JSON.parse(response.body).dig("data", "tweets")
  end

  let(:expected_tweet) do
    tweet = tweets(:with_url)
    resource = resources(:twelve_ft)
    comment = comments(:on_with_url)
    comment_resource = resources(:commented_twelve_ft)

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
      ],
      "comments" => [
        {
          "uuid" => comment.uuid,
          "message" => comment.content,
          "resources" => [
            {
              "title" => comment_resource.title,
              "description" => comment_resource.description,
              "url" => comment_resource.url,
              "image" => {
                "url" => comment_resource.image_url,
                "byteSize" => comment_resource.image_byte_size
              }
            }
          ]
        }
      ]
    }
  end

  it "returns all tweets with their comments and resources" do
    perform_request

    returned_tweet = returned_tweets.find do |tweet|
      tweet["uuid"] == tweets(:with_url).uuid
    end

    expect(returned_tweet).to eq(expected_tweet)
  end

  it "does not run more queries as comments are added" do
    queries_with_one = queries_for(comments_per_tweet: 1)
    queries_with_three = queries_for(comments_per_tweet: 3)

    expect(queries_with_three).to eq(queries_with_one)
  end

  it "returns an empty list without URL" do
    perform_request

    returned_tweet = returned_tweets.find do |tweet|
      tweet["uuid"] == tweets(:without_url).uuid
    end

    expect(returned_tweet["resources"]).to eq([])
  end
end
