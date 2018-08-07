require 'docusign_esign'
require './send_envelope'
require './example_base'
require './list_envelopes'
require 'yaml'
class Main
  def run
    configuration = DocuSign_eSign::Configuration.new
    @api_client = DocuSign_eSign::ApiClient.new(configuration)
    
    print("\nSending an envelope...")
    result = SendEnvelope.new(@api_client).sendEnvelope
    print("\nEnvelope status: %s. Envelope ID: %s\n" % [result.status, result.envelope_id])
    
    print("\nListing the account's envelopes...")
    envelopes_list = ListEnvelopes.new(@api_client).list
    envelopes = envelopes_list.envelopes
    if envelopes_list != nil and envelopes.length > 2
      print("\nResults for %d envelopes were returned. Showing the first two:" % [envelopes_list.envelopes.length])
      envelopes_list.envelopes = [envelopes[0], envelopes[1]]
    end

    envelopes_list.envelopes = [envelopes[0], envelopes[1]]
    print "\nResults: \n"
    puts envelopes_list.to_yaml
    print("\nDone.\n")

  rescue DocuSign_eSign::ApiError => err
    print "DocuSign SDK Error!\n   code: #{err.code}\n   message: #{err.response_body}\n\n"

  end
end

if __FILE__ == $0
  @main = Main.new()
  @main.run
end