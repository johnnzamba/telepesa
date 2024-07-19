require 'telegram/bot'
require 'httparty'
require 'json'
require 'fileutils'
require 'securerandom'

TELEGRAM_BOT_TOKEN = 'USE_YOURS_🤭'
TINYPES_API_KEY = '[LETS_GO_HERE](https://tinypesa.com/#get_tiny)'


class PaymentBot
  def initialize
    @current_state = {}
    @last_request_id = nil
    @account_no = nil
    @fetching_responses = false
    # Ensure the JSON file exists
    FileUtils.touch('stkResponse.json')
  end

  def handle_message(bot, message)
    chat_id = message.chat.id

    case message.text
    when '/start'
      send_start_message(bot, chat_id)
    else
      handle_user_input(bot, message, chat_id)
    end
  end

  def send_typing_action(bot, chat_id)
    bot.api.send_chat_action(chat_id: chat_id, action: 'typing')
    sleep(2)
  end

  def handle_callback(bot, callback_query)
    chat_id = callback_query.message.chat.id

    case callback_query.data
    when 'pay_tinypesa'
      @current_state[chat_id] = :awaiting_mobile
      bot.api.send_message(chat_id: chat_id, text: 'Enter your mobile number (in format 254XXXXXXXXX):')
    end
  end

  private

  def send_start_message(bot, chat_id)
    kb = [
      [Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Pay via Tinypesa', callback_data: 'pay_tinypesa')]
    ]
    markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
    bot.api.send_message(chat_id: chat_id, text: 'Choose an option:', reply_markup: markup)
  end

  def handle_user_input(bot, message, chat_id)
    case @current_state[chat_id]
    when :awaiting_mobile
      @mobile_number = message.text
      @current_state[chat_id] = :awaiting_amount
      bot.api.send_message(chat_id: chat_id, text: 'Enter the amount to be charged:')
    when :awaiting_amount
      amount = message.text
      @account_no = SecureRandom.uuid  
      send_payment_request(bot, chat_id, @mobile_number, amount, @account_no)
      @current_state.delete(chat_id)
    else
      bot.api.send_message(chat_id: chat_id, text: 'I didn\'t understand that command.')
    end
  end

  def send_payment_request(bot, chat_id, mobile_number, amount, account_no)
    response = HTTParty.post(
      'https://tinypesa.com/api/v1/express/initialize',
      headers: {
        'Accept' => 'application/json',
        'Apikey' => TINYPES_API_KEY
      },
      body: {
        'amount' => amount,
        'msisdn' => mobile_number,
        'account_no' => account_no
      }
    )

    if response.code == 200
      send_typing_action(bot, chat_id)
      bot.api.send_message(chat_id: chat_id, text: 'Payment request sent successfully. Please complete the payment on your phone.')
      response_data = response.parsed_response
      response_data['account_no'] = account_no 
      save_response(response_data)
      @last_request_id = response_data['request_id']
      @account_no = account_no
      start_response_fetcher
    else
      send_typing_action(bot, chat_id)
      bot.api.send_message(chat_id: chat_id, text: 'Failed to send payment request. Please try again.')
    end
  end

  def save_response(response, bot = nil, chat_id = nil)
    puts "Saving response: #{response.inspect}"

    existing_responses = []

    # Read existing responses if file is not empty
    if File.exist?('stkResponse.json') && !File.zero?('stkResponse.json')
      begin
        File.readlines('stkResponse.json').each do |line|
          existing_responses << JSON.parse(line)
        end
      rescue JSON::ParserError => e
        puts "Error parsing JSON file: #{e.message}"
        existing_responses = []
      end
    end

    if response.is_a?(Hash)
      # Handle the first type of response (without sync_status)
      if response.key?('success') && response['success']
        unless existing_responses.any? { |r| r['request_id'] == response['request_id'] }
          response['id'] = existing_responses.size + 1  # Number the response
          File.open('stkResponse.json', 'a') do |file|
            file.puts(response.to_json)
          end
        end
      # Handle the second type of response (with sync_status 'none')
      elsif response.key?('sync_status') && response['sync_status'] == 'none'
        unless existing_responses.any? { |r| r['request_id'] == response['request_id'] }
          response['id'] = existing_responses.size + 1  # Number the response
          File.open('stkResponse.json', 'a') do |file|
            file.puts(response.to_json)
          end
          # Notify the user of successful payment if the response is a status
          if bot && chat_id && response['is_complete'] == 1
            bot.api.send_message(chat_id: chat_id, text: 'Thank you! Your payment was received successfully.')
          end
        end
      else
        puts "Unexpected response format or sync_status not 'none': #{response.inspect}"
      end
    else
      puts "Unexpected response format: #{response.inspect}"
    end
  end

  def start_response_fetcher
    return if @fetching_responses

    @fetching_responses = true

    Thread.new do
      start_time = Time.now

      loop do
        fetch_and_save_new_responses
        sleep(30)
        break if Time.now - start_time > 120 # Stop after 2 minutes
      end

      @fetching_responses = false
    end
  end

  def fetch_and_save_new_responses
    return if @account_no.nil?

    response = HTTParty.get(
      "https://tinypesa.com/api/v1/express/get_status/#{@account_no}",
      headers: {
        'Accept' => 'application/json',
        'Apikey' => TINYPES_API_KEY
      }
    )

    if response.code == 200
      response_data = response.parsed_response
      if response_data.is_a?(Hash)
        save_response(response_data)
      else
        puts "Expected a Hash response but got: #{response_data.inspect}"
      end
    else
      puts "Failed to fetch status: #{response.code} #{response.message}"
    end
  rescue StandardError => e
    puts "Error fetching new responses: #{e.message}"
  end
end

Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
  payment_bot = PaymentBot.new

  bot.listen do |message|
    case message
    when Telegram::Bot::Types::Message
      payment_bot.handle_message(bot, message)
    when Telegram::Bot::Types::CallbackQuery
      payment_bot.handle_callback(bot, message)
    end
  end
end
