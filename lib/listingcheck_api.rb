require "listingcheck_api/version"

require 'api_smith'

# api = ListingcheckApi::Client.new(:auth_token => 'your_ubersecret_token', :base_uri => '..')
# place = ListingcheckApi::Place.new(:name => 'Bridges', :phone => '020-5553560', :address => 'Oudezijds Voorburgwal 197', :city => 'Amsterdam')
# scan = ListingcheckApi::Scan.new(:scan_group => 'restaurants', :place_attributes => place)
# api.create_scan(scan)
# api.post('listings_scans.json', {:extra_query => {:listings_scan => scan}})
# api.perform_scan
# api.listing('facebook_places_listing', 142709532406955)
# api.refresh_listing('facebook_places_listing', 142709532406955)
# api.create_listing('facebook_places_listing', 142709532406955)
module ListingcheckApi

  class Listing < APISmith::Smash
    property :type
    property :uid
    property :url
    property :name
    property :full_address
    property :country_code

    property :phone
    property :fax
    property :website
    property :email

    property :lat
    property :lng

    property :rating
    property :reviews_count
    property :checkins_count
    property :likes_count
    property :talking_about_count
    property :were_here_count

    property :claimed
  end

  class Place < APISmith::Smash
    # Needed to create new Place for Scan
    property :name, :required => true
    property :phone, :required => true
    property :address, :required => true
    property :city, :required => true
    
    # Filled in
    property :country_code
    property :lat
    property :lng
  end

  class Scan < APISmith::Smash
    property :access_token
    property :scan_group
    # property :email
    property :place, :transformer => Place
    property :place_attributes, :transformer => Place

    property :matched_listings, :transformer => Listing
    property :error_listing_types

    def matched_listing_types
      matched_listings.collect(&:type)
    end

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
    # * :base_uri - Set if you want to use development version
    def initialize(options = {})
      @auth_token = options[:auth_token]
      @version = options[:version] || '1'

      self.class.base_uri(options[:base_uri] || 'api.listingcheck.com')
      self.class.endpoint("api/v#{version}")

      add_query_options!(:auth_token => auth_token)
    end

    # Opens a (Listing)Scan.
    def scan(access_token)
      self.get("listings_scans/#{access_token}.json", :transform => Scan)
    end

    # Creates a new Scan. Requires a associated Place.
    def create_scan(scan)
      self.post('listings_scans.json', {:extra_query => {:listings_scan => scan}, :transform => Scan})
    end

    # Performs a Scan (scans for Listings).
    def perform_scan(access_token)
      self.put("listings_scans/#{access_token}/scan.json", :transform => Scan)
    end

    # Gets a existing Listing of a particular type.
    #   listing('facebook_places_listing', 142709532406955)
    def listing(type, uid)
      self.get("listing_types/#{type}/listings/#{uid}.json", :transform => Listing)
    end

    # Gets or creates a new Listing of a particular type.
    def create_listing(type, uid)
      self.put("listing_types/#{type}/listings/#{uid}.json", :transform => Listing)
    end

    # Updates an existing Listing of a particular type with the latest info from the API.
    def refresh_listing(type, uid)
      self.put("listing_types/#{type}/listings/#{uid}/refresh.json", :transform => Listing)
    end

    def check_response_errors(response)
      # In 2XX range is success otherwise it's probably error (3XX redirects range is handled by HTTParty).
      # In case of error we lookup error class or default to ApiError.
      if not (200..299).include?(response.code)
        raise "Got HTTP code #{response.code} (#{response.message}) from API."
      end

      # Check JSON for error
      # if response.parsed_response.is_a?(Hash) and (error = response.parsed_response['error'])
      #   raise error
      # end
    end

  end # Client

end
