# ListingcheckApi

Ruby API to use the ListingCheck REST API.

ListingCheck allows you to scan the Internet for listings of a business. Multiple countries are supported. See for example http://www.goedvermeld.nl, for more information check http://www.listingcheck.com.

For more information on this Gem contact joost@joopp.com.

## Installation!

Add this line to your application's Gemfile:

    gem 'listingcheck_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install listingcheck_api

## Usage

    api = ListingcheckApi::Client.new(:auth_token => 'your_ubersecret_token')

### Scan

Locally setup a new Scan to perform:

    place = ListingcheckApi::Place.new(:name => 'Tam Tam', :phone => '015-7502000', :address => 'Patrijsweg 80', :city => 'Rijswijk')
    scan = ListingcheckApi::Scan.new(:scan_group => 'restaurants', :place_attributes => place)

Send API call to create the scan and next perform it.

    api.create_scan(scan)
    api.perform_scan(scan.access_token)

You will receive the Scan with a unique access_token and all matched listings.

### Listings

To directly retreive a certain Listing of which you know the uid and type.
With this request the Listing should exist at ListingCheck (eg. from a previous Scan)!

    api.listing('facebook_places_listing', 142709532406955)

To refresh a certain Listing from the original source:

    api.refresh_listing('facebook_places_listing', 142709532406955)

To create a new Listing (independent of a Scan):

    api.create_listing('facebook_places_listing', 142709532406955)

## Supported Listings

We currently support (among others) listings from:
Facebook Places, Twitter Places, Foursquare Venues, Gouden Gids België (Yellow Pages Belgium), SaySo, Qype, Tupalo (disabled), LinkedIn (disabled), Yell, Telefoonboek.nl, TomTom Places, Yelp, Zoekned.nl, Herold.at, Iens Belgium/Netherlands, Google Plus, Dinnersite, Das Örtliche, Local.ch, Infobel, Eet.nu, Cityplug, GelbeSeiten, Souschef, Resto.be, ..

New sites are added constantly, please contact us for more information.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
