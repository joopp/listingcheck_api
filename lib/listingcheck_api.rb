require "listingcheck_api/version"

require 'api_smith'

# api = ListingcheckApi::Client.new(:auth_token => 'your_ubersecret_token')
# place = ListingcheckApi::Place.new(:name => 'Bridges', :phone => '020-5553560', :address => 'Oudezijds Voorburgwal 197', :city => 'Amsterdam')
# scan = ListingcheckApi::Scan.new(:scan_group => 'restaurants', :place_attributes => place)
# api.create_scan(scan)
# api.post('listings_scans.json', {:extra_query => {:listings_scan => scan}})
# api.perform_scan
module ListingcheckApi

  class Place < APISmith::Smash
    property :name, :required => true
    property :phone
    property :address
    property :city
  end

  class Scan < APISmith::Smash
    property :access_token
    property :scan_group
    # property :email
    property :place, :transformer => Place
    property :place_attributes, :transformer => Place

    # FIXME: What is the proper way to do this?
    def scan!(client)
      client.perform_scan(self.access_token)
    end

  end

  class Client

    include APISmith::Client

    attr_reader :auth_token, :version

    # Options:
    # * :auth_token - Your ListingCheck Authentication token (API)
    # * :version - Version (defaults to 1)
    def initialize(options = {})
      @auth_token = options[:auth_token]
      @version = options[:version] || '1'

      self.class.base_uri(options[:base_uri] || 'api.listingscan.com')
      self.class.endpoint("api/v#{version}")

      add_query_options!(:auth_token => auth_token)
    end

    def scan(access_token)
      self.get("listings_scans/#{access_token}.json")
    end

    def create_scan(scan)
      self.post('listings_scans.json', {:extra_query => {:listings_scan => scan}})
    end

    def perform_scan(access_token)
      self.put("listings_scans/#{access_token}/scan.json")
    end

  end # Client

end
