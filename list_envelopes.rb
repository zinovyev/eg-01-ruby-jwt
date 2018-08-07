require './example_base'

class ListEnvelopes < ExampleBase
  def list
    check_token
    envelope_api = DocuSign_eSign::EnvelopesApi.new(@@api_client)
    options =  DocuSign_eSign::ListStatusChangesOptions.new
    options.from_date = (Date.today - 30).strftime("%Y/%m/%d")
    envelope_api.list_status_changes(@@account_id, options)
  end
end