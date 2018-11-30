# README

## Simple open-source app to sell contra dance tickets via Stripe

* Sends email receipt
* Sends webhook to Zapier for logging of transactions in a Google spreadsheet

.env should include:
```shell
PUBLISHABLE_KEY=stripe_publishable_key
SECRET_KEY=stripe_secret_key
MAILGUN_API_KEY=mailgun_api_key
MAILGUN_DOMAIN=domain
ZAPIER_SPREADSHEET_WEBHOOK_URL=webhook_for_zapier_script_to_log_order_in_spreadsheet
```
