class ContactsController < ApplicationController
  before_action :authorize

  def index
    # https://developers.hubspot.com/docs/methods/contacts/get_contacts
    @contacts = Services::Hubspot::Contacts::GetAll.new(limit: 15).call
  end

  private

  def authorize
    raise(ExceptionHandler::HubspotError.new, 'Please authorize via OAuth2') if session['tokens'].blank?

    session['tokens'] = Services::Authorization::Tokens::Refresh.new(tokens: session['tokens']).call
    Services::Authorization::AuthorizeHubspot.new(tokens: session['tokens']).call
  end
end
