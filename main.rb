require 'rubygems'
require 'bundler/setup'
require 'json'
require 'sinatra'
require 'twilio-ruby'
require 'uri'
require 'net/http'

post '/joke/?:type?/?:format?' do
  category = params['Body']

  uri = URI('https://v2.jokeapi.dev/joke/'.concat(category))
  query_params = {
    :format => params['format'] != nil ? params['format'] : 'txt',
    :type => params['type'] != nil ? params['type'] : 'single'
  }
  uri.query = URI.encode_www_form(query_params)

  res = Net::HTTP.get_response(uri)
  response = Twilio::TwiML::MessagingResponse.new

  content_type "text/xml"
  response.message(body: res.body).to_s if res.is_a?(Net::HTTPSuccess)
end

