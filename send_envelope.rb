require './example_base'
require './ds_config'
require 'base64'

class SendEnvelope < ExampleBase

  @@ENVELOPE_1_DOCUMENT_1 = %(
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="UTF-8">
      </head>
      <body style="font-family:sans-serif;margin-left:2em;">
        <h1 style="font-family: 'Trebuchet MS', Helvetica, sans-serif;"
              color: darkblue;margin-bottom: 0;">World Wide Corp</h1>
        <h2 style="font-family: 'Trebuchet MS', Helvetica, sans-serif;
              margin-top: 0px;margin-bottom: 3.5em;font-size: 1em;
              color: darkblue;">Order Processing Division</h2>
        <h4>Ordered by #{DSConfig.signer_name}</h4>
        <p style="margin-top:0em; margin-bottom:0em;">Email:  #{DSConfig.signer_email} </p>
        <p style="margin-top:0em; margin-bottom:0em;">Copy to: #{DSConfig.cc_name} , #{DSConfig.cc_email} </p>
        <p style="margin-top:3em;">
          Candy bonbon pastry jujubes lollipop wafer biscuit biscuit. Topping brownie sesame snaps
          sweet roll pie. Croissant danish biscuit soufflé caramels jujubes jelly. Dragée danish caramels lemon
          drops dragée. Gummi bears cupcake biscuit tiramisu sugar plum pastry.
          Dragée gummies applicake pudding liquorice. Donut jujubes oat cake jelly-o. Dessert bear claw chocolate
          cake gummies lollipop sugar plum ice cream gummies cheesecake.
        </p>
        <!-- Note the anchor tag for the signature field is in white. -->
        <h3 style="margin-top:3em;">Agreed: <span style="color:white;">**signature_1**</span></h3>
      </body>
    </html>
  )
  @@DOC_2_DOCX = 'World_Wide_Corp_Battle_Plan_Trafalgar.docx'
  @@DOC_3_PDF = 'World_Wide_Corp_lorem.pdf'


  def sendEnvelope
    check_token
    envelope = createEnvelope
    envelope_api = DocuSign_eSign::EnvelopesApi.new(@@api_client)
    result = envelope_api.create_envelope(@@account_id, envelope)
    result
  end

  def readContent(filename)
    File.read(File.join('data', filename))
  end

  def createEnvelope
    envelope_definition = DocuSign_eSign::EnvelopeDefinition.new
    envelope_definition.email_subject = "Please sign this document sent from Ruby SDK"

    doc1 = create_document_from_template("1", "Order acknowledgement", "html", @@ENVELOPE_1_DOCUMENT_1)
    doc2 = create_document_from_template("2", "Battle Plan", "docx", readContent(@@DOC_2_DOCX))
    doc3 = create_document_from_template("3", "Lorem Ipsum", "pdf", readContent(@@DOC_3_PDF))

    # The order in the docs array determines the order in the envelope
    envelope_definition.documents = [doc1, doc2, doc3]
    # create a signer recipient to sign the document, identified by name and email
    # We're setting the parameters via the object creation
    signer1 = create_signer
    # routingOrder (lower means earlier) determines the order of deliveries
    # to the recipients. Parallel routing order is supported by using the
    # same integer as the order for two or more recipients.

    # create a cc recipient to receive a copy of the documents, identified by name and email
    # We're setting the parameters via setters
    cc1 = create_carbon_copy()
    # Create signHere fields (also known as tabs) on the documents,
    # We're using anchor (autoPlace) positioning
    #
    # The DocuSign platform searches throughout your envelope's
    # documents for matching anchor strings. So the
    # sign_here_2 tab will be used in both document 2 and 3 since they
    # use the same anchor string for their "signer 1" tabs.
    sign_here1 = create_sign_here("**signature_1**", "pixels", "20", "10")
    sign_here2 = create_sign_here("/sn1/", "pixels", "20", "10")
    # Tabs are set per recipient / signer
    set_signer_tabs(signer1, [sign_here1, sign_here2])
    # Add the recipients to the envelope object
    recipients = create_recipients(signer1, cc1)
    envelope_definition.recipients = recipients
    # Request that the envelope be sent by setting |status| to "sent".
    # To request that the envelope be created as a draft, set to "created"
    envelope_definition.status = "sent"
    envelope_definition
  end

  def create_recipients(signer1, cc1)
    # code here
    recipients = DocuSign_eSign::Recipients.new
    recipients.signers = [signer1]
    recipients.carbon_copies = [cc1]
    recipients
  end

  def set_signer_tabs(signer1, signers)
    # code here
    tabs = DocuSign_eSign::Tabs.new
    tabs.sign_here_tabs = signers
    signer1.tabs = tabs
  end

  def create_sign_here(anchor_pattern, anchor_units, anchor_x_offset, anchor_y_offset)
    sign_here = DocuSign_eSign::SignHere.new
    sign_here.anchor_string = anchor_pattern
    sign_here.anchor_units = anchor_units
    sign_here.anchor_x_offset = anchor_x_offset
    sign_here.anchor_y_offset = anchor_y_offset
    sign_here
  end

  def create_carbon_copy
    # code here
    cc = DocuSign_eSign::CarbonCopy.new
    cc.email = DSConfig.cc_email
    cc.name = DSConfig.cc_name
    cc.routing_order = "2"
    cc.recipient_id = "2"
    cc
  end

  def create_signer
    # code here
    signer = DocuSign_eSign::Signer.new
    signer.email = DSConfig.signer_email
    signer.name = DSConfig.signer_name
    signer.recipient_id = "1"
    signer.routing_order = "1"
    signer
  end


  def create_document_from_template(id, name, file_extension, content)
    # code here
    document = DocuSign_eSign::Document.new

    document.document_base64 = Base64.encode64(content)

    # can be different from actual file name
    document.name = name
    # Source data format.Signed docs are always pdf.
    document.file_extension = file_extension
    # a label used to reference the doc
    document.document_id = id

    return document

  end
end
