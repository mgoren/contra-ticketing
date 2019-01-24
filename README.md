# Contra-Ticketing

## Simple open-source app to sell contra dance tickets via Stripe

* Sends email receipt
* Sends webhook to Zapier for logging of transactions in a Google spreadsheet and sending email receipt

.env should include:
```shell
STRIPE_PUBLISHABLE_KEY=stripe_publishable_key
STRIPE_SECRET_KEY=stripe_secret_key
ZAPIER_SPREADSHEET_WEBHOOK_URL=webhook_for_zapier_script_to_log_order_in_spreadsheet
```
