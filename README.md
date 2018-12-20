# Example 1: Ruby Service Integration

Repository: [eg-01-ruby-jwt](https://github.com/docusign/eg-01-ruby-jwt)

<!--
## Articles and Screencasts

* Guide: Using OAuth JWT flow with DocuSign.
* Screencast: Using OAuth JWT flow with DocuSign.
* Guide: Sending an envelope with the Node.JS SDK.
* Screencast: Sending an example with Node.JS SDK.
-->

## Introduction

This software is an example of a **System Integration**.
This type of application interacts with DocuSign on its
own. There is no user interface and no user is present
during normal operation.

The application uses the OAuth JWT grant flow to impersonate
a user in the account.

This launcher example includes two examples:
1. Send an html, Word, and PDF file in an envelope to be signed.
1. List the envelopes in the account if their status has changed in the last 30 days.

## Installation

Requirements: Ruby v2.1 or later

Download or clone this repository. Then:

````
cd eg-01-ruby-jwt
bundler install
````

Next step:

## Configuring the example's settings

Update two files to configure the example:

### Edit the `ds_config.rb` file in the root directory.

#### Creating the Integration Key (the client id)
Your DocuSign Integration Key must be configured for a JWT OAuth authentication flow:
* Create a public/private key pair for the key. Store the private key
  in a secure location. You can use a file or a key vault.
* The example requires the private key. Store the private key in the
  file `docusign_private_key.txt`. A future version of the SDK will
  enable the key to be supplied as a string to the SDK.
* If you will be using individual permission grants, you must create a
  `Redirect URI` for the key. Any URL can be used. By default, this
  example uses `https://www.docusign.com`

#### The impersonated user's guid
The JWT will impersonate a user within your account. The user can be
an individual or a user representing a group such as "HR".

The example needs the guid assigned to the user.
The guid value for each user in your account is available from
the Administration tool in the **Users** section.

To see a user's guid, **Edit** the user's information.
On the **Edit User** screen, the guid for the user is shown as
the `API Username`.
   
### Edit the file `docusign_private_key.txt` in the root directory.
   Add the Integration Key's private key to the file in PEM format.
   When you download the private key from the DocuSign Admin Tool, it
   is already in the right format.

   Include the lines BEGIN/END RSA PRIVATE KEY

## Run the examples

````
ruby main.rb
````

## Support, Contributions, License

Submit support questions to [StackOverflow](https://stackoverflow.com). Use tag `docusignapi`.

Contributions via Pull Requests are appreciated.
All contributions must use the MIT License.

This repository uses the MIT license, see the
[LICENSE](https://github.com/docusign/eg-01-ruby-jwt/blob/master/LICENSE) file.
