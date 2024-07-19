# TINYPESA PAYMENT INTEGRATION IN TELEGRAM BOT

> The script is an integration of tinypesa api service for payments in a bot. The code is in ruby; so you'll need the gems. Have a go!

[![Codecov](https://codecov.io/github/matthewhudson/words/branch/main/graph/badge.svg?token=oxazfuInJ9)](https://codecov.io/github/johnnzamba/Euphoria-Telegram_Bot)

### GENERAL WORKFLOW
This is a one of a kind integration of a telegram bot and TinyPesa Mobile Payment API service. Once the user chooses to make a payment; an STK push is made and the user prompted to make a payment. After successful payment(s) the transaction details are logged into the JSON file. 
However, what the script does is that once an STK push has been made, an external reference_no is generated to it. This ref_no is then used to get a transaction(s) status once the STK timeout.
The 1ˢᵗ response is logged into the JSON file, then the 2ⁿᵈ response is logged if the MPESA transaction is complete.

### Actual Bot Demo

<a href="https://64.media.tumblr.com/4c97cc380dbb4f2cab661a8f5a98219a/a3b0c2ab0935e4ae-c4/s540x810/3906009331e0446ce17d1c3bc0750a5a5a49fa84.pnj"><img src="https://64.media.tumblr.com/4c97cc380dbb4f2cab661a8f5a98219a/a3b0c2ab0935e4ae-c4/s540x810/3906009331e0446ce17d1c3bc0750a5a5a49fa84.pnj"/></a>
<br>
<a href="https://64.media.tumblr.com/1dc56792d43b7365fe5ea7d790f5ff83/a3b0c2ab0935e4ae-f2/s540x810/b730ca3f164f5f5339493ce8d19774ddb855e2ab.pnj"><img src="https://64.media.tumblr.com/1dc56792d43b7365fe5ea7d790f5ff83/a3b0c2ab0935e4ae-f2/s540x810/b730ca3f164f5f5339493ce8d19774ddb855e2ab.pnj"/></a>
<br>

### Payment Simulation
<a href="https://64.media.tumblr.com/3ae71e6edbb7a5aa50298460d12cdaed/93962b9c06f4042b-b2/s400x600/c59e907a7b9b65a483f7f5e0be8a5465f9561478.jpg"><img src="https://64.media.tumblr.com/3ae71e6edbb7a5aa50298460d12cdaed/93962b9c06f4042b-b2/s400x600/c59e907a7b9b65a483f7f5e0be8a5465f9561478.jpg"/></a>
<br>
<a href="https://64.media.tumblr.com/0528f2ac056bad7d5027066400c45bb3/93962b9c06f4042b-d7/s400x600/c9ae87c16d04052d745d123e27d1e844075cf86e.jpg"><img src="https://64.media.tumblr.com/0528f2ac056bad7d5027066400c45bb3/93962b9c06f4042b-d7/s400x600/c9ae87c16d04052d745d123e27d1e844075cf86e.jpg"/></a>
<br>
<a href="https://64.media.tumblr.com/51be6f3325b54b925f56f79e6cac24de/93962b9c06f4042b-fb/s540x810/45b5e03df3d3bba1fc699f920d4d32f74a312a80.jpg"><img src="https://64.media.tumblr.com/51be6f3325b54b925f56f79e6cac24de/93962b9c06f4042b-fb/s540x810/45b5e03df3d3bba1fc699f920d4d32f74a312a80.jpg"/></a>
<br>


## Installation

For Starters go to telegram and speak to the father of bots 😅 [@botFather](https://core.telegram.org/bots#botfather) and register a new bot 🤖 . After creating a bot, you'll receive personal details. Save the new <TELEGRAM_BOT_TOKEN> for use in our script.

The necessary instructions for API's are [here](https://tinypesa.com/developers/docs/1.0/overview).

Then to now access the script:

```bash
git clone https://github.com/johnnzamba/telepesa.git
```
```bash
cd telepesa
```

 ## ⚠️ IF YOU'VE NOT SET-UP RUBY
Ensure you have  RVM (Ruby Version Manager)in order to set up ruby. If not, visit [this link](https://rvm.io/rvm/install)

Now to check if RUBY is set up correctly:

```bash
ruby --version
```
```bash
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
```
```bash
\curl -sSL https://get.rvm.io | bash -s stable --ruby
```
Additionally, we'll need to set-up bundler essential in managing dependencies & deploying 🚀  in Ruby.

```bash
gem install bundler
```
Now in the Project Directory; the Gemfile contains necessary gems for the project. Run the following command to install the necessary gems:

```bash
bundle install
```

## Usage
Now the scripts can be run locally or on a server; 
To execute the script locally, run the following command:
```bash
bundle exec ruby tinypesa.rb
```
Please Note that the required APIs and Tokens are to be replaced in the file.

## Acknowledgement

I want to acknowledge that this project is solely owned by me. All rights, including intellectual property rights, are retained by the original owner. The code, design, and any associated content are proprietary. For any inquiries, Please contact me here 👉 [@](mailto:#{nzambakitheka@gmail.com}).

Thank you for your understanding and respect for the intellectual property rights associated with this project.


## License

Unless attributed otherwise, everything is under the MIT License (see LICENSE for more info).
